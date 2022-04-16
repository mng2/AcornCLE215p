
module axi_pcie_wrapper #() 
(
    output  [3:0]   pci_exp_txp,
    output  [3:0]   pci_exp_txn,
    input   [3:0]   pci_exp_rxp,
    input   [3:0]   pci_exp_rxn,
    input           REFCLKp,
    input           REFCLKn,
    AXI.M           m_axi_pcie,
    output          axi_clk_pcie,
    input           sys_resetn,
    output          mmcm_lock,
    output          link_up
);

    // GT clock buffer for PCIe
    IBUFDS_GTE2 #(
        .CLKCM_CFG("TRUE"),   // Refer to UG482
        .CLKRCV_TRST("TRUE"),
        .CLKSWING_CFG(2'b11)
    )
    IBUFDS_GTE2_inst (
        .O(     REFCLK  ),
        .ODIV2(         ),
        .CEB(   1'b0    ),
        .I(     REFCLKp ),
        .IB(    REFCLKn )
    );
    
    axi_pcie_x4g2 axi_pcie_inst (
      .axi_aresetn(     sys_resetn),              // input wire axi_aresetn
      .user_link_up(    link_up),            // output wire user_link_up
      .axi_aclk_out(    axi_clk_pcie),            // output wire axi_aclk_out
      .axi_ctl_aclk_out(axi_ctl_aclk_out),    // output wire axi_ctl_aclk_out
      .mmcm_lock(       mmcm_lock),                  // output wire mmcm_lock
      .interrupt_out(interrupt_out),          // output wire interrupt_out
      .INTX_MSI_Request(1'b0    ),              // input wire INTX_MSI_Request
      .INTX_MSI_Grant(INTX_MSI_Grant),        // output wire INTX_MSI_Grant
      .MSI_enable(MSI_enable),                // output wire MSI_enable
      .MSI_Vector_Num('0        ),             // input wire [4 : 0] MSI_Vector_Num
      .MSI_Vector_Width(),    // output wire [2 : 0] MSI_Vector_Width
      .s_axi_awid('0),                // input wire [3 : 0] s_axi_awid
      .s_axi_awaddr('0),            // input wire [31 : 0] s_axi_awaddr
      .s_axi_awregion('0),        // input wire [3 : 0] s_axi_awregion
      .s_axi_awlen('0),              // input wire [7 : 0] s_axi_awlen
      .s_axi_awsize('0),            // input wire [2 : 0] s_axi_awsize
      .s_axi_awburst('0),          // input wire [1 : 0] s_axi_awburst
      .s_axi_awvalid(1'b0),          // input wire s_axi_awvalid
      .s_axi_awready(s_axi_awready),          // output wire s_axi_awready
      .s_axi_wdata('0),              // input wire [127 : 0] s_axi_wdata
      .s_axi_wstrb('0),              // input wire [15 : 0] s_axi_wstrb
      .s_axi_wlast('0),              // input wire s_axi_wlast
      .s_axi_wvalid(1'b0),            // input wire s_axi_wvalid
      .s_axi_wready(s_axi_wready),            // output wire s_axi_wready
      .s_axi_bid(s_axi_bid),                  // output wire [3 : 0] s_axi_bid
      .s_axi_bresp(s_axi_bresp),              // output wire [1 : 0] s_axi_bresp
      .s_axi_bvalid(s_axi_bvalid),            // output wire s_axi_bvalid
      .s_axi_bready(1'b0),            // input wire s_axi_bready
      .s_axi_arid('0),                // input wire [3 : 0] s_axi_arid
      .s_axi_araddr('0),            // input wire [31 : 0] s_axi_araddr
      .s_axi_arregion('0),        // input wire [3 : 0] s_axi_arregion
      .s_axi_arlen('0),              // input wire [7 : 0] s_axi_arlen
      .s_axi_arsize('0),            // input wire [2 : 0] s_axi_arsize
      .s_axi_arburst('0),          // input wire [1 : 0] s_axi_arburst
      .s_axi_arvalid(1'b0),          // input wire s_axi_arvalid
      .s_axi_arready(s_axi_arready),          // output wire s_axi_arready
      .s_axi_rid(s_axi_rid),                  // output wire [3 : 0] s_axi_rid
      .s_axi_rdata(s_axi_rdata),              // output wire [127 : 0] s_axi_rdata
      .s_axi_rresp(s_axi_rresp),              // output wire [1 : 0] s_axi_rresp
      .s_axi_rlast(s_axi_rlast),              // output wire s_axi_rlast
      .s_axi_rvalid(s_axi_rvalid),            // output wire s_axi_rvalid
      .s_axi_rready(1'b0),            // input wire s_axi_rready
      .m_axi_awaddr(m_axi_pcie.awaddr),            // output wire [31 : 0] m_axi_awaddr
      .m_axi_awlen(m_axi_pcie.awlen),              // output wire [7 : 0] m_axi_awlen
      .m_axi_awsize(m_axi_pcie.awsize),            // output wire [2 : 0] m_axi_awsize
      .m_axi_awburst(m_axi_pcie.awburst),          // output wire [1 : 0] m_axi_awburst
      .m_axi_awprot(m_axi_pcie.awprot),            // output wire [2 : 0] m_axi_awprot
      .m_axi_awvalid(m_axi_pcie.awvalid),          // output wire m_axi_awvalid
      .m_axi_awready(m_axi_pcie.awready),          // input wire m_axi_awready
      .m_axi_awlock(m_axi_pcie.awlock),            // output wire m_axi_awlock
      .m_axi_awcache(m_axi_pcie.awcache),          // output wire [3 : 0] m_axi_awcache
      .m_axi_wdata(m_axi_pcie.wdata),              // output wire [127 : 0] m_axi_wdata
      .m_axi_wstrb(m_axi_pcie.wstrb),              // output wire [15 : 0] m_axi_wstrb
      .m_axi_wlast(m_axi_pcie.wlast),              // output wire m_axi_wlast
      .m_axi_wvalid(m_axi_pcie.wvalid),            // output wire m_axi_wvalid
      .m_axi_wready(m_axi_pcie.wready),            // input wire m_axi_wready
      .m_axi_bresp(m_axi_pcie.bresp),              // input wire [1 : 0] m_axi_bresp
      .m_axi_bvalid(m_axi_pcie.bvalid),            // input wire m_axi_bvalid
      .m_axi_bready(m_axi_pcie.bready),            // output wire m_axi_bready
      .m_axi_araddr(m_axi_pcie.araddr),            // output wire [31 : 0] m_axi_araddr
      .m_axi_arlen(m_axi_pcie.arlen),              // output wire [7 : 0] m_axi_arlen
      .m_axi_arsize(m_axi_pcie.arsize),            // output wire [2 : 0] m_axi_arsize
      .m_axi_arburst(m_axi_pcie.arburst),          // output wire [1 : 0] m_axi_arburst
      .m_axi_arprot(m_axi_pcie.arprot),            // output wire [2 : 0] m_axi_arprot
      .m_axi_arvalid(m_axi_pcie.arvalid),          // output wire m_axi_arvalid
      .m_axi_arready(m_axi_pcie.arready),          // input wire m_axi_arready
      .m_axi_arlock(m_axi_pcie.arlock),            // output wire m_axi_arlock
      .m_axi_arcache(m_axi_pcie.arcache),          // output wire [3 : 0] m_axi_arcache
      .m_axi_rdata(m_axi_pcie.rdata),              // input wire [127 : 0] m_axi_rdata
      .m_axi_rresp(m_axi_pcie.rresp),              // input wire [1 : 0] m_axi_rresp
      .m_axi_rlast(m_axi_pcie.rlast),              // input wire m_axi_rlast
      .m_axi_rvalid(m_axi_pcie.rvalid),            // input wire m_axi_rvalid
      .m_axi_rready(m_axi_pcie.rready),            // output wire m_axi_rready
      .pci_exp_txp(pci_exp_txp),              // output wire [3 : 0] pci_exp_txp
      .pci_exp_txn(pci_exp_txn),              // output wire [3 : 0] pci_exp_txn
      .pci_exp_rxp(pci_exp_rxp),              // input wire [3 : 0] pci_exp_rxp
      .pci_exp_rxn(pci_exp_rxn),              // input wire [3 : 0] pci_exp_rxn
      .REFCLK(REFCLK),                        // input wire REFCLK
      .s_axi_ctl_awaddr('0),    // input wire [31 : 0] s_axi_ctl_awaddr
      .s_axi_ctl_awvalid(1'b0),  // input wire s_axi_ctl_awvalid
      .s_axi_ctl_awready(s_axi_ctl_awready),  // output wire s_axi_ctl_awready
      .s_axi_ctl_wdata('0),      // input wire [31 : 0] s_axi_ctl_wdata
      .s_axi_ctl_wstrb('0),      // input wire [3 : 0] s_axi_ctl_wstrb
      .s_axi_ctl_wvalid(1'b0),    // input wire s_axi_ctl_wvalid
      .s_axi_ctl_wready(s_axi_ctl_wready),    // output wire s_axi_ctl_wready
      .s_axi_ctl_bresp(s_axi_ctl_bresp),      // output wire [1 : 0] s_axi_ctl_bresp
      .s_axi_ctl_bvalid(s_axi_ctl_bvalid),    // output wire s_axi_ctl_bvalid
      .s_axi_ctl_bready(1'b0),    // input wire s_axi_ctl_bready
      .s_axi_ctl_araddr('0),    // input wire [31 : 0] s_axi_ctl_araddr
      .s_axi_ctl_arvalid(1'b0),  // input wire s_axi_ctl_arvalid
      .s_axi_ctl_arready(s_axi_ctl_arready),  // output wire s_axi_ctl_arready
      .s_axi_ctl_rdata(s_axi_ctl_rdata),      // output wire [31 : 0] s_axi_ctl_rdata
      .s_axi_ctl_rresp(s_axi_ctl_rresp),      // output wire [1 : 0] s_axi_ctl_rresp
      .s_axi_ctl_rvalid(s_axi_ctl_rvalid),    // output wire s_axi_ctl_rvalid
      .s_axi_ctl_rready(1'b0)    // input wire s_axi_ctl_rready
    );

endmodule


