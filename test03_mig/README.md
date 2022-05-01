# Test Project 03: PCIe With DDR Memory

## Overview
This is a reworking of example 02 to replace the peripheral on the AXI bus
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
FPGA fabric. In this example the configuration is for 800 MHz; that sounds pretty fast
but 1600 MHz is more typical for computers and the expensive higher-end FPGAs.
In our case, with a relatively cheap FPGA, the DDR3 side runs at 800 MHz 
and the user side at 200 MHz;
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

The SQRL Acorn CLE-215+ has a single 8 Gigabit (1 GByte) DDR3 chip with a
16-bit interface. The MIG abstracts that into an AXI interface
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
(NB: see the writeup for test02 if any of the following doesn't make sense.)
I was messing around with the `pcimem` utility and ended up adapting the code
to do some simple memory checking.
My version is at https://github.com/mng2/pcimem.
I haven't updated the makefile yet so the suggested compilation command is
`gcc -Wall -g -std=c99 -O2 exercise.c crc32.c -o e` which will make an executable `e`.
Then one can test it out on `/dev/zero`:
```
$ sudo ./e /dev/zero 1
Will write memory to all '1's...
/dev/zero opened.
Target offset is 0, sys page size is 4096
mmap(0, 536870912, 0x3, 0x1, 3, 0x0)
PCI Memory mapped to address 0x7f2298fb1000.
Wrote 536870912 bytes in 0.269 seconds (1.859 GB/s)
Read 536870912 bytes in 0.074 seconds (6.802 GB/s)
```
It's a pretty impressive result for userspace, I'd say. 
This is on my ThinkPad T480; the performance on my old Athlon64 Shuttle
is pokier, at ~600 MB/s write and 1.9 GB/s read.

Now to try it on the Acorn:
```
$ sudo ./e /sys/devices/pci0000\:00/0000\:00\:0e.0/0000\:01\:00.0/resource0 0
Will write memory to all '0's...
/sys/devices/pci0000:00/0000:00:0e.0/0000:01:00.0/resource0 opened.
Target offset is 0, sys page size is 4096
mmap(0, 536870912, 0x3, 0x1, 3, 0x0)
PCI Memory mapped to address 0x7fe522426000.
Wrote 536870912 bytes in 7.652 seconds (0.065 GB/s)
Read 536870912 bytes in 235.006 seconds (0.002 GB/s)
```
Wow. That is atrocious. Why is it so bad?
I'm not totally sure but I can guess.
The C code is written fairly naively, with accesses done in
mostly 64-bit chunks.
When we access `/dev/zero`, we basically leverage an entire
[cache hierarchy](https://en.wikipedia.org/wiki/Cache_hierarchy)
whose purpose it is to optimize accesses to main memory,
hiding the details from the users and programmers.
When we access PCIe, though, there is no benevolent intelligence that
knows to optimize reads and writes for the PCIe-AXI bridge,
or memory controller IP sitting at the end of the chain.
In fact, each 64-bit access comes with a whole bunch of overhead,
since the AXI bus is 128-bit,
and the memory controller is configured to do a long burst transaction by default.
So it's terrible performance, but at least my CRC check doesn't show any issues.
```
$ sudo ./e /sys/devices/pci0000\:00/0000\:00\:0e.0/0000\:01\:00.0/resource0 r
Will write random data to memory...
/sys/devices/pci0000:00/0000:00:0e.0/0000:01:00.0/resource0 opened.
Target offset is 0, sys page size is 4096
mmap(0, 536870912, 0x3, 0x1, 3, 0x0)
PCI Memory mapped to address 0x7fc5989d2000.
Wrote 536870912 bytes in 7.938 seconds (0.063 GB/s)
Write checksum: a69dfb1f
Read 536870912 bytes in 239.485 seconds (0.002 GB/s)
Read  checksum: a69dfb1f
```
I tried switching from a x1 to a x4 PCIe adapter.
The write speed doubled but the read speed improved by less than 30%.
It's safe to say that the bottleneck lies somewhere else.
It would be interesting perhaps to figure out how far
one could take this approach, so maybe I'll come back to this.
But anyway, for serious data transfer, you'd want a DMA core in the FPGA,
so you could transfer data with limited CPU intervention.

## Gory Details
* As discussed in Example 02, the PCIe lane $ sudo ./e /sys/devices/pci0000\:00/0000\:00\:0e.0/0000\:01\:00.0/resource0 0
[sudo] password for lub: 
Will write memory to all '0's...
/sys/devices/pci0000:00/0000:00:0e.0/0000:01:00.0/resource0 opened.
Target offset is 0, sys page size is 4096
mmap(0, 536870912, 0x3, 0x1, 3, 0x0)
PCI Memory mapped to address 0x7fe522426000.
Wrote 536870912 bytes in 7.652 seconds (0.065 GB/s)
Read 536870912 bytes in 235.006 seconds (0.002 GB/s)order is treated specially,
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
