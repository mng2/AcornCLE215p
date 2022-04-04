/*
    I call this a fake 16550A since it does not implement the 
    serializer/deserializer portion of the device. Instead the idea is
    to connect it bytewise to another UART, bypassing the ser/des on
    that side as well.
    
    Currently this module is recognized as a 16450 by the Linux kernel,
    meaning that the FIFOs that would make it a 16550A are not yet
    implemented. I feel my interest flagging so that is left as a TODO.
    
    The AXIlite interface is a simple one that can't support back-to-back
    operations on the R/W channels. There is no need for fully pipelined
    throughput here.
    
    The interrupt implementation at present does not hew exactly to the
    description in the datasheet. Priority is not implemented in the way
    described, where higher-priority interrupts will bump lower-priority
    ones, until frozen by a host read of IIR. Currently any interrupt
    will stay active until it is serviced or deactivated.
    
    Spec used: 1987 National Microcommunications Elements Data Book
*/

module fake_16550A #(
    parameter MODE_16450        = 1'b1,
    parameter UART_BASE_ADDR    = 32'h0000_0000
) (
    AXI_lite.S          axilite,
    input logic [7:0]   databyte_i,
    input logic         valid_i,
    output logic [7:0]  databyte_o,
    output logic        valid_o,
    output logic        interrupt_flag
);

    // Interrupt Enable Register, 1, DLAB=0
    typedef struct packed
    {
        logic [3:0] undefined;
        logic       EDSSI;      // b3 Enable MODEM Status Interrupt
        logic       ELSI;       // b2 Enable receiver Line Status Interrupt
        logic       ETBEI;      // b1 Enable Transmitter holding reg Empty Interrupt
        logic       ERBFI;      // b0 Enable Received data available Interrupt
    }   IER_t;
    IER_t IER = '0;
    localparam IERmask = 8'h0f;
    
    // Interrupt ID Register, 2 (Read-Only)
    typedef struct packed
    {
        logic       FIFOsEnabled7;
        logic       FIFOsEnabled6;
        logic       undefined5;
        logic       undefined4;
        logic [2:0] InterruptID;
        logic       InterruptPendingN;
    }   IIR_t;
    IIR_t IIR;
    
    // FIFO Control Register, 2 (Write-Only)
    typedef struct packed
    {
        logic       RCVR_Trigger_MSB;
        logic       RCVR_Trigger_LSB;
        logic       reserved5;
        logic       reserved4;
        logic       DMA_Mode_Select;
        logic       XMIT_FIFO_Reset;
        logic       RCVR_FIFO_Reset;
        logic       FIFO_Enable;
    }   FCR_t;
    FCR_t FCR;
    
    // Line Control Register, 3
    typedef struct packed
    {
        logic       DLAB;
        logic       SetBreak;
        logic       StickParity;
        logic       EPS;    // b4 Even Parity Select
        logic       PEN;    // b3 Parity Enable
        logic       STB;    // b2 Num Stop Bits
        logic [1:0] WLS;    // Word Length Select
    }   LCR_t;
    LCR_t LCR;
    
    // MODEM Control Register, 4
    typedef struct packed
    {
        logic [2:0] zeros;
        logic       Loop;
        logic       Out2;
        logic       Out1;
        logic       RTS;    // b1 Request To Send
        logic       DTR;    // b0 Data Terminal Ready
    } MCR_t;
    MCR_t MCR;
    localparam MCRmask = 8'h1f;
    
    // Line Status Register, 5
    typedef struct packed
    {
        logic       Err_RCVR_FIFO;
        logic       TEMT;   // b6 Transmitter Empty
        logic       THRE;   // b5 Transmitter Holding Register Empty
        logic       BI;     // b4 Break Interrupt
        logic       FE;     // b3 Framing Error
        logic       PE;     // b2 Parity Error
        logic       OE;     // b1 Overrun Error
        logic       DR;     // b0 Data Ready
    } LSR_t;
    LSR_t LSR;
    
    // MODEM Status Register, 6
    typedef struct packed
    {
        logic       DCD;    // b7 Data Carrier Detect
        logic       RI;     // b6 Ring Indicator
        logic       DSR;    // b5 Data Set Ready
        logic       CTS;    // b4 Clear To Send
        logic       DDCD;   // b3 Delta Data Carrier Detect
        logic       TERI;   // b2 Trailing Edge Ring Indicator
        logic       DDSR;   // b1 Delta Data Set Ready
        logic       DCTS;   // b0 Delta Clear To Send
    } MSR_t;
    MSR_t MSR;
    
    logic [7:0] SCR; // Scratch Register, 7
    logic [7:0] DLL; // Divisor Latch LSB, 0, DLAB=1
    logic [7:0] DLM; // Divisor Latch MSB, 1, DLAB=1
    
    logic           clk;
    logic           rst;
    (*DONT_TOUCH*) logic           uart_read_sel, uart_write_sel;
    logic [2:0]     uart_read_addr, uart_write_addr;
    (*DONT_TOUCH*) logic    err_b, err_r;
    
    logic           InterruptPending;
    logic [2:0]     InterruptID_16450;
    logic           RxOverrunErr;
    logic           RxDataReady;
    logic           THRwrite;
    logic [7:0]     THRtemp, THR;
    logic           THREmpty, TEMT;
    logic [7:0]     RBR;
    logic           RBRread, MSRread, LSRread;
    logic           baud_emulation_go, baud_emulation_busy;
    
    ////////////// UART logic ///////////////
    
    always_ff @(posedge clk) begin: p_RBR
        if (rst) begin
            RxDataReady     <= '0;
            RxOverrunErr    <= '0;
            RBR             <= '0;
        end else begin
            if (RxDataReady) begin
                if (valid_i & RBRread)
                    RBR <= databyte_i;
                else if (valid_i) begin
                    RBR <= databyte_i;
                    RxOverrunErr <= '1;
                end else if (RBRread)
                    RxDataReady <= '0;
            end else begin
                if (valid_i) begin
                    RBR <= databyte_i;
                    RxDataReady <= '1;
                end
            end
            if (LSRread)
                RxOverrunErr    <= '0;
        end
    end: p_RBR

    always_ff @(posedge clk) begin: p_THR
        if (rst) begin
            THREmpty            <= '1;
            valid_o             <= '0;
            databyte_o          <= '0;
            baud_emulation_go   <= '0;
        end else begin
            if (THREmpty) begin
                if (THRwrite) begin
                    THR         <= THRtemp;
                    THREmpty    <= '0;
                end
                baud_emulation_go   <= '0;
                valid_o             <= '0;
            end else begin //THR not empty
                // guess that there's no THR overwrite allowed
                if (~baud_emulation_busy) begin
                    baud_emulation_go   <= '1;
                    databyte_o          <= THR;
                    valid_o             <= '1;
                    THREmpty            <= '1;
                end else begin
                    baud_emulation_go   <= '0;
                    valid_o             <= '0;
                end
            end
        end
    end: p_THR
    
    // how baud selection appears to work
    // base rate is 115200 ~ 8.680556 us / symbol
    // use 9 symbols ~ 78.125 us / byte
    // clk = 100 MHz ~ 10 ns
    // call it 7812 clocks
    logic [28:0]    baud_counter;
    always_ff @(posedge clk) begin: p_baud_emulation
        if (rst)
            baud_counter <= '0;
        else begin
            if (baud_emulation_go)
                baud_counter <= 13'd7812 * {DLM, DLL};
            else if (baud_counter != '0)
                baud_counter <= baud_counter - 1;
        end
    end: p_baud_emulation
    
    assign baud_emulation_busy = baud_emulation_go || (baud_counter != '0);
    assign TEMT = (~THREmpty | baud_emulation_busy) ? '0 : '1;
    
    always_comb begin: p_IIR
        IIR.FIFOsEnabled7   = FCR.FIFO_Enable & ~MODE_16450;
        IIR.FIFOsEnabled6   = FCR.FIFO_Enable & ~MODE_16450;
        IIR.undefined5      = '0;
        IIR.undefined4      = '0;
        IIR.InterruptID     = {1'b0, InterruptID_16450};
        IIR.InterruptPendingN = ~InterruptPending;        
    end: p_IIR

    always_comb begin: p_LSR
        LSR.Err_RCVR_FIFO = '0; //todo
        LSR.TEMT = TEMT;    // b6 Transmitter Empty
        LSR.THRE = THREmpty;    // b5 Transmitter Holding Register
        LSR.BI = '0;        // this is a fake UART so these errors will never occur
        LSR.FE = '0;
        LSR.PE = '0;
        LSR.OE = RxOverrunErr;
        LSR.DR = RxDataReady;
    end: p_LSR
    
    always_comb begin: p_MSR
        MSR.DCD = (MCR.Loop) ? MCR.Out2 : '0;
        MSR.RI  = (MCR.Loop) ? MCR.Out1 : '0;
        MSR.DSR = (MCR.Loop) ? MCR.DTR : '1;
        MSR.CTS = (MCR.Loop) ? MCR.RTS : '1;
        MSR.DDCD = '0;
        MSR.TERI = '0;
        MSR.DDSR = '0;
        MSR.DCTS = '0;
    end: p_MSR
    
    ////////////// Interrupt State Machine ///////////////
    
    typedef enum {
        sIDLE, sRxLineStatus, sRxDataAvail, sTHRE, sModemStatus
    } interrupt_sm_t;
    interrupt_sm_t IntState, nextIntState;
    
    always_ff @(posedge clk) begin
        if (rst)
            IntState <= sIDLE;
        else
            IntState <= nextIntState;
    end
    
    always_comb begin
        nextIntState <= IntState;
        unique case (IntState)
            sIDLE: begin // handle interrupts with priority ordering
                if (IER.ELSI & (LSR.OE | LSR.PE | LSR.FE | LSR.BI))
                    nextIntState <= sRxLineStatus;
                else if (IER.ERBFI & LSR.DR)
                    nextIntState <= sRxDataAvail;
                else if (IER.ETBEI & LSR.THRE)
                    nextIntState <= sTHRE;
                else if (IER.EDSSI & (MSR.DCD | MSR.RI | MSR.DSR | MSR.CTS))
                    nextIntState <= sModemStatus;
            end
            sRxLineStatus:
                if (LSRread | ~IER.ELSI)
                    nextIntState <= sIDLE;
            sRxDataAvail:
                if (RBRread | ~IER.ERBFI)
                    nextIntState <= sIDLE;
            sTHRE:
                if (THRwrite | ~IER.ETBEI)
                    nextIntState <= sIDLE;
            sModemStatus:
                if (MSRread | ~IER.EDSSI)
                    nextIntState <= sIDLE;
        endcase
    end
    
    always_comb begin
        unique case (IntState)
            sIDLE: begin
                InterruptPending    = '0;
                InterruptID_16450   = 2'b00;
            end
            sRxLineStatus: begin
                InterruptPending    = '1;
                InterruptID_16450   = 2'b11;
            end
            sRxDataAvail: begin
                InterruptPending    = '1;
                InterruptID_16450   = 2'b10;
            end
            sTHRE: begin
                InterruptPending    = '1;
                InterruptID_16450   = 2'b01;
            end
            sModemStatus: begin
                InterruptPending    = '1;
                InterruptID_16450   = 2'b00;
            end
        endcase
    end
    
    assign interrupt_flag = InterruptPending;
    
    ////////////// AXI-lite interface ////////////////////
    
    always_comb begin
        clk = axilite.aclk;
        rst = ~axilite.aresetn;
        uart_write_sel  = (UART_BASE_ADDR[31:3]==axilite.awaddr[31:3]);
        uart_read_sel   = (UART_BASE_ADDR[31:3]==axilite.araddr[31:3]);
        uart_write_addr = axilite.awaddr[2:0];
        uart_read_addr  = axilite.araddr[2:0];
    end
    
    // use valid-before-ready for writes
    always_ff @(posedge clk) begin: p_axi_write
        if (rst) begin
            axilite.wready  <= 1'b0;
            axilite.awready <= 1'b0;
            THRwrite        <= 1'b0;
            IER             <= '0;
            FCR             <= '0;
            LCR             <= '0;
            MCR             <= '0;
            SCR             <= '0;
            DLL             <= 8'h10;
            DLM             <= '0;
        end else if (axilite.wready & axilite.awready) begin
            axilite.wready  <= 1'b0;
            axilite.awready <= 1'b0;
            THRwrite        <= 1'b0;
        end else if (axilite.wvalid & axilite.awvalid & uart_write_sel) begin
            axilite.wready  <= 1'b1;
            axilite.awready <= 1'b1;
            THRwrite        <= 1'b0;
            // assume no unaligned writes for now
            if (uart_write_addr[2]==1'b0) begin
                if (axilite.wstrb[0]) begin
                    if (LCR.DLAB==1'b0) begin
                        THRwrite    <= 1'b1;
                        THRtemp     <= axilite.wdata[7:0];
                    end else
                        DLL         <= axilite.wdata[7:0];
                end
                if (axilite.wstrb[1]) begin
                    if (LCR.DLAB==1'b0)
                        IER         <= axilite.wdata[15:8] & IERmask;
                    else
                        DLM         <= axilite.wdata[15:8];
                end
                if (axilite.wstrb[2])
                        FCR         <= axilite.wdata[23:16];
                if (axilite.wstrb[3])
                        LCR         <= axilite.wdata[31:24];
            end else begin//(uart_write_addr[2]==1'b1)
                if (axilite.wstrb[0])
                        MCR         <= axilite.wdata[7:0] & MCRmask;
                //if (axilite.wstrb[1])
                //        LSR         <= axilite.wdata[15:8]; // essentially read-only
                //if (axilite.wstrb[2])
                //        MSR         <= axilite.wdata[23:16]; // essentially read-only
                if (axilite.wstrb[3])
                        SCR         <= axilite.wdata[31:24];
            end
        end else begin
            axilite.wready  <= 1'b0;
            axilite.awready <= 1'b0;
            THRwrite        <= 1'b0;
        end
    end: p_axi_write
    
    logic b_pending;
    assign axilite.bresp = 2'b00; //all good
    always_ff @(posedge clk) begin: p_axi_b
        if (rst) begin
                axilite.bvalid  <= 1'b0;
                b_pending       <= 1'b0;
                err_b           <= 1'b0;
        end else begin
            if (axilite.bready & axilite.bvalid) begin
                axilite.bvalid  <= 1'b0;
                b_pending       <= 1'b0;
            end else if ((axilite.wvalid & axilite.wready) & (~axilite.bvalid)) begin
                axilite.bvalid  <= 1'b1;
                b_pending       <= 1'b1;
            end
            if (axilite.wvalid & b_pending)
                err_b           <= 1'b1;
        end
    end: p_axi_b
    
    // use valid-before-ready for read address
    always_ff @(posedge clk) begin: p_axi_read
        if (rst) begin
            axilite.arready <= '0;
            RBRread         <= '0;
            LSRread         <= '0;
            MSRread         <= '0;
            axilite.rdata   <= '0;
        end else begin
            if (axilite.arready) begin
                axilite.arready <= '0;
                RBRread         <= '0;
                LSRread         <= '0;
                MSRread         <= '0;
            end else if (axilite.arvalid & uart_read_sel) begin
                axilite.arready <= '1;
                //there can be unaligned reads
                //to avoid reading RBR
                if (uart_read_addr[2]==1'b0) begin
                    axilite.rdata[31:16]    <= {LCR, IIR};
                    axilite.rdata[15:8]     <= (LCR.DLAB) ? DLM : IER;
                    axilite.rdata[7:0]      <= (LCR.DLAB) ? DLL : '0;
                    if (uart_read_addr==3'd0) begin
                        axilite.rdata[7:0]  <= RBR;
                        RBRread             <= '1;
                    end
                end else begin
                    axilite.rdata <= {SCR, MSR, LSR, MCR};
                    if (uart_read_addr!=3'd7)
                        MSRread <= '1;
                    if (uart_read_addr<3'd6)
                        LSRread <= '1;
                end
            end
        end
    end: p_axi_read
    
    assign axilite.rresp = 2'd0;
    // Xilinx seems to use ready-before-valid for read resp
    always_ff @(posedge clk) begin: p_axi_rresp
        if (rst) begin
            axilite.rvalid  <= '0;
            err_r           <= '0;
        end else begin
            if (axilite.rready & axilite.rvalid)
                axilite.rvalid <= '0;
            else if (axilite.arvalid & axilite.arready) begin
                if (axilite.rvalid)
                    err_r <= '1;
                else
                    axilite.rvalid <= '1;
            end
        end
    end: p_axi_rresp
            
endmodule
