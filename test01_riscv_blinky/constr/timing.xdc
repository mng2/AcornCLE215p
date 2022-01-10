
create_clock -name clk200 -period 5 [get_ports CLK200_P]

set_max_delay 10 -from clk200 -to [get_ports LEDs_N[*]]
