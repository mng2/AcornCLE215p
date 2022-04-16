
module mig_wrapper (
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
    output [0:0]    ddr3_odt,
    
    input           sys_clk_p,
    input           sys_clk_n,
    output          mig_clk,
    output          mig_rst_out,
    output          mig_mmcm_locked,
    AXI.S           axi128,
    output          init_calib_complete,
    output [11:0]   device_temp,  
    input			sys_rst,

    input           app_ref_req,
    input           app_zq_req,
    output          app_ref_ack,
    output          app_zq_ack
);

    mig_7series_0 
    mig_inst (
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
        
        .ui_clk                         (mig_clk),
        .ui_clk_sync_rst                (mig_rst_out),
        .mmcm_locked                    (mig_mmcm_locked),
        .init_calib_complete,
        .device_temp,
        .app_sr_req                     ('0),   //reserved
        .app_ref_req,                           //refresh command
        .app_zq_req,                            //ZQ cal command
        .app_sr_active                  (),     //reserved
        .app_ref_ack,                   
        .app_zq_ack,
        
        .aresetn                        (axi128.aresetn),  // input			aresetn
        .s_axi_awid                     ('0),  // input [3:0]			s_axi_awid
        .s_axi_awaddr                   (axi128.awaddr),  // input [29:0]			s_axi_awaddr
        .s_axi_awlen                    (axi128.awlen),  // input [7:0]			s_axi_awlen
        .s_axi_awsize                   (axi128.awsize),  // input [2:0]			s_axi_awsize
        .s_axi_awburst                  (axi128.awburst),  // input [1:0]			s_axi_awburst
        .s_axi_awlock                   (axi128.awlock),  // input [0:0]			s_axi_awlock
        .s_axi_awcache                  (axi128.awcache),  // input [3:0]			s_axi_awcache
        .s_axi_awprot                   (axi128.awprot),  // input [2:0]			s_axi_awprot
        .s_axi_awqos                    (axi128.awqos),  // input [3:0]			s_axi_awqos
        .s_axi_awvalid                  (axi128.awvalid),  // input			s_axi_awvalid
        .s_axi_awready                  (axi128.awready),  // output			s_axi_awready
        .s_axi_wdata                    (axi128.wdata),  // input [127:0]			s_axi_wdata
        .s_axi_wstrb                    (axi128.wstrb),  // input [15:0]			s_axi_wstrb
        .s_axi_wlast                    (axi128.wlast),  // input			s_axi_wlast
        .s_axi_wvalid                   (axi128.wvalid),  // input			s_axi_wvalid
        .s_axi_wready                   (axi128.wready),  // output			s_axi_wready
        .s_axi_bid                      (),  // output [3:0]			s_axi_bid
        .s_axi_bresp                    (axi128.bresp),  // output [1:0]			s_axi_bresp
        .s_axi_bvalid                   (axi128.bvalid),  // output			s_axi_bvalid
        .s_axi_bready                   (axi128.bready),  // input			s_axi_bready
        .s_axi_arid                     ('0),  // input [3:0]			s_axi_arid
        .s_axi_araddr                   (axi128.araddr),  // input [29:0]			s_axi_araddr
        .s_axi_arlen                    (axi128.arlen),  // input [7:0]			s_axi_arlen
        .s_axi_arsize                   (axi128.arsize),  // input [2:0]			s_axi_arsize
        .s_axi_arburst                  (axi128.arburst),  // input [1:0]			s_axi_arburst
        .s_axi_arlock                   (axi128.arlock),  // input [0:0]			s_axi_arlock
        .s_axi_arcache                  (axi128.arcache),  // input [3:0]			s_axi_arcache
        .s_axi_arprot                   (axi128.arprot),  // input [2:0]			s_axi_arprot
        .s_axi_arqos                    (axi128.arqos),  // input [3:0]			s_axi_arqos
        .s_axi_arvalid                  (axi128.arvalid),  // input			s_axi_arvalid
        .s_axi_arready                  (axi128.arready),  // output			s_axi_arready
        .s_axi_rid                      (),  // output [3:0]			s_axi_rid
        .s_axi_rdata                    (axi128.rdata),  // output [127:0]			s_axi_rdata
        .s_axi_rresp                    (axi128.rresp),  // output [1:0]			s_axi_rresp
        .s_axi_rlast                    (axi128.rlast),  // output			s_axi_rlast
        .s_axi_rvalid                   (axi128.rvalid),  // output			s_axi_rvalid
        .s_axi_rready                   (axi128.rready),  // input			s_axi_rready
        
        .sys_clk_p,
        .sys_clk_n,
        .sys_rst
    );

endmodule: mig_wrapper
