# Test Project 02: Basic PCIe

## Overview
The SQRL Acorn is probably the best bang-for-the-buck PCIe FPGA board currently available,
so of course we want to develop custom PCIe peripherals with it.
This project demonstrates the lowest-hanging fruit as far as PCIe is concerned: 
a register connected to the Acorn's LEDs.

### A few words about PCIe for the uninitiated
PCI Express is a large and sprawling topic, but for the purposes of this demo
just the basics will suffice. If you are reading this, you probably know that
computer expansion cards come in PCIe format, ranging from x1 to x16 in lane width.
There are also version numbers for the interface, starting from gen1 and at present
going up to gen4, with each generation getting faster pipes.
The Acorn has provisions for 4 lanes, and the Artix-7 can support up to gen2.

Whenever a PCIe card wakes up, it has to negotiate the connection
with the host (Root Complex in PCIe parlance). They will try to establish the
fastest and widest connection supported by both sides. Once the link is up,
and if all is well with the hardware design, we can generally forget about the physical layer.

From the software side, each PCIe device has a configuration space containing setup
information. This includes the Base Address Registers, which define memory 'windows' that
can be accessed by the host.
In general we need to rely on the OS to map BARs into address space and provide safe access.
This often requires a driver but it seems Linux has ways of supporting simple examples.

### A few words about AXI and IP for the uninitiated
In the world of FPGA/ASIC design, you may not have the time or inclination to write everything from scratch.
You may opt to purchase a block that handles say PCIe or USB or MP3 encoding, since somebody's already got one for sale.
Such a functional block is referred to as an IP (Intellectual Property), and depending on what you pay for it,
you might get it in full source form, or just as an encrypted netlist that you drop into your design.

Not all IPs cost money upfront; your FPGA vendor provides a suite of them to do many common functions, under the proviso
that you use them with their software and FPGAs. 
This design is basically all Xilinx IP, generated through the Vivado toolchain.
This includes the PCIe core, and all the AXI bus infrastructure.

What is AXI? It's a bus protocol standard that ARM and Xilinx came up with.
While there are always many standards to choose from, AXI is pretty dominant these days,
probably because it's freely available from ARM.
The full AXI4 standard has a bunch of features but for this design we only need the AXI4-lite subset.

## Structure
The code provided in this project is largely interconnect; the smarts are all inside Xilinx IP blocks.
While Xilinx would probably advise a beginner to use the IP Integrator / Block Diagram view to construct
and automate the interconnections, this example uses a code-only approach.
SystemVerilog interfaces are used to bundle up the AXI-bus connections.
While this forces each IP into a wrapper module, the alternatives are less appealing to the author.

The IP blocks are specified in the tcl script for regenerating the project.
There's several schools of thought for how to version-control Xilinx IP; this one is a little circuitous,
but I don't think there's a great solution that everybody can agree on.

The IPs are as follows:
* AXI Memory Mapped To PCI Express: This IP abstracts away the PCIe endpoint and presents a few AXI interfaces to the user.
We only care about the M interface that is controlled from the PCIe host side.
* AXI Data Width Converter: The AXI interface that comes out of the previous IP is 128 bits wide when configured for x4 gen2.
The GPIO peripheral at the end of the line takes a 32 bit data word, so we need to make the interface the right size.
* AXI Protocol Converter: The GPIO peripheral is not a full AXI IP but instead is the simpler AXI-lite.
This IP handles the change.
* AXI GPIO: As mentioned, this is an AXI-lite S IP. It's simply configured for 4 bits of output.

## Build Process
This project was developed in Vivado 2019.2, but will probably work in other versions without too much trouble.
To reconstitute the project, use the Vivado TCL console to navigate to this directory, then `source ./proj_pciebasic.tcl`.
It may take a few minutes for all the right stuff to appear in the Sources window -- 
you'll want to see Design Sources, and under that the "topfile" `axi_pcie_example_top`.
Run synthesis, implementation, and generate the bitstream from the GUI. 

## Trying It Out
These instructions assume the use of a relatively recent Linux.
I have my Acorn connected to an old computer of mine, running Lubuntu 20.04.
If your computer is one that doesn't cut power to PCIe when rebooting,
then I suggest programming the FPGA directly over JTAG, then rebooting the computer.
(The FPGA stays programmed as long as power is applied. 
On a cold start, the FPGA has to read its bitstream out of the Flash.)
Otherwise you'll have to write the new bitfile to the Flash
and take your chances as to whether your system enforces PCIe's 100ms boot time requirement.

