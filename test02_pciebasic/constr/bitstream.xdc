# see UG912
set_property CONFIG_VOLTAGE {3.3} [current_design]
set_property CFGBVS {VCCO} [current_design]
set_property CONFIG_MODE {SPIx4} [current_design]

# see Appendix A in UG908
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN {Div-1} [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR {Yes} [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH {4} [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE {Yes} [current_design]
set_property BITSTREAM.GENERAL.COMPRESS {True} [current_design]