
module axi_pcie_example_top
#() 
(
    output  [3:0]   pci_exp_txp,
    output  [3:0]   pci_exp_txn,
    input   [3:0]   pci_exp_rxp,
    input   [3:0]   pci_exp_rxn,
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

    // AXI bus originating from PCIe AXI core
    // 128b data, 32b address
    AXI #(.DW(128)) 
    m_axi_pcie( 
        .aclk(      axi_clk_pcie    ), 
        .aresetn(   sys_resetn      ) 
    );

    axi_pcie_wrapper
    my_axi_pcie(
        .pci_exp_txp,
        .pci_exp_txn,
        .pci_exp_rxp,
        .pci_exp_rxn,
        .REFCLKp,
        .REFCLKn,
        .m_axi_pcie,
        .axi_clk_pcie,
        .sys_resetn,
        .mmcm_lock,
        .link_up
    );
    assign M2_LEDn = ~link_up;
    assign CLKREQn = 1'b0; //always request clock

    AXI #(.DW(32)) 
    m_axi_pcie32( 
        .aclk(      axi_clk_pcie    ), 
        .aresetn(   sys_resetn      ) 
    );

    // converts 128b AXI to 32b AXI
    axi_width_change_wrapper
    my_width_change(
        .upstream128(   m_axi_pcie      ),
        .downstream32(  m_axi_pcie32    )
    );

    AXI_lite
    m_axilite( 
        .aclk(      axi_clk_pcie    ), 
        .aresetn(   sys_resetn      ) 
    );
    
    axi_to_axilite_wrapper
    my_axi_to_axilite(
        .upstream(      m_axi_pcie32    ),
        .downstream(    m_axilite       )
    );
    
    axilite_gpio_wrapper
    my_gpio(
        .axilite(   m_axilite       ),
        .LEDn
    );

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