Anyway, once your system is up, run `lspci -tv`. This is what I get:
```
-[0000:00]-+-00.0  NVIDIA Corporation CK804 Memory Controller
           +-01.0  NVIDIA Corporation CK804 ISA Bridge
           +-01.1  NVIDIA Corporation CK804 SMBus
           +-02.0  NVIDIA Corporation CK804 USB Controller
           +-02.1  NVIDIA Corporation CK804 USB Controller
           +-06.0  NVIDIA Corporation CK804 IDE
           +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
           +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
           +-09.0-[05]--+-06.0  VIA Technologies Inc. VT1720/24 [Envy24PT/HT] PCI Multi-Channel Audio Controller
           |            \-07.0  VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
           +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
           +-0b.0-[04]--
           +-0c.0-[03]--
           +-0d.0-[02]--+-00.0  Advanced Micro Devices, Inc. [AMD/ATI] RV516 GL [FireMV 2250]
           |            \-00.1  Advanced Micro Devices, Inc. [AMD/ATI] RV516 GL [FireMV 2250] (Secondary)
           +-0e.0-[01]----00.0  Device 1234:abcd
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
```
See that `Device 1234:abcd`? That is the Vendor ID and Product ID chosen for this demo.
This particular format for `lspci` shows the tree structure, which one will
need to know about when the time comes to access the device.

Now do a `sudo lspci -vvnn -d 1234:` to get the details.
```
01:00.0 Memory controller [0580]: Device [1234:abcd]
	Subsystem: Device [1234:4321]
	{...}
	Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=16K]
	{...}
	LnkSta:	Speed 2.5GT/s (downgraded), Width x1 (downgraded)
```
I'll just note a few things out of the data dump. 
The Link Status shows that the PCIe link is operating at gen1, x1.
This is because I am running on an old computer with only gen1 support, 
and I'm using one of those x1 PCIe extenders to make the board more accessible.

The "Region 0:" line tells us that despite lacking a driver, the kernel went ahead and mapped BAR0 somewhere.
To be honest, I don't know why this happens, but it's nice since otherwise you'd probably need a driver.

Now for convenience's sake clone and compile the very useful `pcimem` utility: https://github.com/billfarrow/pcimem

`pcimem` operates on Linux `sysfs` resources. 
What I did was `ls` my way down `/sys/devices/pci*` until I found the file corresponding to the `lspci` entry.
For me, this turned out to be `/sys/devices/pci0000:00/0000:00:0e.0/0000:01:00.0`.
It was a little confusing since there is a PCIe bridge in there, but eventually I figured it out.
`cat` the Vendor and Device IDs to make sure.

Then it should be possible to read the 0th word in the device:
```
lub@lubuntu20:~/pcimem$ sudo ./pcimem /sys/devices/pci0000\:00/0000\:00\:0e.0/0000\:01\:00.0/resource0 0 w
/sys/devices/pci0000:00/0000:00:0e.0/0000:01:00.0/resource0 opened.
Target offset is 0x0, page size is 4096
mmap(0, 4096, 0x3, 0x1, 3, 0x0)
PCI Memory mapped to address 0x7fcee4d46000.
0x0000: 0x00000000
```
And then write to it in order to turn on some LEDs:
```
lub@lubuntu20:~/pcimem$ sudo ./pcimem /sys/devices/pci0000\:00/0000\:00\:0e.0/0000\:01\:00.0/resource0 0 w 5
/sys/devices/pci0000:00/0000:00:0e.0/0000:01:00.0/resource0 opened.
Target offset is 0x0, page size is 4096
mmap(0, 4096, 0x3, 0x1, 3, 0x0)
PCI Memory mapped to address 0x7fb4d6fcb000.
0x0000: 0x00000001
Written 0x0005; readback 0x   5
```
Well, that sure was a lot of work just to turn on a few lousy LEDs, huh?
Next up, something more useful, hopefully.

## Gory Details
* GT lane order: The Xilinx IPs have a preferred lane order for the gigabit transceivers,
which is set inside the IP.
Unfortunately the Acorn does not use the standard order, probably due to board layout constraints.
The workaround employed in this project is to "unmanage" the IP, then go in and do a little surgery
on the constraints. If anyone has a better method, I'm all ears.
* Input/Output delay constraints: It's best practice to constrain all your inputs and outputs, 
but since timing seems a little tight with the full gen2x4 core and we've got mostly LED IOs, we'll just ignore these.
* There is only one active address in BAR0: 0x0. 
I wasn't sure if trying to access any other address would cause problems or hang the system,
but it seems to be tolerant of the few other addresses I tried.
* Todo: clean up the AXI stuff to reduce warnings.
