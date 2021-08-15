
module axilite_gpio_wrapper
(
    AXI_lite.S      axilite,
    output  [4:1]   LEDn
);

    logic [3:0] gpio_o;
    
    axi_gpio_leds 
    my_axi_gpio (
        .s_axi_aclk(axilite.aclk),        // input wire s_axi_aclk
        .s_axi_aresetn(axilite.aresetn),  // input wire s_axi_aresetn
        .s_axi_awaddr(axilite.awaddr),    // input wire [8 : 0] s_axi_awaddr
        .s_axi_awvalid(axilite.awvalid),  // input wire s_axi_awvalid
        .s_axi_awready(axilite.awready),  // output wire s_axi_awready
        .s_axi_wdata(axilite.wdata),      // input wire [31 : 0] s_axi_wdata
        .s_axi_wstrb(axilite.wstrb),      // input wire [3 : 0] s_axi_wstrb
        .s_axi_wvalid(axilite.wvalid),    // input wire s_axi_wvalid
        .s_axi_wready(axilite.wready),    // output wire s_axi_wready
        .s_axi_bresp(axilite.bresp),      // output wire [1 : 0] s_axi_bresp
        .s_axi_bvalid(axilite.bvalid),    // output wire s_axi_bvalid
        .s_axi_bready(axilite.bready),    // input wire s_axi_bready
        .s_axi_araddr(axilite.araddr),    // input wire [8 : 0] s_axi_araddr
        .s_axi_arvalid(axilite.arvalid),  // input wire s_axi_arvalid
        .s_axi_arready(axilite.arready),  // output wire s_axi_arready
        .s_axi_rdata(axilite.rdata),      // output wire [31 : 0] s_axi_rdata
        .s_axi_rresp(axilite.rresp),      // output wire [1 : 0] s_axi_rresp
        .s_axi_rvalid(axilite.rvalid),    // output wire s_axi_rvalid
        .s_axi_rready(axilite.rready),    // input wire s_axi_rready
        .gpio_io_o(gpio_o)          // output wire [3 : 0] gpio_io_o
    );

    assign LEDn = ~gpio_o;
    
endmodule
