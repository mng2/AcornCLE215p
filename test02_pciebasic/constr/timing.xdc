
#create_clock -name clk200 -period 5 [get_ports CLK200_P]

create_clock -name pcie_refclk -period 10 [get_ports REFCLKp]

# these mess up the timing
# while proper, are not strictly necessary
#set_max_delay 20 -from userclk2 -to [get_ports LEDn[*]]
#set_max_delay 20 -from userclk2 -to [get_ports M2_LED]
