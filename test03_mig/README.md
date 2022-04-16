# Test Project 03: PCIe With DDR Memory

## Overview
This is a rework of example 02 to replace the peripheral on the AXI bus
with the DDR3 memory on the SQRL Acorn.
The Xilinx MIG (Memory Interface Generator) IP is utilized for this example.

### A few words about DDR3 for the uninitiated
DDR3 is an interface standard for dynamic RAM, 
the same kind of "memory" that is used in computers.
At this writing, DDR3 is getting a bit long in the tooth (the market has
moved on to DDR4 and DDR5 is coming in) but it is of the same technology 
generation as Xilinx 7-series FPGAs.

Most FPGA end-users these days do not write their own memory controllers.
Part of it is that it is a complicated thing to undertake and will take
a long time to develop and get the bugs out.
Knowing this, FPGA vendors generally provide the IP block to support memory
usage with an FPGA. In Xilinx land this is called the MIG, the Memory
Interface Generator. One curious aspect of the MIG is that it uses FPGA primitives that
Xilinx has not (officially) made available to end-users.
This Phaser block is presumably used to do calibration for data transfer.

DDR3 operates at much higher speeds than are generally achievable in
FPGA fabric. In this example the configuration is for 800 MHz; that's pretty fast
but 1600 MHz is more typical for computers and the higher-end FPGAs.
In our case the DDR3 side runs at 800 MHz and the user side at 200 MHz;
the IP configuration dialog calls this a 4:1 interface.

The MIG IP takes care of initial setup and calibration of the DRAM
interface, and handles the periodic refresh necessary to keep the
DRAM cells topped up with electrons. What's exposed to the user is
a more typical bus interface, with address and data, which
abstracts away the transactions happening behind the scenes.
Due to the physical structure of DRAM arrays,
accesses incur a significant amount of latency.
Thus a DDRx interface is most efficient when accessed in "bursts",
which amortize that latency over a quantity of data;
for DDR3 the Xilinx MIG does bursts of 8 by default.

The SQRL Acorn has a single 8 Gigabit (1 GByte) DDR3 chip with a
x16 interface. The MIG abstracts that into an AXI interface
with 128-bit wide data, and 30-bit address.
Note that this single chip, using a 800 MHz interface,
is capable of bursting 16b x 2 x 800e6 = 25.6 Gigabits/second, or 3.2 Gigabytes/second.
If you calculate out the AXI side, 128b x 200e6, the result matches.

## Structure
The code provided in this project is largely interconnect; the smarts are all inside Xilinx IP blocks.
While Xilinx would probably advise a beginner to use the IP Integrator / Block Diagram view to construct
and automate the interconnections, this example uses a code-only approach.
SystemVerilog interfaces are used to bundle up the AXI-bus connections.
While this forces each IP into a wrapper module, the alternatives are less appealing to the author.

The IP blocks are specified in the tcl script for regenerating the project;
the MIG also has an additional config file which is basically XML.
There's several schools of thought for how to version-control Xilinx IP; this one is a little circuitous,
but I don't think there's a great solution that everybody can agree on.

The IPs are as follows:
* AXI Memory Mapped To PCI Express: This IP abstracts away the PCIe endpoint and presents a few AXI interfaces to the user.
We only care about the M interface that is controlled from the PCIe host side.
* AXI Clock Converter: Since the PCIe and the MIG run on different clock domains, 
there have to be two different AXI bus segments, running at different clocks.
This IP takes care of the clock domain crossing.
* MIG: This Xilinx IP handles the nitty-gritty of getting the DDR3 memory
initialized and keeping it refreshed. It exposes either a "native" interface
or an AXI interface; in this case we choose the AXI.

## Build Process
This project was developed in Vivado 2019.2, but will probably work in other versions without too much trouble.
To reconstitute the project, use the Vivado TCL console to navigate to this directory, then `source ./proj_pcie_mig.tcl`.
It may take a few minutes for all the right stuff to appear in the Sources window -- 
you'll want to see Design Sources, and under that the "topfile" `axi_pcie_example_top`.
Run synthesis, implementation, and generate the bitstream from the GUI. 

## Trying It Out


## Gory Details
* As discussed in Example 02, the PCIe lane order is treated specially,
which requires unmanaging the IP and doing some surgery.
* Input/Output delay constraints: It's best practice to constrain all your inputs and outputs, 
but since timing seems a little tight with the full gen2x4 core and we've got mostly LED IOs, we'll just ignore these.
By the way, MIG-related constraints are handled by the MIG.
* MIG tricks for source control: I don't like using the XCI for source
control, I prefer to do it through TCL. There might be changes needed
for other versions of Vivado. The `.xdc` in the `mig` directory is
needed if you want to use the dialog-box workflow. (Which is curious
since the `tcl` flow doesn't need it.)
* Todo: clean up the AXI stuff to reduce warnings.
