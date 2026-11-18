# Constraints for base_clean (MIPI camera + DMA/FIFO only)
# MIPI CSI-2 lane pins are set inside the mipi_csi2_rx_subsystem IP config.

# Camera I2C (RPi camera connector)
set_property PACKAGE_PIN L14 [get_ports IIC_0_0_sda_io]
set_property PACKAGE_PIN K14 [get_ports IIC_0_0_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports IIC_0_0_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports IIC_0_0_sda_io]
set_property PULLUP true [get_ports IIC_0_0_scl_io]
set_property PULLUP true [get_ports IIC_0_0_sda_io]

# Camera enable
set_property PACKAGE_PIN J14 [get_ports {rpi_enb[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rpi_enb[0]}]

set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
