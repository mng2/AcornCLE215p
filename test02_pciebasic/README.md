# Test Project 02: Basic PCIe

## Overview
The Acorn is probably the best bang-for-the-buck PCIe FPGA board currently available,
so of course we want to develop custom PCIe peripherals with it.
This project demonstrates the lowest-hanging fruit as far as PCIe is concerned: 
a register connected to the Acorn's LEDs.

## Structure
The code provided in this project is largely interconnect; the smarts are all inside Xilinx IP blocks.
While Xilinx would probably advise a beginner to use the IP Integrator / Block Diagram view to construct
and automate the interconnections, this example uses a code-only approach.
SystemVerilog interfaces are used to bundle up the AXI-bus connections.
While this forces each IP into a wrapper module, the alternatives are less appealing.

The IPs are as follows:
* AXI Memory Mapped To PCI Express: This IP abstracts away the PCIe endpoint and presents a few AXI interfaces to the user.
We only care about the M interface that is controlled from the PCIe host side.
* AXI Data Width Converter: The AXI interface that comes out of the previous IP is 128 bits wide when configured for x4 gen2.
The GPIO peripheral at the end of the line takes a 32 bit data word, so we need to make the interface the right size.
* AXI Protocol Converter: The GPIO peripheral is not a full AXI IP but instead is the simpler AXI-lite.
This IP handles the change.
* AXI GPIO: As mentioned, this is an AXI-lite IP. It's simply configured for 4 bits of output.

## Build Process
This project was developed in Vivado 2019.2, but will probably work in other versions without too much trouble.
To reconstitute the project, use the Vivado TCL console to navigate to this directory, then `source ./proj_pciebasic.tcl`.

## Trying It Out

## Gory Details
* GT lane order: The Xilinx IPs have a preferred lane order for the gigabit transceivers,
which is set inside the IP.
Unfortunately the Acorn does not use the standard order, probably due to board layout constraints.
The workaround employed in this project is to "unmanage" the IP, then go in and do a little surgery
on the constraints. If anyone has a better method, I'm all ears.
* Input/Output delay constraints: It's best practice to constrain all your inputs and outputs, 
but since timing seems a little tight and we've got mostly LEDs, we can ignore these.
