
module axi_width_change_wrapper #() 
(
    AXI.S   upstream128,
    AXI.M   downstream32
);

    axi_dwconv_128_32 
    my_128_32 (
        .s_axi_aclk(upstream128.aclk),          // input wire s_axi_aclk
        .s_axi_aresetn(upstream128.aresetn),    // input wire s_axi_aresetn
        .s_axi_awaddr(upstream128.awaddr),      // input wire [31 : 0] s_axi_awaddr
        .s_axi_awlen(upstream128.awlen),        // input wire [7 : 0] s_axi_awlen
        .s_axi_awsize(upstream128.awsize),      // input wire [2 : 0] s_axi_awsize
        .s_axi_awburst(upstream128.awburst),    // input wire [1 : 0] s_axi_awburst
        .s_axi_awlock(upstream128.awlock),      // input wire [0 : 0] s_axi_awlock
        .s_axi_awcache(upstream128.awcache),    // input wire [3 : 0] s_axi_awcache
        .s_axi_awprot(upstream128.awprot),      // input wire [2 : 0] s_axi_awprot
        .s_axi_awregion(upstream128.awregion),  // input wire [3 : 0] s_axi_awregion
        .s_axi_awqos(upstream128.awqos),        // input wire [3 : 0] s_axi_awqos
        .s_axi_awvalid(upstream128.awvalid),    // input wire s_axi_awvalid
        .s_axi_awready(upstream128.awready),    // output wire s_axi_awready
        .s_axi_wdata(upstream128.wdata),        // input wire [127 : 0] s_axi_wdata
        .s_axi_wstrb(upstream128.wstrb),        // input wire [15 : 0] s_axi_wstrb
        .s_axi_wlast(upstream128.wlast),        // input wire s_axi_wlast
        .s_axi_wvalid(upstream128.wvalid),      // input wire s_axi_wvalid
        .s_axi_wready(upstream128.wready),      // output wire s_axi_wready
        .s_axi_bresp(upstream128.bresp),        // output wire [1 : 0] s_axi_bresp
        .s_axi_bvalid(upstream128.bvalid),      // output wire s_axi_bvalid
        .s_axi_bready(upstream128.bready),      // input wire s_axi_bready
        .s_axi_araddr(upstream128.araddr),      // input wire [31 : 0] s_axi_araddr
        .s_axi_arlen(upstream128.arlen),        // input wire [7 : 0] s_axi_arlen
        .s_axi_arsize(upstream128.arsize),      // input wire [2 : 0] s_axi_arsize
        .s_axi_arburst(upstream128.arburst),    // input wire [1 : 0] s_axi_arburst
        .s_axi_arlock(upstream128.arlock),      // input wire [0 : 0] s_axi_arlock
        .s_axi_arcache(upstream128.arcache),    // input wire [3 : 0] s_axi_arcache
        .s_axi_arprot(upstream128.arprot),      // input wire [2 : 0] s_axi_arprot
        .s_axi_arregion(upstream128.arregion),  // input wire [3 : 0] s_axi_arregion
        .s_axi_arqos(upstream128.arqos),        // input wire [3 : 0] s_axi_arqos
        .s_axi_arvalid(upstream128.arvalid),    // input wire s_axi_arvalid
        .s_axi_arready(upstream128.arready),    // output wire s_axi_arready
        .s_axi_rdata(upstream128.rdata),        // output wire [127 : 0] s_axi_rdata
        .s_axi_rresp(upstream128.rresp),        // output wire [1 : 0] s_axi_rresp
        .s_axi_rlast(upstream128.rlast),        // output wire s_axi_rlast
        .s_axi_rvalid(upstream128.rvalid),      // output wire s_axi_rvalid
        .s_axi_rready(upstream128.rready),      // input wire s_axi_rready
        .m_axi_awaddr(downstream32.awaddr),      // output wire [31 : 0] m_axi_awaddr
        .m_axi_awlen(downstream32.awlen),        // output wire [7 : 0] m_axi_awlen
        .m_axi_awsize(downstream32.awsize),      // output wire [2 : 0] m_axi_awsize
        .m_axi_awburst(downstream32.awburst),    // output wire [1 : 0] m_axi_awburst
        .m_axi_awlock(downstream32.awlock),      // output wire [0 : 0] m_axi_awlock
        .m_axi_awcache(downstream32.awcache),    // output wire [3 : 0] m_axi_awcache
        .m_axi_awprot(downstream32.awprot),      // output wire [2 : 0] m_axi_awprot
        .m_axi_awregion(downstream32.awregion),  // output wire [3 : 0] m_axi_awregion
        .m_axi_awqos(downstream32.awqos),        // output wire [3 : 0] m_axi_awqos
        .m_axi_awvalid(downstream32.awvalid),    // output wire m_axi_awvalid
        .m_axi_awready(downstream32.awready),    // input wire m_axi_awready
        .m_axi_wdata(downstream32.wdata),        // output wire [31 : 0] m_axi_wdata
        .m_axi_wstrb(downstream32.wstrb),        // output wire [3 : 0] m_axi_wstrb
        .m_axi_wlast(downstream32.wlast),        // output wire m_axi_wlast
        .m_axi_wvalid(downstream32.wvalid),      // output wire m_axi_wvalid
        .m_axi_wready(downstream32.wready),      // input wire m_axi_wready
        .m_axi_bresp(downstream32.bresp),        // input wire [1 : 0] m_axi_bresp
        .m_axi_bvalid(downstream32.bvalid),      // input wire m_axi_bvalid
        .m_axi_bready(downstream32.bready),      // output wire m_axi_bready
        .m_axi_araddr(downstream32.araddr),      // output wire [31 : 0] m_axi_araddr
        .m_axi_arlen(downstream32.arlen),        // output wire [7 : 0] m_axi_arlen
        .m_axi_arsize(downstream32.arsize),      // output wire [2 : 0] m_axi_arsize
        .m_axi_arburst(downstream32.arburst),    // output wire [1 : 0] m_axi_arburst
        .m_axi_arlock(downstream32.arlock),      // output wire [0 : 0] m_axi_arlock
        .m_axi_arcache(downstream32.arcache),    // output wire [3 : 0] m_axi_arcache
        .m_axi_arprot(downstream32.arprot),      // output wire [2 : 0] m_axi_arprot
        .m_axi_arregion(downstream32.arregion),  // output wire [3 : 0] m_axi_arregion
        .m_axi_arqos(downstream32.arqos),        // output wire [3 : 0] m_axi_arqos
        .m_axi_arvalid(downstream32.arvalid),    // output wire m_axi_arvalid
        .m_axi_arready(downstream32.arready),    // input wire m_axi_arready
        .m_axi_rdata(downstream32.rdata),        // input wire [31 : 0] m_axi_rdata
        .m_axi_rresp(downstream32.rresp),        // input wire [1 : 0] m_axi_rresp
        .m_axi_rlast(downstream32.rlast),        // input wire m_axi_rlast
        .m_axi_rvalid(downstream32.rvalid),      // input wire m_axi_rvalid
        .m_axi_rready(downstream32.rready)      // output wire m_axi_rready
    );
    
endmodule
