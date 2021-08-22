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

### A few words about AXI and IP for the uninitiated


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
* AXI GPIO: As mentioned, this is an AXI-lite IP. It's simply configured for 4 bits of output.

## Build Process
This project was developed in Vivado 2019.2, but will probably work in other versions without too much trouble.
To reconstitute the project, use the Vivado TCL console to navigate to this directory, then `source ./proj_pciebasic.tcl`.

## Trying It Out
I have my Acorn connected to an old computer of mine, running Lubuntu 20.04.
If your computer is one that doesn't cut the power when rebooting,
then I suggest programming the FPGA directly, then rebooting.
Otherwise you'll have to write the new bitfile to the Flash
and take your chances as to whether your system enforces the 100ms boot time requirement.

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
See that `Device 1234:abcd`? That means it worked, whew.
This particular format for `lspci` shows the tree structure, which one will
need to know about when the time comes to access the device.

Now do a `lspci -vvnn`. Sort through the output and find the relevant entry:
```
01:00.0 Memory controller [0580]: Device [1234:abcd]
	Subsystem: Device [1234:4321]
	{...}
	Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=16K]
```
This tells us that despite lacking a driver, the kernel went ahead and mapped BAR0 somewhere.


## Gory Details
* GT lane order: The Xilinx IPs have a preferred lane order for the gigabit transceivers,
which is set inside the IP.
Unfortunately the Acorn does not use the standard order, probably due to board layout constraints.
The workaround employed in this project is to "unmanage" the IP, then go in and do a little surgery
on the constraints. If anyone has a better method, I'm all ears.
* Input/Output delay constraints: It's best practice to constrain all your inputs and outputs, 
but since timing seems a little tight and we've got mostly LEDs, we can ignore these.
