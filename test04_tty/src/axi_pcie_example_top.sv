
module axi_pcie_example_top #( 
    parameter L = 1
) (
    output  [L-1:0] pci_exp_txp,
    output  [L-1:0] pci_exp_txn,
    input   [L-1:0] pci_exp_rxp,
    input   [L-1:0] pci_exp_rxn,
    input           REFCLKp,
    input           REFCLKn,
    input           PERSTn,
    output          CLKREQn,
    input           CLK200_P,
    input           CLK200_N,
    output  [4:1]   LEDn,
    output          M2_LEDn
);

    logic           axi_clk_pcie;
    logic           sys_resetn;
    logic           mmcm_lock;
    logic           link_up;
    (* dont_touch="true" *) logic msi_request, msi_grant, msi_enabled;

    logic [7:0]     uart_in_data, uart_out_data;
    logic           uart_in_valid, uart_out_valid;
    logic           uart_interrupt;

    // AXI bus originating from PCIe AXI core
    // 64b data, 32b address
    AXI #(.DW(64)) 
    axi_pcie_if( 
        .aclk(      axi_clk_pcie    ), 
        .aresetn(   sys_resetn      ) 
    );

    axi_pcie_wrapper #(
        .L(L)
    ) my_axi_pcie (
        .pci_exp_txp,
        .pci_exp_txn,
        .pci_exp_rxp,
        .pci_exp_rxn,
        .REFCLKp,
        .REFCLKn,
        .axi_pcie_if,
        .axi_clk_pcie,
        .sys_resetn,
        .mmcm_lock,
        .link_up,
        .msi_request,
        .msi_grant,
        .msi_enabled
    );
    assign M2_LEDn = ~link_up;
    assign CLKREQn = 1'b0; //always request clock

    AXI #(.DW(32)) 
    axi_pcie32_if( 
        .aclk(          axi_clk_pcie    ), 
        .aresetn(       sys_resetn      ) 
    );

    // converts 64b AXI to 32b AXI
    axi_width_change_wrapper
    my_width_change(
        .upstream(      axi_pcie_if     ),
        .downstream32(  axi_pcie32_if   )
    );

(*DONT_TOUCH*)    AXI_lite
    axilite_if( 
        .aclk(          axi_clk_pcie    ), 
        .aresetn(       sys_resetn      ) 
    );
    
    axi_to_axilite_wrapper
    my_axi_to_axilite(
        .upstream(      axi_pcie32_if   ),
        .downstream(    axilite_if      )
    );
    
    fake_16550A #(
        .UART_BASE_ADDR(32'h0000_0000   )
    ) my_uart (
        .axilite(       axilite_if      ),
        .databyte_i(    uart_in_data    ),
        .valid_i(       uart_in_valid   ),
        .databyte_o(    uart_out_data   ),
        .valid_o(       uart_out_valid  ),
        .interrupt_flag(uart_interrupt  )
    );
    
    // interrupt handling
    logic uart_interrupt_p;
    logic uart_int_pending;
    logic uart_int_rise, uart_int_fall;
    assign uart_int_rise = ~uart_interrupt_p & uart_interrupt;
    assign uart_int_fall = uart_interrupt_p & ~uart_interrupt;
    always_ff @(posedge axi_clk_pcie) begin
        if (~sys_resetn) begin
            uart_interrupt_p    <= '0;
            msi_request         <= '0;
        end else
            uart_interrupt_p <= uart_interrupt;
        
        if (msi_enabled)
            if (~msi_request) begin
                if (uart_int_rise)
                    msi_request <= '1;
                else if (uart_int_pending) begin
                    msi_request <= '1;
                    uart_int_pending <= '0;
                end
            end else begin
                if (uart_int_rise)
                    uart_int_pending <= '1;
                if (msi_grant)
                    msi_request <= '0;
            end
    end

    // reset needs to be held for 16 cycles after things stabilize
    logic [4:0] reset_counter = '0;
    always_ff @(posedge axi_clk_pcie) begin
        if (!mmcm_lock | !PERSTn)
            reset_counter <= '0;
        else if (reset_counter < 16)
            reset_counter <= reset_counter + 1;
    end
    assign sys_resetn = reset_counter[4];
    
    ////////////////////// NEORV32 /////////////////////////
    
    logic       clk100;
    logic       rst_neorv32 = '0;
    logic [7:0] gpio;
    logic [7:0] brt0_txd_o, brt0_rxd_i;
    logic       brt0_txd_valid, brt0_rxd_valid;
    
    neorv32_bootloader_200 myneorv32
    (
        .CLK200_P,
        .CLK200_N,
        .rstn_i(        ~rst_neorv32    ),
        .clk100,
        .gpio_o(        gpio            ),
        .brt0_txd_o,
        .brt0_rxd_i,
        .brt0_txd_valid,
        .brt0_rxd_valid
    );
    
    assign LEDn = ~gpio[3:0];

    xpm_cdc_hs_wrap
    xpm_cdc_neo2pcie (
      .dest_out(    uart_in_data    ), 
      .dest_req(    uart_in_valid   ),
      .dest_clk(    axi_clk_pcie    ),
      .src_clk(     clk100          ),
      .src_in(      brt0_txd_o      ),
      .src_send(    brt0_txd_valid  )
   );
   
    xpm_cdc_hs_wrap
    xpm_cdc_pcie2neo (
      .dest_out(    brt0_rxd_i      ), 
      .dest_req(    brt0_rxd_valid  ),
      .dest_clk(    clk100          ),
      .src_clk(     axi_clk_pcie    ),
      .src_in(      uart_out_data   ),
      .src_send(    uart_out_valid  )
   );

endmodule: axi_pcie_example_top


module xpm_cdc_hs_wrap #(
    parameter WIDTH = 8
) (
    input               src_clk,
    input               src_send,
    input [WIDTH-1:0]   src_in,
    output              dest_clk,
    output              dest_req,
    output [WIDTH-1:0]  dest_out
);

    logic   src_rcv;
    logic   maintain = '0;

    xpm_cdc_handshake #(
      .DEST_EXT_HSK(0),
      .DEST_SYNC_FF(4),
      .INIT_SYNC_FF(0),
      .SIM_ASSERT_CHK(0),
      .SRC_SYNC_FF(4),
      .WIDTH(WIDTH)
    ) xpm_cdc_hs_inst (
      .dest_out, 
      .dest_req,
      .dest_ack( '0 ),
      .dest_clk,
      .src_rcv,
      .src_clk,
      .src_in,
      .src_send( src_send | maintain )
    );
   
    // need to keep send high until handshake comes back from the other side
    always_ff @(posedge src_clk) begin
        if (src_send)
            maintain <= '1;
        else if (src_rcv)
            maintain <= '0;
    end

endmodule: xpm_cdc_hs_wrap
