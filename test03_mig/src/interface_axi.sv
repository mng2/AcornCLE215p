// trying out SystemVerilog interfaces for AXI interconnect

// full AXI bus
interface AXI
#(  parameter DW = 32,
    parameter AW = 32   )
(   input aclk, 
    input aresetn       );
    logic [AW-1:0]  awaddr;
    logic [7 : 0]   awlen;
    logic [2 : 0]   awsize;
    logic [1 : 0]   awburst;
    logic [2 : 0]   awprot;
    logic           awvalid;
    logic           awready;
    logic           awlock;
    logic [3 : 0]   awcache;
    logic [3 : 0]   awregion;
    logic [3 : 0]   awqos;
    logic [DW-1:0]  wdata;
    logic [(DW/8)-1:0] wstrb;
    logic           wlast;
    logic           wvalid;
    logic           wready;
    logic [1 : 0]   bresp;
    logic           bvalid;
    logic           bready;
    logic [AW-1: 0] araddr;
    logic [7 : 0]   arlen;
    logic [2 : 0]   arsize;
    logic [1 : 0]   arburst;
    logic [2 : 0]   arprot;
    logic           arvalid;
    logic           arready;
    logic           arlock;
    logic [3 : 0]   arcache;
    logic [3 : 0]   arregion;
    logic [3 : 0]   arqos;
    logic [DW-1:0]  rdata;
    logic [1 : 0]   rresp;
    logic           rlast;
    logic           rvalid;
    logic           rready;

    modport M (
        input  aclk, aresetn,
        output  awaddr,
        output  awlen,
        output  awsize,
        output  awburst,
        output  awprot,
        output  awvalid,
        input   awready,
        output  awlock,
        output  awcache,
        output  awregion,
        output  awqos,
        output  wdata,
        output  wstrb,
        output  wlast,
        output  wvalid,
        input   wready,
        input   bresp,
        input   bvalid,
        output  bready,
        output  araddr,
        output  arlen,
        output  arsize,
        output  arburst,
        output  arprot,
        output  arvalid,
        input   arready,
        output  arlock,
        output  arcache,
        output  arregion,
        output  arqos,
        input   rdata,
        input   rresp,
        input   rlast,
        input   rvalid,
        output  rready
    );
    
    modport S (
        input   aclk, aresetn,
        input   awaddr,
        input   awlen,
        input   awsize,
        input   awburst,
        input   awprot,
        input   awvalid,
        output  awready,
        input   awlock,
        input   awcache,
        input   awregion,
        input   awqos,
        input   wdata,
        input   wstrb,
        input   wlast,
        input   wvalid,
        output  wready,
        output  bresp,
        output  bvalid,
        input   bready,
        input   araddr,
        input   arlen,
        input   arsize,
        input   arburst,
        input   arprot,
        input   arvalid,
        output  arready,
        input   arlock,
        input   arcache,
        input   arregion,
        input   arqos,
        output  rdata,
        output  rresp,
        output  rlast,
        output  rvalid,
        input   rready
    );
endinterface

interface AXI_lite
#(  parameter DW = 32,
    parameter AW = 32   )
(   input aclk, 
    input aresetn       );
    logic [AW-1:0]  awaddr;
    logic [2 : 0]   awprot;
    logic           awvalid;
    logic           awready;
    logic [DW-1:0]  wdata;
    logic [(DW/8)-1:0] wstrb;
    logic           wvalid;
    logic           wready;
    logic [1 : 0]   bresp;
    logic           bvalid;
    logic           bready;
    logic [AW-1: 0] araddr;
    logic [2 : 0]   arprot;
    logic           arvalid;
    logic           arready;
    logic [DW-1:0]  rdata;
    logic [1 : 0]   rresp;
    logic           rvalid;
    logic           rready;

    modport M (
        output  awaddr,
        output  awprot,
        output  awvalid,
        input   awready,
        output  wdata,
        output  wstrb,
        output  wvalid,
        input   wready,
        input   bresp,
        input   bvalid,
        output  bready,
        output  araddr,
        output  arprot,
        output  arvalid,
        input   arready,
        input   rdata,
        input   rresp,
        input   rvalid,
        output  rready
    );
    
    modport S (
        input   aclk, aresetn,
        input   awaddr,
        input   awprot,
        input   awvalid,
        output  awready,
        input   wdata,
        input   wstrb,
        input   wvalid,
        output  wready,
        output  bresp,
        output  bvalid,
        input   bready,
        input   araddr,
        input   arprot,
        input   arvalid,
        output  arready,
        output  rdata,
        output  rresp,
        output  rvalid,
        input   rready
    );
endinterface
