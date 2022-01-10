# Test Project 1: RISC-V Blinky

This project blinks the 4 LEDs at the attachment end of the Acorn in binary fashion,
like Test Project 0, but in this case the LEDs are driven from a RISC-V softcore.

The oscillator used is the one feeding the memory bank, so no PCIe connection is required.
An MMCM is used to bring the 200 MHz down to the 100 MHz recommended for NEORV32.

To build the project, several additional pieces of software are required.
* The first is the NEORV32 project, which contains the RISC-V softcore used in this example.
It is established as a submodule under the `../ip` directory, so unless you already
have the repo somewhere and know how to use it, run `git submodule update --init` to
download.
* The second, which you only need if you want to modify the C code, is a
RISC-V toolchain. On Ubuntu 21.04 supposedly the `gcc-riscv64-unknown-elf` package
is what you need, but on Ubuntu 20.04 it doesn't seem to work.
It may be simplest to manually install the binary package from https://github.com/stnolting/riscv-gcc-prebuilt

## Build Process
To build with the default program in the softcore,
use the TCL console in Vivado. 
Navigate to this directory and run the command `source ./proj_rblinky.tcl`.
Run synthesis, implementation, and generate the bitstream.

To rebuild or modify the software, enter the `sw` directory.
The program is in `main.c`.
To compile and generate the VHDL file containing the binary, run `make image`.
Then the FPGA tools can be run.

Building takes about 4 minutes on my Thinkpad T480, which is an eternity
compared to regular microcontroller development.
For real work on a platform like this, I think I'd want to use some kind of bootloader!

### Utilization
Part: xc7a200tfbg484-3

Resource | Used/Total | Percentage
--- | --- | ---
LUT | 1836/133800 | 1.37%
FF | 1291/267600 | 0.48%
BRAM | 7/365 | 1.92%
