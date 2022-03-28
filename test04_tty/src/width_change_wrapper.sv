
module axi_width_change_wrapper #() 
(
    AXI.S   upstream,
    AXI.M   downstream32
);

    axi_dwconv_64_32 
    my_64_32 (
        .s_axi_aclk(upstream.aclk),          // input wire s_axi_aclk
        .s_axi_aresetn(upstream.aresetn),    // input wire s_axi_aresetn
        .s_axi_awaddr(upstream.awaddr),      // input wire [31 : 0] s_axi_awaddr
        .s_axi_awlen(upstream.awlen),        // input wire [7 : 0] s_axi_awlen
        .s_axi_awsize(upstream.awsize),      // input wire [2 : 0] s_axi_awsize
        .s_axi_awburst(upstream.awburst),    // input wire [1 : 0] s_axi_awburst
        .s_axi_awlock(upstream.awlock),      // input wire [0 : 0] s_axi_awlock
        .s_axi_awcache(upstream.awcache),    // input wire [3 : 0] s_axi_awcache
        .s_axi_awprot(upstream.awprot),      // input wire [2 : 0] s_axi_awprot
        .s_axi_awregion(upstream.awregion),  // input wire [3 : 0] s_axi_awregion
        .s_axi_awqos(upstream.awqos),        // input wire [3 : 0] s_axi_awqos
        .s_axi_awvalid(upstream.awvalid),    // input wire s_axi_awvalid
        .s_axi_awready(upstream.awready),    // output wire s_axi_awready
        .s_axi_wdata(upstream.wdata),        // input wire [W-1 : 0] s_axi_wdata
        .s_axi_wstrb(upstream.wstrb),        // input wire [15 : 0] s_axi_wstrb
        .s_axi_wlast(upstream.wlast),        // input wire s_axi_wlast
        .s_axi_wvalid(upstream.wvalid),      // input wire s_axi_wvalid
        .s_axi_wready(upstream.wready),      // output wire s_axi_wready
        .s_axi_bresp(upstream.bresp),        // output wire [1 : 0] s_axi_bresp
        .s_axi_bvalid(upstream.bvalid),      // output wire s_axi_bvalid
        .s_axi_bready(upstream.bready),      // input wire s_axi_bready
        .s_axi_araddr(upstream.araddr),      // input wire [31 : 0] s_axi_araddr
        .s_axi_arlen(upstream.arlen),        // input wire [7 : 0] s_axi_arlen
        .s_axi_arsize(upstream.arsize),      // input wire [2 : 0] s_axi_arsize
        .s_axi_arburst(upstream.arburst),    // input wire [1 : 0] s_axi_arburst
        .s_axi_arlock(upstream.arlock),      // input wire [0 : 0] s_axi_arlock
        .s_axi_arcache(upstream.arcache),    // input wire [3 : 0] s_axi_arcache
        .s_axi_arprot(upstream.arprot),      // input wire [2 : 0] s_axi_arprot
        .s_axi_arregion(upstream.arregion),  // input wire [3 : 0] s_axi_arregion
        .s_axi_arqos(upstream.arqos),        // input wire [3 : 0] s_axi_arqos
        .s_axi_arvalid(upstream.arvalid),    // input wire s_axi_arvalid
        .s_axi_arready(upstream.arready),    // output wire s_axi_arready
        .s_axi_rdata(upstream.rdata),        // output wire [W-1 : 0] s_axi_rdata
        .s_axi_rresp(upstream.rresp),        // output wire [1 : 0] s_axi_rresp
        .s_axi_rlast(upstream.rlast),        // output wire s_axi_rlast
        .s_axi_rvalid(upstream.rvalid),      // output wire s_axi_rvalid
        .s_axi_rready(upstream.rready),      // input wire s_axi_rready
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
