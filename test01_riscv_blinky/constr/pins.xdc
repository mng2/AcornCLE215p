# basic constraints for blinky

# 200 MHz LVDS clock
# Bank 15 is 1.5V so externally terminated
# see AR43989 for details
set_property PACKAGE_PIN J19 [get_ports CLK200_P]
set_property IOSTANDARD LVDS_25 [get_ports CLK200_P]
set_property PACKAGE_PIN H19 [get_ports CLK200_N]
set_property IOSTANDARD LVDS_25 [get_ports CLK200_N]

# LEDs, Bank 35, 3.3V
set_property PACKAGE_PIN G3 [get_ports LEDs_N[1]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDs_N[1]]
set_property PACKAGE_PIN H3 [get_ports LEDs_N[2]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDs_N[2]]
set_property PACKAGE_PIN G4 [get_ports LEDs_N[3]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDs_N[3]]
set_property PACKAGE_PIN H4 [get_ports LEDs_N[4]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDs_N[4]]
