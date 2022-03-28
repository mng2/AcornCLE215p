
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
    
    //make a delay thing for loopback
    //hopefully maps onto BRAM
    logic [1023:0][8:0] delay  = '0;
    always_ff @(posedge axi_clk_pcie) begin
        delay[0] <= {uart_out_valid, uart_out_data};
        for (int i=1; i<=1023; i=i+1)
            delay[i] <= delay[i-1];
        uart_in_valid <= delay[1023][8];
        uart_in_data <= delay[1023][7:0];
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

endmodule


