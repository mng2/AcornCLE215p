
#create_clock -name clk200 -period 5 [get_ports CLK200_P]

create_clock -period 10.000 -name pcie_refclk [get_ports REFCLKp]

# these mess up the timing
# while proper, are not strictly necessary
#set_max_delay 20 -from userclk2 -to [get_ports LEDn[*]]
#set_max_delay 20 -from userclk2 -to [get_ports M2_LED]

connect_debug_port u_ila_0/probe0 [get_nets [list {my_gpio/s_axi_rdata[0]} {my_gpio/s_axi_rdata[1]} {my_gpio/s_axi_rdata[2]} {my_gpio/s_axi_rdata[3]} {my_gpio/s_axi_rdata[4]} {my_gpio/s_axi_rdata[5]} {my_gpio/s_axi_rdata[6]} {my_gpio/s_axi_rdata[7]} {my_gpio/s_axi_rdata[8]} {my_gpio/s_axi_rdata[9]} {my_gpio/s_axi_rdata[10]} {my_gpio/s_axi_rdata[11]} {my_gpio/s_axi_rdata[12]} {my_gpio/s_axi_rdata[13]} {my_gpio/s_axi_rdata[14]} {my_gpio/s_axi_rdata[15]} {my_gpio/s_axi_rdata[16]} {my_gpio/s_axi_rdata[17]} {my_gpio/s_axi_rdata[18]} {my_gpio/s_axi_rdata[19]} {my_gpio/s_axi_rdata[20]} {my_gpio/s_axi_rdata[21]} {my_gpio/s_axi_rdata[22]} {my_gpio/s_axi_rdata[23]} {my_gpio/s_axi_rdata[24]} {my_gpio/s_axi_rdata[25]} {my_gpio/s_axi_rdata[26]} {my_gpio/s_axi_rdata[27]} {my_gpio/s_axi_rdata[28]} {my_gpio/s_axi_rdata[29]} {my_gpio/s_axi_rdata[30]} {my_gpio/s_axi_rdata[31]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {my_gpio/m_axi_awaddr[0]} {my_gpio/m_axi_awaddr[1]} {my_gpio/m_axi_awaddr[2]} {my_gpio/m_axi_awaddr[3]} {my_gpio/m_axi_awaddr[4]} {my_gpio/m_axi_awaddr[5]} {my_gpio/m_axi_awaddr[6]} {my_gpio/m_axi_awaddr[7]} {my_gpio/m_axi_awaddr[8]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {my_gpio/m_axi_wdata[0]} {my_gpio/m_axi_wdata[1]} {my_gpio/m_axi_wdata[2]} {my_gpio/m_axi_wdata[3]} {my_gpio/m_axi_wdata[4]} {my_gpio/m_axi_wdata[5]} {my_gpio/m_axi_wdata[6]} {my_gpio/m_axi_wdata[7]} {my_gpio/m_axi_wdata[8]} {my_gpio/m_axi_wdata[9]} {my_gpio/m_axi_wdata[10]} {my_gpio/m_axi_wdata[11]} {my_gpio/m_axi_wdata[12]} {my_gpio/m_axi_wdata[13]} {my_gpio/m_axi_wdata[14]} {my_gpio/m_axi_wdata[15]} {my_gpio/m_axi_wdata[16]} {my_gpio/m_axi_wdata[17]} {my_gpio/m_axi_wdata[18]} {my_gpio/m_axi_wdata[19]} {my_gpio/m_axi_wdata[20]} {my_gpio/m_axi_wdata[21]} {my_gpio/m_axi_wdata[22]} {my_gpio/m_axi_wdata[23]} {my_gpio/m_axi_wdata[24]} {my_gpio/m_axi_wdata[25]} {my_gpio/m_axi_wdata[26]} {my_gpio/m_axi_wdata[27]} {my_gpio/m_axi_wdata[28]} {my_gpio/m_axi_wdata[29]} {my_gpio/m_axi_wdata[30]} {my_gpio/m_axi_wdata[31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {my_gpio/m_axi_wstrb[0]} {my_gpio/m_axi_wstrb[1]} {my_gpio/m_axi_wstrb[2]} {my_gpio/m_axi_wstrb[3]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {my_gpio/m_axi_araddr[0]} {my_gpio/m_axi_araddr[1]} {my_gpio/m_axi_araddr[2]} {my_gpio/m_axi_araddr[3]} {my_gpio/m_axi_araddr[4]} {my_gpio/m_axi_araddr[5]} {my_gpio/m_axi_araddr[6]} {my_gpio/m_axi_araddr[7]} {my_gpio/m_axi_araddr[8]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list my_gpio/m_axi_arvalid]]
connect_debug_port u_ila_0/probe6 [get_nets [list my_gpio/m_axi_awvalid]]
connect_debug_port u_ila_0/probe7 [get_nets [list my_gpio/m_axi_bready]]
connect_debug_port u_ila_0/probe8 [get_nets [list my_gpio/m_axi_rready]]
connect_debug_port u_ila_0/probe9 [get_nets [list my_gpio/m_axi_wvalid]]
connect_debug_port u_ila_0/probe10 [get_nets [list my_gpio/s_axi_arready]]
connect_debug_port u_ila_0/probe11 [get_nets [list my_gpio/s_axi_awready]]
connect_debug_port u_ila_0/probe12 [get_nets [list my_gpio/s_axi_bvalid]]
connect_debug_port u_ila_0/probe13 [get_nets [list my_gpio/s_axi_rvalid]]
connect_debug_port u_ila_0/probe14 [get_nets [list my_gpio/s_axi_wready]]








create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list my_axi_pcie/axi_pcie_inst/inst/comp_axi_enhanced_pcie/comp_enhanced_core_top_wrap/axi_pcie_enhanced_core_top_i/pcie_7x_v2_0_2_inst/pcie_top_with_gt_top.gt_ges.gt_top_i/pipe_wrapper_i/pipe_clock_int.pipe_clock_i/mmcm_i_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 29 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {axilite_if\\.awaddr[3]} {axilite_if\\.awaddr[4]} {axilite_if\\.awaddr[5]} {axilite_if\\.awaddr[6]} {axilite_if\\.awaddr[7]} {axilite_if\\.awaddr[8]} {axilite_if\\.awaddr[9]} {axilite_if\\.awaddr[10]} {axilite_if\\.awaddr[11]} {axilite_if\\.awaddr[12]} {axilite_if\\.awaddr[13]} {axilite_if\\.awaddr[14]} {axilite_if\\.awaddr[15]} {axilite_if\\.awaddr[16]} {axilite_if\\.awaddr[17]} {axilite_if\\.awaddr[18]} {axilite_if\\.awaddr[19]} {axilite_if\\.awaddr[20]} {axilite_if\\.awaddr[21]} {axilite_if\\.awaddr[22]} {axilite_if\\.awaddr[23]} {axilite_if\\.awaddr[24]} {axilite_if\\.awaddr[25]} {axilite_if\\.awaddr[26]} {axilite_if\\.awaddr[27]} {axilite_if\\.awaddr[28]} {axilite_if\\.awaddr[29]} {axilite_if\\.awaddr[30]} {axilite_if\\.awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 31 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {axilite_if\\.rdata[0]} {axilite_if\\.rdata[1]} {axilite_if\\.rdata[2]} {axilite_if\\.rdata[3]} {axilite_if\\.rdata[4]} {axilite_if\\.rdata[5]} {axilite_if\\.rdata[6]} {axilite_if\\.rdata[7]} {axilite_if\\.rdata[8]} {axilite_if\\.rdata[9]} {axilite_if\\.rdata[10]} {axilite_if\\.rdata[11]} {axilite_if\\.rdata[12]} {axilite_if\\.rdata[13]} {axilite_if\\.rdata[14]} {axilite_if\\.rdata[15]} {axilite_if\\.rdata[16]} {axilite_if\\.rdata[17]} {axilite_if\\.rdata[18]} {axilite_if\\.rdata[20]} {axilite_if\\.rdata[21]} {axilite_if\\.rdata[22]} {axilite_if\\.rdata[23]} {axilite_if\\.rdata[24]} {axilite_if\\.rdata[25]} {axilite_if\\.rdata[26]} {axilite_if\\.rdata[27]} {axilite_if\\.rdata[28]} {axilite_if\\.rdata[29]} {axilite_if\\.rdata[30]} {axilite_if\\.rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {axilite_if\\.araddr[0]} {axilite_if\\.araddr[1]} {axilite_if\\.araddr[2]} {axilite_if\\.araddr[3]} {axilite_if\\.araddr[4]} {axilite_if\\.araddr[5]} {axilite_if\\.araddr[6]} {axilite_if\\.araddr[7]} {axilite_if\\.araddr[8]} {axilite_if\\.araddr[9]} {axilite_if\\.araddr[10]} {axilite_if\\.araddr[11]} {axilite_if\\.araddr[12]} {axilite_if\\.araddr[13]} {axilite_if\\.araddr[14]} {axilite_if\\.araddr[15]} {axilite_if\\.araddr[16]} {axilite_if\\.araddr[17]} {axilite_if\\.araddr[18]} {axilite_if\\.araddr[19]} {axilite_if\\.araddr[20]} {axilite_if\\.araddr[21]} {axilite_if\\.araddr[22]} {axilite_if\\.araddr[23]} {axilite_if\\.araddr[24]} {axilite_if\\.araddr[25]} {axilite_if\\.araddr[26]} {axilite_if\\.araddr[27]} {axilite_if\\.araddr[28]} {axilite_if\\.araddr[29]} {axilite_if\\.araddr[30]} {axilite_if\\.araddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 24 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {axilite_if\\.wdata[0]} {axilite_if\\.wdata[1]} {axilite_if\\.wdata[2]} {axilite_if\\.wdata[3]} {axilite_if\\.wdata[4]} {axilite_if\\.wdata[5]} {axilite_if\\.wdata[6]} {axilite_if\\.wdata[7]} {axilite_if\\.wdata[8]} {axilite_if\\.wdata[9]} {axilite_if\\.wdata[10]} {axilite_if\\.wdata[11]} {axilite_if\\.wdata[12]} {axilite_if\\.wdata[13]} {axilite_if\\.wdata[14]} {axilite_if\\.wdata[15]} {axilite_if\\.wdata[24]} {axilite_if\\.wdata[25]} {axilite_if\\.wdata[26]} {axilite_if\\.wdata[27]} {axilite_if\\.wdata[28]} {axilite_if\\.wdata[29]} {axilite_if\\.wdata[30]} {axilite_if\\.wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {axilite_if\\.arready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {axilite_if\\.arvalid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {axilite_if\\.bready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {axilite_if\\.bvalid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {axilite_if\\.rready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {axilite_if\\.rvalid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {axilite_if\\.wready}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {axilite_if\\.wvalid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list msi_enabled]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list msi_grant]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list msi_request]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list my_uart/THREmpty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list my_uart/uart_read_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list my_uart/uart_write_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list uart_interrupt]]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[0]}]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[1]}]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[2]}]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[3]}]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets aclk]
