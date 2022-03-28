
module axi_pcie_wrapper #(
    parameter L = 4  
) (
    output  [L-1:0] pci_exp_txp,
    output  [L-1:0] pci_exp_txn,
    input   [L-1:0] pci_exp_rxp,
    input   [L-1:0] pci_exp_rxn,
    input           REFCLKp,
    input           REFCLKn,
    AXI.M           axi_pcie_if,
    output          axi_clk_pcie,
    input           sys_resetn,
    output          mmcm_lock,
    output          link_up,
    input           msi_request,
    output          msi_grant,
    output          msi_enabled
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
        
    axi_pcie_x1g1 axi_pcie_inst (
      .axi_aresetn(     sys_resetn),              // input wire axi_aresetn
      .user_link_up(    link_up),            // output wire user_link_up
      .axi_aclk_out(    axi_clk_pcie),            // output wire axi_aclk_out
      .axi_ctl_aclk_out(axi_ctl_aclk_out),    // output wire axi_ctl_aclk_out
      .mmcm_lock(       mmcm_lock),                  // output wire mmcm_lock
      .interrupt_out(),                         // output wire interrupt_out to AXI side when root port
      .INTX_MSI_Request(msi_request),           // input wire INTX_MSI_Request rising edge detected?
      .INTX_MSI_Grant(  msi_grant),             // output wire INTX_MSI_Grant
      .MSI_enable(      msi_enabled),          // output when endpoint has MSI interrupts enabled
      .MSI_Vector_Num('0        ),             // input wire [4 : 0] MSI_Vector_Num
      .MSI_Vector_Width(),              // output wire [2 : 0] MSI_Vector_Width
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
      .m_axi_awaddr(axi_pcie_if.awaddr),            // output wire [31 : 0] m_axi_awaddr
      .m_axi_awlen(axi_pcie_if.awlen),              // output wire [7 : 0] m_axi_awlen
      .m_axi_awsize(axi_pcie_if.awsize),            // output wire [2 : 0] m_axi_awsize
      .m_axi_awburst(axi_pcie_if.awburst),          // output wire [1 : 0] m_axi_awburst
      .m_axi_awprot(axi_pcie_if.awprot),            // output wire [2 : 0] m_axi_awprot
      .m_axi_awvalid(axi_pcie_if.awvalid),          // output wire m_axi_awvalid
      .m_axi_awready(axi_pcie_if.awready),          // input wire m_axi_awready
      .m_axi_awlock(axi_pcie_if.awlock),            // output wire m_axi_awlock
      .m_axi_awcache(axi_pcie_if.awcache),          // output wire [3 : 0] m_axi_awcache
      .m_axi_wdata(axi_pcie_if.wdata),              // output wire [127 : 0] m_axi_wdata
      .m_axi_wstrb(axi_pcie_if.wstrb),              // output wire [15 : 0] m_axi_wstrb
      .m_axi_wlast(axi_pcie_if.wlast),              // output wire m_axi_wlast
      .m_axi_wvalid(axi_pcie_if.wvalid),            // output wire m_axi_wvalid
      .m_axi_wready(axi_pcie_if.wready),            // input wire m_axi_wready
      .m_axi_bresp(axi_pcie_if.bresp),              // input wire [1 : 0] m_axi_bresp
      .m_axi_bvalid(axi_pcie_if.bvalid),            // input wire m_axi_bvalid
      .m_axi_bready(axi_pcie_if.bready),            // output wire m_axi_bready
      .m_axi_araddr(axi_pcie_if.araddr),            // output wire [31 : 0] m_axi_araddr
      .m_axi_arlen(axi_pcie_if.arlen),              // output wire [7 : 0] m_axi_arlen
      .m_axi_arsize(axi_pcie_if.arsize),            // output wire [2 : 0] m_axi_arsize
      .m_axi_arburst(axi_pcie_if.arburst),          // output wire [1 : 0] m_axi_arburst
      .m_axi_arprot(axi_pcie_if.arprot),            // output wire [2 : 0] m_axi_arprot
      .m_axi_arvalid(axi_pcie_if.arvalid),          // output wire m_axi_arvalid
      .m_axi_arready(axi_pcie_if.arready),          // input wire m_axi_arready
      .m_axi_arlock(axi_pcie_if.arlock),            // output wire m_axi_arlock
      .m_axi_arcache(axi_pcie_if.arcache),          // output wire [3 : 0] m_axi_arcache
      .m_axi_rdata(axi_pcie_if.rdata),              // input wire [127 : 0] m_axi_rdata
      .m_axi_rresp(axi_pcie_if.rresp),              // input wire [1 : 0] m_axi_rresp
      .m_axi_rlast(axi_pcie_if.rlast),              // input wire m_axi_rlast
      .m_axi_rvalid(axi_pcie_if.rvalid),            // input wire m_axi_rvalid
      .m_axi_rready(axi_pcie_if.rready),            // output wire m_axi_rready
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


