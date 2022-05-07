# AcornCLE215p
Info and example projects for the SQRL Acorn FPGA board

## Submodule init
The neorv32 repo is rather large. Use `git submodule update --init --depth 1`
to transfer the minimum amount of data.

## Vivado
These examples were developed with Xilinx Vivado 2019.2,
running on Ubuntu 20.04 LTS. Vivado versions that are either newer,
or modestly older, should also work, but may require modifications to the `tcl` scripts.
I am running 2019.2 because there probably aren't significant improvements in
newer versions for 7-series parts.
Also the installer download size increases significantly past this version.

## License
This repository is mostly licensed under the "[CERN Open Hardware Licence Version 2](https://ohwr.org/project/cernohl/wikis/Documents/CERN-OHL-version-2) - Weakly Reciprocal",
which is akin to the LGPL. I'm using this due to its concept of "Available Components",
which are pieces necessary to building these designs, that are available under different licensing.
For this repo, the Available Components include:
* Xilinx Vivado (proprietary)
* NEORV32 RISC-V core and software by Stephan Nolting (BSD)

## See Also
* [Adapter board for Xilinx JTAG pod](https://github.com/mng2/AcornXJTAG)
* [NiteFury repository](https://github.com/RHSResearchLLC/NiteFury-and-LiteFury)
