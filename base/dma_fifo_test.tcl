variable ddr4_config
set ddr4_config 8
variable design_name
set design_name dma_fifo_test
create_project $design_name $design_name -part xczu3eg-sfvc784-2-e -force

create_bd_design $design_name
current_bd_design $design_name

# create PS IP
source run_create_zynq_ultra_ps.tcl
puts "Building for $ddr4_config GB AUP-ZU3 DDR4 Configuration"    
create_zynq_ultra_ps $ddr4_config
set_property CONFIG.PSU__USE__M_AXI_GP2 {0} [get_bd_cells zynq_ultra_ps_e_0]

# create dma IP
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0
set_property -dict [list CONFIG.c_m_axi_s2mm_data_width.VALUE_SRC USER CONFIG.c_s_axis_s2mm_tdata_width.VALUE_SRC USER] [get_bd_cells axi_dma_0]
set_property -dict [list \
  CONFIG.c_include_sg {0} \
  CONFIG.c_m_axi_mm2s_data_width {128} \
  CONFIG.c_m_axi_s2mm_data_width {128} \
  CONFIG.c_m_axis_mm2s_tdata_width {8} \
  CONFIG.c_s_axis_s2mm_tdata_width {8} \
  CONFIG.c_sg_length_width {26} \
] [get_bd_cells axi_dma_0]

# dma M_AXI interface
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
set_property CONFIG.NUM_SI {2} [get_bd_cells smartconnect_0]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]

# dma S_AXI_LITE interface
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_1]
connect_bd_intf_net [get_bd_intf_pins smartconnect_1/M00_AXI] [get_bd_intf_pins axi_dma_0/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins smartconnect_1/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

# create and connect FIFO
create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S]
connect_bd_intf_net [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]

# connect clocks
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_dma_0/s_axi_lite_aclk]
connect_bd_net [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins smartconnect_1/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

# connect resets
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_1/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_dma_0/axi_resetn]

assign_bd_address
make_wrapper -files [get_files ./${design_name}/${design_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd] -top
add_files -norecurse ./${design_name}/${design_name}.srcs/sources_1/bd/${design_name}/hdl/${design_name}_wrapper.v
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1