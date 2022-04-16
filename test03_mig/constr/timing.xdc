
#create_clock -name clk200 -period 5 [get_ports CLK200_P]

create_clock -period 10.000 -name pcie_refclk [get_ports REFCLKp]

# these mess up the timing
# while proper, are not strictly necessary
#set_max_delay 20 -from userclk2 -to [get_ports LEDn[*]]
#set_max_delay 20 -from userclk2 -to [get_ports M2_LED]

set_max_delay -datapath_only -from [get_pins {reset_counter_reg[4]*/C}] -to [get_pins mig_wrapper_inst/mig_inst/u_mig_7series_0_mig/u_memc_ui_top_axi/u_axi_mc/areset_d1_reg/D] 4.000
