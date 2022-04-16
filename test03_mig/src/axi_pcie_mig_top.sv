
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
    output          M2_LEDn,
    
    input           CLK200_P,
    input           CLK200_N,
    inout [15:0]    ddr3_dq,
    inout [1:0]     ddr3_dqs_n,
    inout [1:0]     ddr3_dqs_p,
    output [15:0]   ddr3_addr,
    output [2:0]    ddr3_ba,
    output          ddr3_ras_n,
    output          ddr3_cas_n,
    output          ddr3_we_n,
    output          ddr3_reset_n,
    output [0:0]    ddr3_ck_p,
    output [0:0]    ddr3_ck_n,
    output [0:0]    ddr3_cke,
    output [1:0]    ddr3_dm,
    output [0:0]    ddr3_odt
);

    logic           axi_clk_pcie;
    logic           sys_resetn;
    logic           mmcm_lock;
    logic           link_up;
    
    logic           mig_clk, mig_rst_out;

    // AXI bus originating from PCIe AXI core
    // 128b data, 32b address
    AXI #(.DW(128)) 
    axi_pcie( 
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
        .m_axi_pcie(axi_pcie),
        .axi_clk_pcie,
        .sys_resetn,
        .mmcm_lock,
        .link_up
    );
    assign M2_LEDn = ~link_up;
    assign CLKREQn = 1'b0; //always request clock

    AXI #(.DW(128)) 
    axi_mig( 
        .aclk(      mig_clk         ), 
        .aresetn(  ~mig_rst_out     ) 
    );

    // converts AXI to MIG clock
    axi_clock_conv_wrapper
    my_clock_change(
        .upstream128(   axi_pcie    ),
        .downstream128( axi_mig     )
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

    logic mig_mmcm_locked, init_calib_complete;
    
    mig_wrapper
    mig_wrapper_inst (
        .ddr3_addr,
        .ddr3_ba,
        .ddr3_cas_n,
        .ddr3_ck_n,
        .ddr3_ck_p,
        .ddr3_cke,
        .ddr3_ras_n,
        .ddr3_reset_n,
        .ddr3_we_n,
        .ddr3_dq,
        .ddr3_dqs_n,
        .ddr3_dqs_p,
        .ddr3_dm,
        .ddr3_odt,
        .sys_clk_p(CLK200_P),
        .sys_clk_n(CLK200_N),
        .mig_clk,
        .mig_rst_out,
        .mig_mmcm_locked,
        .axi128(axi_mig),
        .init_calib_complete,
        .sys_rst(sys_resetn)
    );
    
    assign LEDn[1] = ~mig_mmcm_locked;
    assign LEDn[2] = ~init_calib_complete;
    assign LEDn[3] = '1;
    assign LEDn[4] = '1;
    
endmodule


