
################################################################
# This is a generated script based on design: base
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2025.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source base_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sfvc784-2-e
}
set_property ip_repo_paths ../pynq/boards/ip [current_project]
update_ip_catalog



# CHANGE DESIGN NAME HERE
variable design_name
set design_name base

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_management_wiz:1.3\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:zynq_ultra_ps_e:3.5\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:dfx_axi_shutdown_manager:1.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:inline_hdl:ilslice:1.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:axi_intc:4.1\
user.org:user:address_remap:1.0\
xilinx.com:ip:axi_register_slice:2.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axis_data_fifo:2.0\
xilinx.com:ip:i2s_receiver:1.0\
xilinx.com:ip:i2s_transmitter:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_iic:2.1\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:v_demosaic:1.1\
xilinx.com:ip:v_gamma_lut:1.1\
xilinx.com:ip:mipi_csi2_rx_subsystem:6.0\
xilinx.com:ip:v_proc_ss:2.3\
xilinx.com:hls:pixel_pack_2:1.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:user:dff_en_reset_vector:1.0\
xilinx.com:user:io_switch:1.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: lmb
proc create_hier_cell_lmb_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [list \
    CONFIG.C_ECC {0} \
    CONFIG.C_NUM_LMB {2} \
  ] $lmb_bram_if_cntlr


  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1  [get_bd_pins SYS_Rst] \
  [get_bd_pins dlmb_v10/SYS_Rst] \
  [get_bd_pins ilmb_v10/SYS_Rst] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk  [get_bd_pins LMB_Clk] \
  [get_bd_pins dlmb_v10/LMB_Clk] \
  [get_bd_pins ilmb_v10/LMB_Clk] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [list \
    CONFIG.C_ECC {0} \
    CONFIG.C_NUM_LMB {2} \
  ] $lmb_bram_if_cntlr


  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1  [get_bd_pins SYS_Rst] \
  [get_bd_pins dlmb_v10/SYS_Rst] \
  [get_bd_pins ilmb_v10/SYS_Rst] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk  [get_bd_pins LMB_Clk] \
  [get_bd_pins dlmb_v10/LMB_Clk] \
  [get_bd_pins ilmb_v10/LMB_Clk] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: timers_subsystem
proc create_hier_cell_timers_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_timers_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXILite


  # Create pins
  create_bd_pin -dir O -from 1 -to 0 dout
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type rst s_axi_aresetn1
  create_bd_pin -dir O -from 1 -to 0 timers_interrupt

  # Create instance: mb_timers_interrupt, and set properties
  set mb_timers_interrupt [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 mb_timers_interrupt ]

  # Create instance: mb_timers_pwm, and set properties
  set mb_timers_pwm [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 mb_timers_pwm ]

  # Create instance: timer_0, and set properties
  set timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer_0 ]

  # Create instance: timer_1, and set properties
  set timer_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S01_AXILite] [get_bd_intf_pins timer_1/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins timer_0/S_AXI]

  # Create port connections
  connect_bd_net -net mb_timers_interrupt_dout  [get_bd_pins mb_timers_interrupt/dout] \
  [get_bd_pins timers_interrupt]
  connect_bd_net -net mb_timers_pwm_dout  [get_bd_pins mb_timers_pwm/dout] \
  [get_bd_pins dout]
  connect_bd_net -net peripheral_aresetn1_1  [get_bd_pins s_axi_aresetn1] \
  [get_bd_pins timer_1/s_axi_aresetn]
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins s_axi_aclk] \
  [get_bd_pins timer_0/s_axi_aclk] \
  [get_bd_pins timer_1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins timer_0/s_axi_aresetn]
  connect_bd_net -net timer_0_interrupt  [get_bd_pins timer_0/interrupt] \
  [get_bd_pins mb_timers_interrupt/In0]
  connect_bd_net -net timer_0_pwm0  [get_bd_pins timer_0/pwm0] \
  [get_bd_pins mb_timers_pwm/In0]
  connect_bd_net -net timer_1_interrupt  [get_bd_pins timer_1/interrupt] \
  [get_bd_pins mb_timers_interrupt/In1]
  connect_bd_net -net timer_1_pwm0  [get_bd_pins timer_1/pwm0] \
  [get_bd_pins mb_timers_pwm/In1]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: spi_subsystem
proc create_hier_cell_spi_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_spi_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXILite

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 SPI_1


  # Create pins
  create_bd_pin -dir O -type intr ip2intc_spi_0_irpt
  create_bd_pin -dir O -type intr ip2intc_spi_1_irpt
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn
  create_bd_pin -dir I -type rst s_axi_aresetn1

  # Create instance: spi_0, and set properties
  set spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_0 ]
  set_property CONFIG.C_USE_STARTUP {0} $spi_0


  # Create instance: spi_1, and set properties
  set spi_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_1 ]
  set_property CONFIG.C_USE_STARTUP {0} $spi_1


  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins S01_AXILite] [get_bd_intf_pins spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins spi_1/AXI_LITE]
  connect_bd_intf_net -intf_net spi_1_SPI_0 [get_bd_intf_pins SPI_0] [get_bd_intf_pins spi_1/SPI_0]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins SPI_1] [get_bd_intf_pins spi_0/SPI_0]

  # Create port connections
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins s_axi_aclk] \
  [get_bd_pins spi_0/ext_spi_clk] \
  [get_bd_pins spi_0/s_axi_aclk] \
  [get_bd_pins spi_1/ext_spi_clk] \
  [get_bd_pins spi_1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins spi_0/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn1] \
  [get_bd_pins spi_1/s_axi_aresetn]
  connect_bd_net -net spi_0_ip2intc_irpt  [get_bd_pins spi_0/ip2intc_irpt] \
  [get_bd_pins ip2intc_spi_0_irpt]
  connect_bd_net -net spi_1_ip2intc_irpt  [get_bd_pins spi_1/ip2intc_irpt] \
  [get_bd_pins ip2intc_spi_1_irpt]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [list \
    CONFIG.C_ECC {0} \
    CONFIG.C_NUM_LMB {2} \
  ] $lmb_bram_if_cntlr


  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1  [get_bd_pins SYS_Rst] \
  [get_bd_pins dlmb_v10/SYS_Rst] \
  [get_bd_pins ilmb_v10/SYS_Rst] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk  [get_bd_pins LMB_Clk] \
  [get_bd_pins dlmb_v10/LMB_Clk] \
  [get_bd_pins ilmb_v10/LMB_Clk] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iic_subsystem
proc create_hier_cell_iic_subsystem { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iic_subsystem() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXILite


  # Create pins
  create_bd_pin -dir O -type intr iic2intc_0_irpt
  create_bd_pin -dir O -type intr iic2intc_1_irpt
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn1
  create_bd_pin -dir I -type rst s_axil_aresetn

  # Create instance: iic_0, and set properties
  set iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic_0 ]

  # Create instance: iic_1, and set properties
  set iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S01_AXILite] [get_bd_intf_pins iic_1/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins IIC] [get_bd_intf_pins iic_1/IIC]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins IIC_0] [get_bd_intf_pins iic_0/IIC]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins iic_0/S_AXI]

  # Create port connections
  connect_bd_net -net iic_1_iic2intc_irpt  [get_bd_pins iic_1/iic2intc_irpt] \
  [get_bd_pins iic2intc_1_irpt]
  connect_bd_net -net mb1_iic_iic2intc_irpt  [get_bd_pins iic_0/iic2intc_irpt] \
  [get_bd_pins iic2intc_0_irpt]
  connect_bd_net -net peripheral_aresetn1_1  [get_bd_pins s_axi_aresetn1] \
  [get_bd_pins iic_1/s_axi_aresetn]
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins s_axi_aclk] \
  [get_bd_pins iic_0/s_axi_aclk] \
  [get_bd_pins iic_1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins s_axil_aresetn] \
  [get_bd_pins iic_0/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lmb
proc create_hier_cell_lmb { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_lmb() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:bram_rtl:1.0 BRAM_PORTB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Use_RSTB_Pin {true} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create instance: lmb_bram_if_cntlr, and set properties
  set lmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 lmb_bram_if_cntlr ]
  set_property -dict [list \
    CONFIG.C_ECC {0} \
    CONFIG.C_NUM_LMB {2} \
  ] $lmb_bram_if_cntlr


  # Create interface connections
  connect_bd_intf_net -intf_net Conn [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB1]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins BRAM_PORTB] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net lmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins lmb_bram/BRAM_PORTA] [get_bd_intf_pins lmb_bram_if_cntlr/BRAM_PORT]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins lmb_bram_if_cntlr/SLMB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1  [get_bd_pins SYS_Rst] \
  [get_bd_pins dlmb_v10/SYS_Rst] \
  [get_bd_pins ilmb_v10/SYS_Rst] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk  [get_bd_pins LMB_Clk] \
  [get_bd_pins dlmb_v10/LMB_Clk] \
  [get_bd_pins ilmb_v10/LMB_Clk] \
  [get_bd_pins lmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_pmod1
proc create_hier_cell_iop_pmod1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_pmod1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 7 -to 0 data_i
  create_bd_pin -dir O -from 7 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 7 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property CONFIG.SIZE {1} $dff_en_reset_vector_0


  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_IS_DUAL {0} \
  ] $gpio


  # Create instance: iic, and set properties
  set iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $intr


  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property CONFIG.NUM_PORTS {3} $intr_concat


  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [list \
    CONFIG.C_INTERFACE_TYPE {1} \
    CONFIG.C_IO_SWITCH_WIDTH {8} \
    CONFIG.C_NUM_PWMS {1} \
    CONFIG.C_NUM_TIMERS {1} \
    CONFIG.I2C0_Enable {true} \
    CONFIG.PWM_Enable {true} \
    CONFIG.SPI0_Enable {true} \
    CONFIG.Timer_Enable {true} \
  ] $io_switch


  # Create instance: lmb
  create_hier_cell_lmb_3 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
  ] $mb


  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property CONFIG.SINGLE_PORT_BRAM {1} $mb_bram_ctrl


  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [list \
    CONFIG.M00_HAS_REGSLICE {1} \
    CONFIG.M01_HAS_REGSLICE {1} \
    CONFIG.M02_HAS_REGSLICE {1} \
    CONFIG.M03_HAS_REGSLICE {1} \
    CONFIG.M04_HAS_REGSLICE {1} \
    CONFIG.M05_HAS_REGSLICE {1} \
    CONFIG.M06_HAS_REGSLICE {1} \
    CONFIG.M07_HAS_REGSLICE {1} \
    CONFIG.NUM_MI {8} \
    CONFIG.S00_HAS_REGSLICE {1} \
  ] $microblaze_0_axi_periph


  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property CONFIG.C_AUX_RESET_HIGH {1} $rst_clk_wiz_1_100M


  # Create instance: spi, and set properties
  set spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi ]
  set_property CONFIG.C_USE_STARTUP {0} $spi


  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi/SPI_0]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q  [get_bd_pins dff_en_reset_vector_0/q] \
  [get_bd_pins intr_req]
  connect_bd_net -net io_data_i_0_1  [get_bd_pins data_i] \
  [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_0_timer_i  [get_bd_pins io_switch/timer_i] \
  [get_bd_pins timer/capturetrig0]
  connect_bd_net -net io_switch_io_data_o  [get_bd_pins io_switch/io_data_o] \
  [get_bd_pins data_o]
  connect_bd_net -net io_switch_io_tri_o  [get_bd_pins io_switch/io_tri_o] \
  [get_bd_pins tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1  [get_bd_pins intr_ack] \
  [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o  [get_bd_pins intr/gpio_io_o] \
  [get_bd_pins dff_en_reset_vector_0/en]
  connect_bd_net -net logic_1_dout1  [get_bd_pins logic_1/dout] \
  [get_bd_pins dff_en_reset_vector_0/d] \
  [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt  [get_bd_pins iic/iic2intc_irpt] \
  [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout  [get_bd_pins intr_concat/dout] \
  [get_bd_pins intc/intr]
  connect_bd_net -net mb1_spi_ip2intc_irpt  [get_bd_pins spi/ip2intc_irpt] \
  [get_bd_pins intr_concat/In1]
  connect_bd_net -net mb1_timer_generateout0  [get_bd_pins timer/generateout0] \
  [get_bd_pins io_switch/timer_o]
  connect_bd_net -net mb1_timer_interrupt  [get_bd_pins timer/interrupt] \
  [get_bd_pins intr_concat/In2]
  connect_bd_net -net mb1_timer_pwm0  [get_bd_pins timer/pwm0] \
  [get_bd_pins io_switch/pwm_o]
  connect_bd_net -net mb_1_reset_Dout  [get_bd_pins aux_reset_in] \
  [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst  [get_bd_pins mb_debug_sys_rst] \
  [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins clk_100M] \
  [get_bd_pins dff_en_reset_vector_0/clk] \
  [get_bd_pins gpio/s_axi_aclk] \
  [get_bd_pins iic/s_axi_aclk] \
  [get_bd_pins intc/s_axi_aclk] \
  [get_bd_pins intr/s_axi_aclk] \
  [get_bd_pins io_switch/s_axi_aclk] \
  [get_bd_pins lmb/LMB_Clk] \
  [get_bd_pins mb/Clk] \
  [get_bd_pins mb_bram_ctrl/s_axi_aclk] \
  [get_bd_pins microblaze_0_axi_periph/ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M00_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M01_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M02_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M03_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M04_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M05_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M06_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M07_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/S00_ACLK] \
  [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] \
  [get_bd_pins spi/ext_spi_clk] \
  [get_bd_pins spi/s_axi_aclk] \
  [get_bd_pins timer/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset  [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset] \
  [get_bd_pins lmb/SYS_Rst]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn  [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/ARESETN]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset  [get_bd_pins rst_clk_wiz_1_100M/mb_reset] \
  [get_bd_pins mb/Reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] \
  [get_bd_pins peripheral_aresetn] \
  [get_bd_pins gpio/s_axi_aresetn] \
  [get_bd_pins iic/s_axi_aresetn] \
  [get_bd_pins intc/s_axi_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] \
  [get_bd_pins spi/s_axi_aresetn] \
  [get_bd_pins timer/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins intr/s_axi_aresetn] \
  [get_bd_pins io_switch/s_axi_aresetn] \
  [get_bd_pins mb_bram_ctrl/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_pmod0
proc create_hier_cell_iop_pmod0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_pmod0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 7 -to 0 data_i
  create_bd_pin -dir O -from 7 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 7 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property CONFIG.SIZE {1} $dff_en_reset_vector_0


  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_IS_DUAL {0} \
  ] $gpio


  # Create instance: iic, and set properties
  set iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $intr


  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property CONFIG.NUM_PORTS {3} $intr_concat


  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [list \
    CONFIG.C_INTERFACE_TYPE {1} \
    CONFIG.C_IO_SWITCH_WIDTH {8} \
    CONFIG.C_NUM_PWMS {1} \
    CONFIG.C_NUM_TIMERS {1} \
    CONFIG.I2C0_Enable {true} \
    CONFIG.PWM_Enable {true} \
    CONFIG.SPI0_Enable {true} \
    CONFIG.Timer_Enable {true} \
  ] $io_switch


  # Create instance: lmb
  create_hier_cell_lmb_2 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
  ] $mb


  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property CONFIG.SINGLE_PORT_BRAM {1} $mb_bram_ctrl


  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [list \
    CONFIG.M00_HAS_REGSLICE {1} \
    CONFIG.M01_HAS_REGSLICE {1} \
    CONFIG.M02_HAS_REGSLICE {1} \
    CONFIG.M03_HAS_REGSLICE {1} \
    CONFIG.M04_HAS_REGSLICE {1} \
    CONFIG.M05_HAS_REGSLICE {1} \
    CONFIG.M06_HAS_REGSLICE {1} \
    CONFIG.M07_HAS_REGSLICE {1} \
    CONFIG.NUM_MI {8} \
    CONFIG.S00_HAS_REGSLICE {1} \
  ] $microblaze_0_axi_periph


  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property CONFIG.C_AUX_RESET_HIGH {1} $rst_clk_wiz_1_100M


  # Create instance: spi, and set properties
  set spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi ]
  set_property CONFIG.C_USE_STARTUP {0} $spi


  # Create instance: timer, and set properties
  set timer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi/SPI_0]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q  [get_bd_pins dff_en_reset_vector_0/q] \
  [get_bd_pins intr_req]
  connect_bd_net -net io_data_i_0_1  [get_bd_pins data_i] \
  [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_0_timer_i  [get_bd_pins io_switch/timer_i] \
  [get_bd_pins timer/capturetrig0]
  connect_bd_net -net io_switch_io_data_o  [get_bd_pins io_switch/io_data_o] \
  [get_bd_pins data_o]
  connect_bd_net -net io_switch_io_tri_o  [get_bd_pins io_switch/io_tri_o] \
  [get_bd_pins tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1  [get_bd_pins intr_ack] \
  [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o  [get_bd_pins intr/gpio_io_o] \
  [get_bd_pins dff_en_reset_vector_0/en]
  connect_bd_net -net logic_1_dout1  [get_bd_pins logic_1/dout] \
  [get_bd_pins dff_en_reset_vector_0/d] \
  [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt  [get_bd_pins iic/iic2intc_irpt] \
  [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout  [get_bd_pins intr_concat/dout] \
  [get_bd_pins intc/intr]
  connect_bd_net -net mb1_spi_ip2intc_irpt  [get_bd_pins spi/ip2intc_irpt] \
  [get_bd_pins intr_concat/In1]
  connect_bd_net -net mb1_timer_generateout0  [get_bd_pins timer/generateout0] \
  [get_bd_pins io_switch/timer_o]
  connect_bd_net -net mb1_timer_interrupt  [get_bd_pins timer/interrupt] \
  [get_bd_pins intr_concat/In2]
  connect_bd_net -net mb1_timer_pwm0  [get_bd_pins timer/pwm0] \
  [get_bd_pins io_switch/pwm_o]
  connect_bd_net -net mb_1_reset_Dout  [get_bd_pins aux_reset_in] \
  [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst  [get_bd_pins mb_debug_sys_rst] \
  [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins clk_100M] \
  [get_bd_pins dff_en_reset_vector_0/clk] \
  [get_bd_pins gpio/s_axi_aclk] \
  [get_bd_pins iic/s_axi_aclk] \
  [get_bd_pins intc/s_axi_aclk] \
  [get_bd_pins intr/s_axi_aclk] \
  [get_bd_pins io_switch/s_axi_aclk] \
  [get_bd_pins lmb/LMB_Clk] \
  [get_bd_pins mb/Clk] \
  [get_bd_pins mb_bram_ctrl/s_axi_aclk] \
  [get_bd_pins microblaze_0_axi_periph/ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M00_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M01_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M02_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M03_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M04_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M05_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M06_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M07_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/S00_ACLK] \
  [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] \
  [get_bd_pins spi/ext_spi_clk] \
  [get_bd_pins spi/s_axi_aclk] \
  [get_bd_pins timer/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset  [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset] \
  [get_bd_pins lmb/SYS_Rst]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn  [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/ARESETN]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset  [get_bd_pins rst_clk_wiz_1_100M/mb_reset] \
  [get_bd_pins mb/Reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] \
  [get_bd_pins peripheral_aresetn] \
  [get_bd_pins gpio/s_axi_aresetn] \
  [get_bd_pins iic/s_axi_aresetn] \
  [get_bd_pins intc/s_axi_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] \
  [get_bd_pins spi/s_axi_aresetn] \
  [get_bd_pins timer/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins intr/s_axi_aresetn] \
  [get_bd_pins io_switch/s_axi_aresetn] \
  [get_bd_pins mb_bram_ctrl/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_rpi0
proc create_hier_cell_iop_rpi0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_rpi0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 27 -to 0 data_i
  create_bd_pin -dir O -from 27 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 27 -to 0 tri_o

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property CONFIG.SIZE {1} $dff_en_reset_vector_0


  # Create instance: iic_subsystem
  create_hier_cell_iic_subsystem $hier_obj iic_subsystem

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $intr


  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property CONFIG.NUM_PORTS {7} $intr_concat


  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [list \
    CONFIG.C_INTERFACE_TYPE {4} \
    CONFIG.C_IO_SWITCH_WIDTH {28} \
    CONFIG.C_NUM_PWMS {2} \
    CONFIG.C_NUM_SS {2} \
    CONFIG.I2C0_Enable {true} \
    CONFIG.I2C1_Enable {true} \
    CONFIG.PWM_Enable {true} \
    CONFIG.SPI0_Enable {true} \
    CONFIG.SPI1_Enable {true} \
    CONFIG.Timer_Enable {false} \
    CONFIG.UART0_Enable {true} \
  ] $io_switch


  # Create instance: lmb
  create_hier_cell_lmb_1 $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
  ] $mb


  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property CONFIG.SINGLE_PORT_BRAM {1} $mb_bram_ctrl


  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [list \
    CONFIG.M00_HAS_REGSLICE {1} \
    CONFIG.M01_HAS_REGSLICE {1} \
    CONFIG.M02_HAS_REGSLICE {1} \
    CONFIG.M03_HAS_REGSLICE {1} \
    CONFIG.M04_HAS_REGSLICE {1} \
    CONFIG.M05_HAS_REGSLICE {1} \
    CONFIG.M06_HAS_REGSLICE {1} \
    CONFIG.M07_HAS_REGSLICE {1} \
    CONFIG.NUM_MI {12} \
    CONFIG.S00_HAS_REGSLICE {1} \
  ] $microblaze_0_axi_periph


  # Create instance: rpi_gpio, and set properties
  set rpi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 rpi_gpio ]
  set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {28} \
    CONFIG.C_INTERRUPT_PRESENT {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $rpi_gpio


  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property CONFIG.C_AUX_RESET_HIGH {1} $rst_clk_wiz_1_100M


  # Create instance: spi_subsystem
  create_hier_cell_spi_subsystem $hier_obj spi_subsystem

  # Create instance: timers_subsystem
  create_hier_cell_timers_subsystem $hier_obj timers_subsystem

  # Create instance: uartlite, and set properties
  set uartlite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 uartlite ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins io_switch/gpio] [get_bd_intf_pins rpi_gpio/GPIO]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic_subsystem/IIC_0] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net iic_subsystem_IIC [get_bd_intf_pins iic_subsystem/IIC] [get_bd_intf_pins io_switch/iic1]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins spi_subsystem/S01_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic_subsystem/S00_AXILite] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] [get_bd_intf_pins rpi_gpio/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timers_subsystem/S00_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins uartlite/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M09_AXI [get_bd_intf_pins microblaze_0_axi_periph/M09_AXI] [get_bd_intf_pins timers_subsystem/S01_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M10_AXI [get_bd_intf_pins iic_subsystem/S01_AXILite] [get_bd_intf_pins microblaze_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M11_AXI [get_bd_intf_pins microblaze_0_axi_periph/M11_AXI] [get_bd_intf_pins spi_subsystem/S00_AXILite]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]
  connect_bd_intf_net -intf_net spi_1_SPI_0 [get_bd_intf_pins io_switch/spi1] [get_bd_intf_pins spi_subsystem/SPI_0]
  connect_bd_intf_net -intf_net spi_SPI_0 [get_bd_intf_pins io_switch/spi0] [get_bd_intf_pins spi_subsystem/SPI_1]
  connect_bd_intf_net -intf_net uartlite_UART [get_bd_intf_pins io_switch/uart0] [get_bd_intf_pins uartlite/UART]

  # Create port connections
  connect_bd_net -net dff_en_reset_vector_0_q  [get_bd_pins dff_en_reset_vector_0/q] \
  [get_bd_pins intr_req]
  connect_bd_net -net iic_subsystem_iic2intc_irpt  [get_bd_pins iic_subsystem/iic2intc_1_irpt] \
  [get_bd_pins intr_concat/In1]
  connect_bd_net -net io_data_i_0_1  [get_bd_pins data_i] \
  [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_io_data_o  [get_bd_pins io_switch/io_data_o] \
  [get_bd_pins data_o]
  connect_bd_net -net io_switch_io_tri_o  [get_bd_pins io_switch/io_tri_o] \
  [get_bd_pins tri_o]
  connect_bd_net -net iop_pmoda_intr_ack_1  [get_bd_pins intr_ack] \
  [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o  [get_bd_pins intr/gpio_io_o] \
  [get_bd_pins dff_en_reset_vector_0/en]
  connect_bd_net -net logic_1_dout1  [get_bd_pins logic_1/dout] \
  [get_bd_pins dff_en_reset_vector_0/d] \
  [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt  [get_bd_pins iic_subsystem/iic2intc_0_irpt] \
  [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout  [get_bd_pins intr_concat/dout] \
  [get_bd_pins intc/intr]
  connect_bd_net -net mb_1_reset_Dout  [get_bd_pins aux_reset_in] \
  [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst  [get_bd_pins mb_debug_sys_rst] \
  [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins clk_100M] \
  [get_bd_pins dff_en_reset_vector_0/clk] \
  [get_bd_pins iic_subsystem/s_axi_aclk] \
  [get_bd_pins intc/s_axi_aclk] \
  [get_bd_pins intr/s_axi_aclk] \
  [get_bd_pins io_switch/s_axi_aclk] \
  [get_bd_pins lmb/LMB_Clk] \
  [get_bd_pins mb/Clk] \
  [get_bd_pins mb_bram_ctrl/s_axi_aclk] \
  [get_bd_pins microblaze_0_axi_periph/ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M00_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M01_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M02_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M03_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M04_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M05_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M06_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M07_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M08_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M09_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M10_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M11_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/S00_ACLK] \
  [get_bd_pins rpi_gpio/s_axi_aclk] \
  [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] \
  [get_bd_pins spi_subsystem/s_axi_aclk] \
  [get_bd_pins timers_subsystem/s_axi_aclk] \
  [get_bd_pins uartlite/s_axi_aclk]
  connect_bd_net -net rpi_gpio_ip2intc_irpt  [get_bd_pins rpi_gpio/ip2intc_irpt] \
  [get_bd_pins intr_concat/In5]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset  [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset] \
  [get_bd_pins lmb/SYS_Rst]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn  [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/ARESETN]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset  [get_bd_pins rst_clk_wiz_1_100M/mb_reset] \
  [get_bd_pins mb/Reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] \
  [get_bd_pins peripheral_aresetn] \
  [get_bd_pins iic_subsystem/s_axil_aresetn] \
  [get_bd_pins intc/s_axi_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M09_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M10_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M11_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] \
  [get_bd_pins rpi_gpio/s_axi_aresetn] \
  [get_bd_pins spi_subsystem/s_axi_aresetn] \
  [get_bd_pins timers_subsystem/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins iic_subsystem/s_axi_aresetn1] \
  [get_bd_pins intr/s_axi_aresetn] \
  [get_bd_pins io_switch/s_axi_aresetn] \
  [get_bd_pins mb_bram_ctrl/s_axi_aresetn] \
  [get_bd_pins spi_subsystem/s_axi_aresetn1] \
  [get_bd_pins timers_subsystem/s_axi_aresetn1] \
  [get_bd_pins uartlite/s_axi_aresetn]
  connect_bd_net -net spi_subsystem_ip2intc_irpt  [get_bd_pins spi_subsystem/ip2intc_spi_0_irpt] \
  [get_bd_pins intr_concat/In2]
  connect_bd_net -net spi_subsystem_ip2intc_irpt1  [get_bd_pins spi_subsystem/ip2intc_spi_1_irpt] \
  [get_bd_pins intr_concat/In3]
  connect_bd_net -net timers_subsystem_dout  [get_bd_pins timers_subsystem/dout] \
  [get_bd_pins io_switch/pwm_o]
  connect_bd_net -net timers_subsystem_dout1  [get_bd_pins timers_subsystem/timers_interrupt] \
  [get_bd_pins intr_concat/In6]
  connect_bd_net -net uartlite_interrupt  [get_bd_pins uartlite/interrupt] \
  [get_bd_pins intr_concat/In4]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: iop_grove0
proc create_hier_cell_iop_grove0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_iop_grove0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbdebug_rtl:3.0 DEBUG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aux_reset_in
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -from 3 -to 0 data_i
  create_bd_pin -dir O -from 3 -to 0 data_o
  create_bd_pin -dir I -from 0 -to 0 intr_ack
  create_bd_pin -dir O -from 0 -to 0 intr_req
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_aresetn
  create_bd_pin -dir O -from 3 -to 0 tri_o

  # Create instance: capture_0, and set properties
  set capture_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 capture_0 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {2} \
  ] $capture_0


  # Create instance: capture_1, and set properties
  set capture_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 capture_1 ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {2} \
    CONFIG.DOUT_WIDTH {1} \
  ] $capture_1


  # Create instance: concat_pwm, and set properties
  set concat_pwm [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_pwm ]

  # Create instance: concat_tmr_o, and set properties
  set concat_tmr_o [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_tmr_o ]

  # Create instance: dff_en_reset_vector_0, and set properties
  set dff_en_reset_vector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:dff_en_reset_vector:1.0 dff_en_reset_vector_0 ]
  set_property CONFIG.SIZE {1} $dff_en_reset_vector_0


  # Create instance: gpio, and set properties
  set gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio ]
  set_property -dict [list \
    CONFIG.C_GPIO_WIDTH {4} \
    CONFIG.C_IS_DUAL {0} \
    CONFIG.C_TRI_DEFAULT {0xFFFFFF00} \
  ] $gpio


  # Create instance: iic0, and set properties
  set iic0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic0 ]

  # Create instance: iic1, and set properties
  set iic1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 iic1 ]

  # Create instance: intc, and set properties
  set intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 intc ]

  # Create instance: intr, and set properties
  set intr [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 intr ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $intr


  # Create instance: intr_concat, and set properties
  set intr_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 intr_concat ]
  set_property CONFIG.NUM_PORTS {2} $intr_concat


  # Create instance: io_switch, and set properties
  set io_switch [ create_bd_cell -type ip -vlnv xilinx.com:user:io_switch:1.1 io_switch ]
  set_property -dict [list \
    CONFIG.C_INTERFACE_TYPE {0} \
    CONFIG.C_IO_SWITCH_WIDTH {4} \
    CONFIG.C_NUM_PWMS {2} \
    CONFIG.C_NUM_TIMERS {2} \
    CONFIG.I2C0_Enable {true} \
    CONFIG.I2C1_Enable {true} \
    CONFIG.PWM_Enable {true} \
    CONFIG.SPI0_Enable {false} \
    CONFIG.Timer_Enable {true} \
  ] $io_switch


  # Create instance: lmb
  create_hier_cell_lmb $hier_obj lmb

  # Create instance: logic_1, and set properties
  set logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 logic_1 ]

  # Create instance: mb, and set properties
  set mb [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 mb ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
  ] $mb


  # Create instance: mb_bram_ctrl, and set properties
  set mb_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 mb_bram_ctrl ]
  set_property CONFIG.SINGLE_PORT_BRAM {1} $mb_bram_ctrl


  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property -dict [list \
    CONFIG.M00_HAS_REGSLICE {1} \
    CONFIG.M01_HAS_REGSLICE {1} \
    CONFIG.M02_HAS_REGSLICE {1} \
    CONFIG.M03_HAS_REGSLICE {1} \
    CONFIG.M04_HAS_REGSLICE {1} \
    CONFIG.M05_HAS_REGSLICE {1} \
    CONFIG.M06_HAS_REGSLICE {1} \
    CONFIG.M07_HAS_REGSLICE {1} \
    CONFIG.NUM_MI {9} \
    CONFIG.S00_HAS_REGSLICE {1} \
  ] $microblaze_0_axi_periph


  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property CONFIG.C_AUX_RESET_HIGH {1} $rst_clk_wiz_1_100M


  # Create instance: timer0, and set properties
  set timer0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer0 ]

  # Create instance: timer1, and set properties
  set timer1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 timer1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net BRAM_PORTB_1 [get_bd_intf_pins lmb/BRAM_PORTB] [get_bd_intf_pins mb_bram_ctrl/BRAM_PORTA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins mb_bram_ctrl/S_AXI]
  connect_bd_intf_net -intf_net gpio_GPIO [get_bd_intf_pins gpio/GPIO] [get_bd_intf_pins io_switch/gpio]
  connect_bd_intf_net -intf_net iic1_IIC [get_bd_intf_pins iic1/IIC] [get_bd_intf_pins io_switch/iic1]
  connect_bd_intf_net -intf_net iic_IIC [get_bd_intf_pins iic0/IIC] [get_bd_intf_pins io_switch/iic0]
  connect_bd_intf_net -intf_net mb1_intc_interrupt [get_bd_intf_pins intc/interrupt] [get_bd_intf_pins mb/INTERRUPT]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins mb/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins iic1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins iic0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins io_switch/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins gpio/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins timer0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins intc/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins intr/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI] [get_bd_intf_pins timer1/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins DEBUG] [get_bd_intf_pins mb/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins lmb/DLMB] [get_bd_intf_pins mb/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins lmb/ILMB] [get_bd_intf_pins mb/ILMB]

  # Create port connections
  connect_bd_net -net capture_1_Dout  [get_bd_pins capture_1/Dout] \
  [get_bd_pins timer1/capturetrig0]
  connect_bd_net -net concat_pwm_dout  [get_bd_pins concat_pwm/dout] \
  [get_bd_pins io_switch/pwm_o]
  connect_bd_net -net concat_tmr_o_dout  [get_bd_pins concat_tmr_o/dout] \
  [get_bd_pins io_switch/timer_o]
  connect_bd_net -net dff_en_reset_vector_0_q  [get_bd_pins dff_en_reset_vector_0/q] \
  [get_bd_pins intr_req]
  connect_bd_net -net iic1_iic2intc_irpt  [get_bd_pins iic1/iic2intc_irpt] \
  [get_bd_pins intr_concat/In1]
  connect_bd_net -net io_data_i_0_1  [get_bd_pins data_i] \
  [get_bd_pins io_switch/io_data_i]
  connect_bd_net -net io_switch_io_data_o  [get_bd_pins io_switch/io_data_o] \
  [get_bd_pins data_o]
  connect_bd_net -net io_switch_io_tri_o  [get_bd_pins io_switch/io_tri_o] \
  [get_bd_pins tri_o]
  connect_bd_net -net io_switch_timer_i  [get_bd_pins io_switch/timer_i] \
  [get_bd_pins capture_0/Din] \
  [get_bd_pins capture_1/Din]
  connect_bd_net -net iop_pmoda_intr_ack_1  [get_bd_pins intr_ack] \
  [get_bd_pins dff_en_reset_vector_0/reset]
  connect_bd_net -net iop_pmoda_intr_gpio_io_o  [get_bd_pins intr/gpio_io_o] \
  [get_bd_pins dff_en_reset_vector_0/en]
  connect_bd_net -net logic_1_dout1  [get_bd_pins logic_1/dout] \
  [get_bd_pins dff_en_reset_vector_0/d] \
  [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net mb1_iic_iic2intc_irpt  [get_bd_pins iic0/iic2intc_irpt] \
  [get_bd_pins intr_concat/In0]
  connect_bd_net -net mb1_interrupt_concat_dout  [get_bd_pins intr_concat/dout] \
  [get_bd_pins intc/intr]
  connect_bd_net -net mb_1_reset_Dout  [get_bd_pins aux_reset_in] \
  [get_bd_pins rst_clk_wiz_1_100M/aux_reset_in]
  connect_bd_net -net mdm_1_debug_sys_rst  [get_bd_pins mb_debug_sys_rst] \
  [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
  connect_bd_net -net ps7_0_FCLK_CLK0  [get_bd_pins clk_100M] \
  [get_bd_pins dff_en_reset_vector_0/clk] \
  [get_bd_pins gpio/s_axi_aclk] \
  [get_bd_pins iic0/s_axi_aclk] \
  [get_bd_pins iic1/s_axi_aclk] \
  [get_bd_pins intc/s_axi_aclk] \
  [get_bd_pins intr/s_axi_aclk] \
  [get_bd_pins io_switch/s_axi_aclk] \
  [get_bd_pins lmb/LMB_Clk] \
  [get_bd_pins mb/Clk] \
  [get_bd_pins mb_bram_ctrl/s_axi_aclk] \
  [get_bd_pins microblaze_0_axi_periph/ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M00_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M01_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M02_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M03_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M04_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M05_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M06_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M07_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/M08_ACLK] \
  [get_bd_pins microblaze_0_axi_periph/S00_ACLK] \
  [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] \
  [get_bd_pins timer0/s_axi_aclk] \
  [get_bd_pins timer1/s_axi_aclk]
  connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset  [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset] \
  [get_bd_pins lmb/SYS_Rst]
  connect_bd_net -net rst_clk_wiz_1_100M_interconnect_aresetn  [get_bd_pins rst_clk_wiz_1_100M/interconnect_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/ARESETN]
  connect_bd_net -net rst_clk_wiz_1_100M_mb_reset  [get_bd_pins rst_clk_wiz_1_100M/mb_reset] \
  [get_bd_pins mb/Reset]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn  [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn] \
  [get_bd_pins peripheral_aresetn] \
  [get_bd_pins gpio/s_axi_aresetn] \
  [get_bd_pins iic0/s_axi_aresetn] \
  [get_bd_pins iic1/s_axi_aresetn] \
  [get_bd_pins intc/s_axi_aresetn] \
  [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] \
  [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] \
  [get_bd_pins timer0/s_axi_aresetn] \
  [get_bd_pins timer1/s_axi_aresetn]
  connect_bd_net -net s_axi_aresetn_1  [get_bd_pins s_axi_aresetn] \
  [get_bd_pins intr/s_axi_aresetn] \
  [get_bd_pins io_switch/s_axi_aresetn] \
  [get_bd_pins mb_bram_ctrl/s_axi_aresetn]
  connect_bd_net -net timer0_generateout0  [get_bd_pins timer0/generateout0] \
  [get_bd_pins concat_tmr_o/In0]
  connect_bd_net -net timer0_pwm0  [get_bd_pins timer0/pwm0] \
  [get_bd_pins concat_pwm/In0]
  connect_bd_net -net timer1_generateout0  [get_bd_pins timer1/generateout0] \
  [get_bd_pins concat_tmr_o/In1]
  connect_bd_net -net timer1_pwm0  [get_bd_pins timer1/pwm0] \
  [get_bd_pins concat_pwm/In1]
  connect_bd_net -net xlslice_0_Dout  [get_bd_pins capture_0/Dout] \
  [get_bd_pins timer0/capturetrig0]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mipi
proc create_hier_cell_mipi { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mipi() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 cam_gpio

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csirxss_s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O -type intr csirxss_csi_irq
  create_bd_pin -dir I -type clk lite_aclk
  create_bd_pin -dir I -type rst lite_aresetn
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk video_aclk
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type rst aux_reset_in
  create_bd_pin -dir O -type intr iic2intc_irpt

  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property CONFIG.NUM_MI {1} $axi_interconnect


  # Create instance: axi_vdma, and set properties
  set axi_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma ]
  set_property -dict [list \
    CONFIG.c_include_mm2s {0} \
    CONFIG.c_include_s2mm_dre {0} \
    CONFIG.c_m_axi_s2mm_data_width {128} \
    CONFIG.c_num_fstores {4} \
    CONFIG.c_s2mm_genlock_mode {2} \
    CONFIG.c_s2mm_linebuffer_depth {4096} \
    CONFIG.c_s2mm_max_burst_length {256} \
  ] $axi_vdma


  # Create instance: axis_subset_converter, and set properties
  set axis_subset_converter [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter ]
  set_property -dict [list \
    CONFIG.M_HAS_TKEEP {0} \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_HAS_TSTRB {0} \
    CONFIG.M_TDATA_NUM_BYTES {2} \
    CONFIG.M_TDEST_WIDTH {10} \
    CONFIG.M_TID_WIDTH {0} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TKEEP {0} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_HAS_TSTRB {0} \
    CONFIG.S_TDATA_NUM_BYTES {3} \
    CONFIG.S_TDEST_WIDTH {10} \
    CONFIG.S_TID_WIDTH {0} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {tdata[19:12],tdata[9:2]} \
    CONFIG.TDEST_REMAP {tdest[9:0]} \
    CONFIG.TLAST_REMAP {tlast[0]} \
    CONFIG.TUSER_REMAP {tuser[0:0]} \
  ] $axis_subset_converter

  set_property -dict [list \
    CONFIG.M_HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.M_HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.M_HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.M_TID_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_HAS_TKEEP.VALUE_MODE {auto} \
    CONFIG.S_HAS_TREADY.VALUE_MODE {auto} \
    CONFIG.S_HAS_TSTRB.VALUE_MODE {auto} \
    CONFIG.S_TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_subset_converter


  # Create instance: demosaic, and set properties
  set demosaic [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 demosaic ]
  set_property -dict [list \
    CONFIG.MAX_COLS {3840} \
    CONFIG.MAX_ROWS {2160} \
    CONFIG.SAMPLES_PER_CLOCK {2} \
  ] $demosaic


  # Create instance: gamma_lut, and set properties
  set gamma_lut [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut:1.1 gamma_lut ]
  set_property -dict [list \
    CONFIG.MAX_COLS {3840} \
    CONFIG.MAX_ROWS {2160} \
    CONFIG.SAMPLES_PER_CLOCK {2} \
  ] $gamma_lut


  # Create instance: gpio_ip_reset, and set properties
  set gpio_ip_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_ip_reset ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_DOUT_DEFAULT_2 {0x00000001} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {1} \
  ] $gpio_ip_reset


  # Create instance: mipi_csi2_rx_subsyst, and set properties
  set mipi_csi2_rx_subsyst [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:6.0 mipi_csi2_rx_subsyst ]
  set_property -dict [list \
    CONFIG.CLK_LANE_IO_LOC {AD5} \
    CONFIG.CMN_NUM_LANES {2} \
    CONFIG.CMN_NUM_PIXELS {2} \
    CONFIG.CMN_PXL_FORMAT {RAW10} \
    CONFIG.CSI_BUF_DEPTH {4096} \
    CONFIG.C_CLK_LANE_IO_POSITION {26} \
    CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
    CONFIG.C_DATA_LANE0_IO_POSITION {41} \
    CONFIG.C_DATA_LANE1_IO_POSITION {39} \
    CONFIG.C_DPHY_LANES {2} \
    CONFIG.C_EN_BG0_PIN0 {false} \
    CONFIG.C_EN_BG1_PIN0 {false} \
    CONFIG.C_HS_LINE_RATE {672} \
    CONFIG.C_HS_SETTLE_NS {149} \
    CONFIG.DATA_LANE0_IO_LOC {AG3} \
    CONFIG.DATA_LANE1_IO_LOC {AG4} \
    CONFIG.DPY_EN_REG_IF {true} \
    CONFIG.DPY_LINE_RATE {672} \
    CONFIG.HP_IO_BANK_SELECTION {64} \
    CONFIG.SupportLevel {1} \
  ] $mipi_csi2_rx_subsyst


  # Create instance: v_proc_sys, and set properties
  set v_proc_sys [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_sys ]
  set_property -dict [list \
    CONFIG.C_COLORSPACE_SUPPORT {2} \
    CONFIG.C_CSC_ENABLE_WINDOW {false} \
    CONFIG.C_MAX_COLS {3840} \
    CONFIG.C_MAX_DATA_WIDTH {8} \
    CONFIG.C_MAX_ROWS {2160} \
    CONFIG.C_TOPOLOGY {3} \
  ] $v_proc_sys


  # Create instance: axis_channel_swap, and set properties
  set axis_channel_swap [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_channel_swap ]
  set_property -dict [list \
    CONFIG.M_HAS_TKEEP {1} \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_HAS_TSTRB {1} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TDEST_WIDTH {1} \
    CONFIG.M_TID_WIDTH {1} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TKEEP {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_HAS_TSTRB {1} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TDEST_WIDTH {1} \
    CONFIG.S_TID_WIDTH {1} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {tdata[39:24], tdata[47:40], tdata[15:0], tdata[23:16]} \
    CONFIG.TLAST_REMAP {tlast[0]} \
    CONFIG.TUSER_REMAP {tuser[0:0]} \
  ] $axis_channel_swap

  set_property -dict [list \
    CONFIG.M_TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.M_TID_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TDEST_WIDTH.VALUE_MODE {auto} \
    CONFIG.S_TID_WIDTH.VALUE_MODE {auto} \
  ] $axis_channel_swap


  # Create instance: pixel_pack, and set properties
  set pixel_pack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_pack_2:1.0 pixel_pack ]

  # Create instance: proc_sys_reset, and set properties
  set proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset ]
  set_property CONFIG.C_AUX_RESET_HIGH {0} $proc_sys_reset


  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property CONFIG.NUM_MI {5} $axi_interconnect_0


  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {102.086} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins S00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_pins IIC_0_0]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins gamma_lut/s_axi_CTRL] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins v_proc_sys/s_axi_ctrl] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins gpio_ip_reset/S_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins pixel_pack/s_axi_control] [get_bd_intf_pins axi_interconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins demosaic/s_axi_CTRL] [get_bd_intf_pins axi_interconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M26_AXI [get_bd_intf_pins csirxss_s_axi] [get_bd_intf_pins mipi_csi2_rx_subsyst/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_interconnect/S00_AXI] [get_bd_intf_pins axi_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_channel_swap_m_axis [get_bd_intf_pins axis_channel_swap/M_AXIS] [get_bd_intf_pins pixel_pack/stream_in_48]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter/M_AXIS] [get_bd_intf_pins demosaic/s_axis_video]
  connect_bd_intf_net -intf_net dm0_m_axis_video [get_bd_intf_pins demosaic/m_axis_video] [get_bd_intf_pins gamma_lut/s_axis_video]
  connect_bd_intf_net -intf_net gammalut_m_axis [get_bd_intf_pins gamma_lut/m_axis_video] [get_bd_intf_pins v_proc_sys/s_axis]
  connect_bd_intf_net -intf_net gpio_ip_reset_GPIO2 [get_bd_intf_pins cam_gpio] [get_bd_intf_pins gpio_ip_reset/GPIO2]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsyst_0_video_out [get_bd_intf_pins axis_subset_converter/S_AXIS] [get_bd_intf_pins mipi_csi2_rx_subsyst/video_out]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_pins mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsyst/mipi_phy_if]
  connect_bd_intf_net -intf_net pixel_pack_m_axis [get_bd_intf_pins pixel_pack/stream_out_64] [get_bd_intf_pins axi_vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net v_proc_sys_0_m_axis [get_bd_intf_pins v_proc_sys/m_axis] [get_bd_intf_pins axis_channel_swap/S_AXIS]

  # Create port connections
  connect_bd_net -net aux_reset_in_1  [get_bd_pins aux_reset_in] \
  [get_bd_pins proc_sys_reset_1/aux_reset_in] \
  [get_bd_pins proc_sys_reset_1/dcm_locked] \
  [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net axi_gpio_ip_reset_gpio_io_o  [get_bd_pins gpio_ip_reset/gpio_io_o] \
  [get_bd_pins proc_sys_reset/aux_reset_in]
  connect_bd_net -net axi_iic_0_iic2intc_irpt  [get_bd_pins axi_iic_0/iic2intc_irpt] \
  [get_bd_pins iic2intc_irpt]
  connect_bd_net -net axi_vdma_mipi_s2mm_introut  [get_bd_pins axi_vdma/s2mm_introut] \
  [get_bd_pins s2mm_introut]
  connect_bd_net -net clk_wiz_0_clk_out1  [get_bd_pins clk_wiz_0/clk_out1] \
  [get_bd_pins mipi_csi2_rx_subsyst/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_csirxss_csi_irq  [get_bd_pins mipi_csi2_rx_subsyst/csirxss_csi_irq] \
  [get_bd_pins csirxss_csi_irq]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2  [get_bd_pins video_aclk] \
  [get_bd_pins axi_interconnect/ACLK] \
  [get_bd_pins axi_interconnect/M00_ACLK] \
  [get_bd_pins axi_interconnect/S00_ACLK] \
  [get_bd_pins axi_vdma/m_axi_s2mm_aclk] \
  [get_bd_pins axi_vdma/s_axis_s2mm_aclk] \
  [get_bd_pins axis_subset_converter/aclk] \
  [get_bd_pins demosaic/ap_clk] \
  [get_bd_pins gamma_lut/ap_clk] \
  [get_bd_pins gpio_ip_reset/s_axi_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst/video_aclk] \
  [get_bd_pins v_proc_sys/aclk] \
  [get_bd_pins axis_channel_swap/aclk] \
  [get_bd_pins pixel_pack/ap_clk] \
  [get_bd_pins proc_sys_reset/slowest_sync_clk] \
  [get_bd_pins axi_interconnect_0/S00_ACLK] \
  [get_bd_pins axi_interconnect_0/M00_ACLK] \
  [get_bd_pins axi_interconnect_0/M01_ACLK] \
  [get_bd_pins axi_interconnect_0/M02_ACLK] \
  [get_bd_pins axi_interconnect_0/M03_ACLK] \
  [get_bd_pins proc_sys_reset_1/slowest_sync_clk] \
  [get_bd_pins axi_interconnect_0/M04_ACLK] \
  [get_bd_pins axi_interconnect_0/ACLK]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked  [get_bd_pins proc_sys_reset_1/peripheral_aresetn] \
  [get_bd_pins axi_interconnect/ARESETN] \
  [get_bd_pins axi_interconnect/M00_ARESETN] \
  [get_bd_pins axi_interconnect/S00_ARESETN] \
  [get_bd_pins axis_subset_converter/aresetn] \
  [get_bd_pins gpio_ip_reset/s_axi_aresetn] \
  [get_bd_pins mipi_csi2_rx_subsyst/video_aresetn] \
  [get_bd_pins proc_sys_reset/ext_reset_in] \
  [get_bd_pins peripheral_aresetn] \
  [get_bd_pins axi_interconnect_0/S00_ARESETN] \
  [get_bd_pins axi_interconnect_0/M00_ARESETN] \
  [get_bd_pins axi_interconnect_0/M01_ARESETN] \
  [get_bd_pins axi_interconnect_0/M02_ARESETN] \
  [get_bd_pins axi_interconnect_0/M03_ARESETN] \
  [get_bd_pins axi_interconnect_0/M04_ARESETN] \
  [get_bd_pins axi_interconnect_0/ARESETN]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn  [get_bd_pins lite_aresetn] \
  [get_bd_pins axi_vdma/axi_resetn] \
  [get_bd_pins mipi_csi2_rx_subsyst/lite_aresetn] \
  [get_bd_pins axi_iic_0/s_axi_aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk  [get_bd_pins lite_aclk] \
  [get_bd_pins axi_vdma/s_axi_lite_aclk] \
  [get_bd_pins mipi_csi2_rx_subsyst/lite_aclk] \
  [get_bd_pins clk_wiz_0/clk_in1] \
  [get_bd_pins axi_iic_0/s_axi_aclk]
  connect_bd_net -net soft_peripheral_aresetn  [get_bd_pins proc_sys_reset/peripheral_aresetn] \
  [get_bd_pins demosaic/ap_rst_n] \
  [get_bd_pins gamma_lut/ap_rst_n] \
  [get_bd_pins v_proc_sys/aresetn] \
  [get_bd_pins axis_channel_swap/aresetn] \
  [get_bd_pins pixel_pack/ap_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: audio
proc create_hier_cell_audio { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_audio() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 i2s_rx_s_axi_ctrl_i

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 i2s_tx_s_axi_ctrl_i

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 AIC_nRST

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_gpio_ctrl_i

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 i2c_aic

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 axi_i2c_ctrl_i


  # Create pins
  create_bd_pin -dir I axi_ctrl_clk_i
  create_bd_pin -dir O -type intr i2s_rx_irq_o
  create_bd_pin -dir O -type intr i2s_tx_irq_o
  create_bd_pin -dir O i2s_tx_sdata_o
  create_bd_pin -dir I i2s_rx_sdata_i
  create_bd_pin -dir I axi_ctrl_nrst_i
  create_bd_pin -dir O lrclk_o
  create_bd_pin -dir O sclk_o
  create_bd_pin -dir O -type intr iic2intc_irpt
  create_bd_pin -dir O AIC_mclk_o

  # Create instance: i2s_receiver_0, and set properties
  set i2s_receiver_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:i2s_receiver:1.0 i2s_receiver_0 ]
  set_property CONFIG.C_DWIDTH {16} $i2s_receiver_0


  # Create instance: i2s_transmitter_0, and set properties
  set i2s_transmitter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:i2s_transmitter:1.0 i2s_transmitter_0 ]
  set_property -dict [list \
    CONFIG.C_DWIDTH {16} \
    CONFIG.C_IS_MASTER {0} \
  ] $i2s_transmitter_0


  # Create instance: mclk_wiz_0, and set properties
  set mclk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 mclk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {401.141} \
    CONFIG.CLKOUT1_PHASE_ERROR {474.126} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {12.288} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {88.750} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {80.250} \
    CONFIG.MMCM_DIVCLK_DIVIDE {9} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
  ] $mclk_wiz_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $axi_gpio_0


  # Create instance: axi_iic_aic, and set properties
  set axi_iic_aic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_aic ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins i2s_receiver_0/s_axi_ctrl] [get_bd_intf_pins i2s_rx_s_axi_ctrl_i]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins i2s_transmitter_0/s_axi_ctrl] [get_bd_intf_pins i2s_tx_s_axi_ctrl_i]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axi_gpio_0/GPIO] [get_bd_intf_pins AIC_nRST]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins axi_gpio_ctrl_i]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins axi_iic_aic/IIC] [get_bd_intf_pins i2c_aic]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins axi_iic_aic/S_AXI] [get_bd_intf_pins axi_i2c_ctrl_i]
  connect_bd_intf_net -intf_net i2s_receiver_0_m_axis_aud [get_bd_intf_pins i2s_receiver_0/m_axis_aud] [get_bd_intf_pins i2s_transmitter_0/s_axis_aud]

  # Create port connections
  connect_bd_net -net Net  [get_bd_pins axi_ctrl_clk_i] \
  [get_bd_pins i2s_transmitter_0/s_axis_aud_aclk] \
  [get_bd_pins i2s_receiver_0/m_axis_aud_aclk] \
  [get_bd_pins i2s_transmitter_0/s_axi_ctrl_aclk] \
  [get_bd_pins i2s_receiver_0/s_axi_ctrl_aclk] \
  [get_bd_pins mclk_wiz_0/clk_in1] \
  [get_bd_pins axi_gpio_0/s_axi_aclk] \
  [get_bd_pins axi_iic_aic/s_axi_aclk]
  connect_bd_net -net Net1  [get_bd_pins axi_ctrl_nrst_i] \
  [get_bd_pins i2s_transmitter_0/s_axis_aud_aresetn] \
  [get_bd_pins i2s_transmitter_0/s_axi_ctrl_aresetn] \
  [get_bd_pins i2s_receiver_0/m_axis_aud_aresetn] \
  [get_bd_pins i2s_receiver_0/s_axi_ctrl_aresetn] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in] \
  [get_bd_pins mclk_wiz_0/resetn] \
  [get_bd_pins axi_gpio_0/s_axi_aresetn] \
  [get_bd_pins axi_iic_aic/s_axi_aresetn]
  connect_bd_net -net aud_mrst_0_1  [get_bd_pins proc_sys_reset_0/peripheral_reset] \
  [get_bd_pins i2s_receiver_0/aud_mrst] \
  [get_bd_pins i2s_transmitter_0/aud_mrst]
  connect_bd_net -net axi_iic_aic_iic2intc_irpt  [get_bd_pins axi_iic_aic/iic2intc_irpt] \
  [get_bd_pins iic2intc_irpt]
  connect_bd_net -net i2s_receiver_0_irq  [get_bd_pins i2s_receiver_0/irq] \
  [get_bd_pins i2s_rx_irq_o]
  connect_bd_net -net i2s_receiver_0_lrclk_out  [get_bd_pins i2s_receiver_0/lrclk_out] \
  [get_bd_pins lrclk_o] \
  [get_bd_pins i2s_transmitter_0/lrclk_in]
  connect_bd_net -net i2s_receiver_0_sclk_out  [get_bd_pins i2s_receiver_0/sclk_out] \
  [get_bd_pins sclk_o] \
  [get_bd_pins i2s_transmitter_0/sclk_in]
  connect_bd_net -net i2s_transmitter_0_irq  [get_bd_pins i2s_transmitter_0/irq] \
  [get_bd_pins i2s_tx_irq_o]
  connect_bd_net -net i2s_transmitter_0_sdata_0_out  [get_bd_pins i2s_transmitter_0/sdata_0_out] \
  [get_bd_pins i2s_tx_sdata_o]
  connect_bd_net -net mclk_wiz_0_clk_out1  [get_bd_pins mclk_wiz_0/clk_out1] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins i2s_receiver_0/aud_mclk] \
  [get_bd_pins i2s_transmitter_0/aud_mclk] \
  [get_bd_pins AIC_mclk_o]
  connect_bd_net -net sdata_0_in_0_1  [get_bd_pins i2s_rx_sdata_i] \
  [get_bd_pins i2s_receiver_0/sdata_0_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set HORZ [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 HORZ ]

  set VERT [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 VERT ]

  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  set i2c_aic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 i2c_aic ]

  set CAM [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 CAM ]

  set IIC_0_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0_0 ]

  set PL_LEDRGB1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_LEDRGB1 ]

  set PL_LEDRGB2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_LEDRGB2 ]

  set PL_LEDRGB0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_LEDRGB0 ]

  set PL_LEDRGB3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_LEDRGB3 ]

  set PL_USER_LED [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_USER_LED ]

  set SEL_JOYSTICK [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 SEL_JOYSTICK ]

  set PL_USER_PB [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_USER_PB ]

  set PL_USER_SW [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 PL_USER_SW ]


  # Create ports
  set AIC_nRST [ create_bd_port -dir O -from 0 -to 0 AIC_nRST ]
  set AIC_sdata_o [ create_bd_port -dir O AIC_sdata_o ]
  set AIC_sdata_i [ create_bd_port -dir I AIC_sdata_i ]
  set AIC_lrclk_o [ create_bd_port -dir O AIC_lrclk_o ]
  set AIC_sclk_o [ create_bd_port -dir O AIC_sclk_o ]
  set AIC_mclk_o [ create_bd_port -dir O AIC_mclk_o ]
  set rpi_enb [ create_bd_port -dir O -from 0 -to 0 rpi_enb ]
  set iop_pmod0 [ create_bd_port -dir IO -from 7 -to 0 iop_pmod0 ]
  set iop_pmod1 [ create_bd_port -dir IO -from 7 -to 0 iop_pmod1 ]
  set iop_rpi0 [ create_bd_port -dir IO -from 27 -to 0 iop_rpi0 ]
  set iop_grove0 [ create_bd_port -dir IO -from 3 -to 0 iop_grove0 ]

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [list \
    CONFIG.NUM_MI {24} \
    CONFIG.NUM_SI {1} \
  ] $ps8_0_axi_periph


  # Create instance: rst_ps8_0_99M, and set properties
  set rst_ps8_0_99M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_99M ]

  # Create instance: system_management_wiz_0, and set properties
  set system_management_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0 ]
  set_property -dict [list \
    CONFIG.ANALOG_BANK_SELECTION {44} \
    CONFIG.BIPOLAR_VAUXP8_VAUXN8 {false} \
    CONFIG.BIPOLAR_VAUXP9_VAUXN9 {false} \
    CONFIG.BIPOLAR_VP_VN {false} \
    CONFIG.CHANNEL_ENABLE_VAUXP8_VAUXN8 {true} \
    CONFIG.CHANNEL_ENABLE_VAUXP9_VAUXN9 {true} \
    CONFIG.CHANNEL_ENABLE_VP_VN {true} \
    CONFIG.ENABLE_EXTERNAL_MUX {false} \
    CONFIG.EXTERNAL_MUXADDR_ENABLE {false} \
    CONFIG.INTERFACE_SELECTION {Enable_AXI} \
    CONFIG.VAUXN0_LOC {AB9} \
    CONFIG.VAUXN10_LOC {Y13} \
    CONFIG.VAUXN11_LOC {W13} \
    CONFIG.VAUXN12_LOC {AF13} \
    CONFIG.VAUXN13_LOC {AH13} \
    CONFIG.VAUXN14_LOC {AH14} \
    CONFIG.VAUXN15_LOC {AE14} \
    CONFIG.VAUXN1_LOC {AA8} \
    CONFIG.VAUXN2_LOC {Y10} \
    CONFIG.VAUXN3_LOC {AA10} \
    CONFIG.VAUXN4_LOC {AC11} \
    CONFIG.VAUXN5_LOC {AD10} \
    CONFIG.VAUXN6_LOC {AD12} \
    CONFIG.VAUXN7_LOC {AF12} \
    CONFIG.VAUXN8_LOC {AA12} \
    CONFIG.VAUXN9_LOC {W11} \
    CONFIG.VAUXP0_LOC {AB10} \
    CONFIG.VAUXP10_LOC {Y14} \
    CONFIG.VAUXP11_LOC {W14} \
    CONFIG.VAUXP12_LOC {AE13} \
    CONFIG.VAUXP13_LOC {AG13} \
    CONFIG.VAUXP14_LOC {AG14} \
    CONFIG.VAUXP15_LOC {AE15} \
    CONFIG.VAUXP1_LOC {Y9} \
    CONFIG.VAUXP2_LOC {W10} \
    CONFIG.VAUXP3_LOC {AA11} \
    CONFIG.VAUXP4_LOC {AB11} \
    CONFIG.VAUXP5_LOC {AD11} \
    CONFIG.VAUXP6_LOC {AC12} \
    CONFIG.VAUXP7_LOC {AE12} \
    CONFIG.VAUXP8_LOC {Y12} \
    CONFIG.VAUXP9_LOC {W12} \
  ] $system_management_wiz_0


  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property CONFIG.NUM_PORTS {12} $xlconcat_0


  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0 ]
  set_property -dict [list \
    CONFIG.CAN0_BOARD_INTERFACE {custom} \
    CONFIG.CAN1_BOARD_INTERFACE {custom} \
    CONFIG.CSU_BOARD_INTERFACE {custom} \
    CONFIG.DP_BOARD_INTERFACE {custom} \
    CONFIG.GEM0_BOARD_INTERFACE {custom} \
    CONFIG.GEM1_BOARD_INTERFACE {custom} \
    CONFIG.GEM2_BOARD_INTERFACE {custom} \
    CONFIG.GEM3_BOARD_INTERFACE {custom} \
    CONFIG.GPIO_BOARD_INTERFACE {custom} \
    CONFIG.IIC0_BOARD_INTERFACE {custom} \
    CONFIG.IIC1_BOARD_INTERFACE {custom} \
    CONFIG.NAND_BOARD_INTERFACE {custom} \
    CONFIG.PCIE_BOARD_INTERFACE {custom} \
    CONFIG.PJTAG_BOARD_INTERFACE {custom} \
    CONFIG.PMU_BOARD_INTERFACE {custom} \
    CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS33} \
    CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS33} \
    CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS33} \
    CONFIG.PSU_BANK_3_IO_STANDARD {LVCMOS18} \
    CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
    CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
    CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
    CONFIG.PSU_IMPORT_BOARD_PRESET {} \
    CONFIG.PSU_MIO_0_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_0_POLARITY {Default} \
    CONFIG.PSU_MIO_0_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_0_SLEW {fast} \
    CONFIG.PSU_MIO_10_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_10_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_10_POLARITY {Default} \
    CONFIG.PSU_MIO_10_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_10_SLEW {fast} \
    CONFIG.PSU_MIO_11_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_11_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_11_POLARITY {Default} \
    CONFIG.PSU_MIO_11_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_11_SLEW {fast} \
    CONFIG.PSU_MIO_12_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_12_POLARITY {Default} \
    CONFIG.PSU_MIO_12_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_12_SLEW {fast} \
    CONFIG.PSU_MIO_13_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_13_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_13_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_13_SLEW {fast} \
    CONFIG.PSU_MIO_14_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_14_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_14_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_14_SLEW {fast} \
    CONFIG.PSU_MIO_15_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_15_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_15_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_15_SLEW {fast} \
    CONFIG.PSU_MIO_16_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_16_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_16_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_16_SLEW {fast} \
    CONFIG.PSU_MIO_17_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_17_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_17_POLARITY {Default} \
    CONFIG.PSU_MIO_17_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_17_SLEW {fast} \
    CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_18_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_18_POLARITY {Default} \
    CONFIG.PSU_MIO_18_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_18_SLEW {fast} \
    CONFIG.PSU_MIO_19_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_19_POLARITY {Default} \
    CONFIG.PSU_MIO_19_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_19_SLEW {fast} \
    CONFIG.PSU_MIO_1_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_1_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_1_POLARITY {Default} \
    CONFIG.PSU_MIO_1_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_1_SLEW {fast} \
    CONFIG.PSU_MIO_20_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_20_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_20_POLARITY {Default} \
    CONFIG.PSU_MIO_20_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_20_SLEW {fast} \
    CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_21_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_21_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_21_SLEW {fast} \
    CONFIG.PSU_MIO_22_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_22_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_22_SLEW {fast} \
    CONFIG.PSU_MIO_23_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_23_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_23_POLARITY {Default} \
    CONFIG.PSU_MIO_23_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_23_SLEW {fast} \
    CONFIG.PSU_MIO_24_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_24_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_25_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_25_POLARITY {Default} \
    CONFIG.PSU_MIO_25_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_25_SLEW {fast} \
    CONFIG.PSU_MIO_26_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_26_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_26_POLARITY {Default} \
    CONFIG.PSU_MIO_26_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_26_SLEW {fast} \
    CONFIG.PSU_MIO_27_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_27_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_27_SLEW {fast} \
    CONFIG.PSU_MIO_28_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_28_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_29_DRIVE_STRENGTH {2} \
    CONFIG.PSU_MIO_29_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_29_SLEW {slow} \
    CONFIG.PSU_MIO_2_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_2_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_2_POLARITY {Default} \
    CONFIG.PSU_MIO_2_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_2_SLEW {fast} \
    CONFIG.PSU_MIO_30_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_30_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_31_DRIVE_STRENGTH {2} \
    CONFIG.PSU_MIO_31_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_31_POLARITY {Default} \
    CONFIG.PSU_MIO_31_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_31_SLEW {slow} \
    CONFIG.PSU_MIO_32_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_32_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_32_SLEW {fast} \
    CONFIG.PSU_MIO_33_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_33_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_34_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_34_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_34_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_34_SLEW {fast} \
    CONFIG.PSU_MIO_35_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_35_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_35_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_35_SLEW {fast} \
    CONFIG.PSU_MIO_36_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_36_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_36_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_36_SLEW {fast} \
    CONFIG.PSU_MIO_37_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_37_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_37_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_37_SLEW {fast} \
    CONFIG.PSU_MIO_38_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_38_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_38_POLARITY {Default} \
    CONFIG.PSU_MIO_38_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_38_SLEW {fast} \
    CONFIG.PSU_MIO_39_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_39_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_39_POLARITY {Default} \
    CONFIG.PSU_MIO_39_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_39_SLEW {fast} \
    CONFIG.PSU_MIO_3_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_3_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_3_POLARITY {Default} \
    CONFIG.PSU_MIO_3_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_3_SLEW {fast} \
    CONFIG.PSU_MIO_40_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_40_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_40_POLARITY {Default} \
    CONFIG.PSU_MIO_40_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_40_SLEW {fast} \
    CONFIG.PSU_MIO_41_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_41_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_41_POLARITY {Default} \
    CONFIG.PSU_MIO_41_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_41_SLEW {fast} \
    CONFIG.PSU_MIO_42_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_42_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_42_POLARITY {Default} \
    CONFIG.PSU_MIO_42_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_42_SLEW {fast} \
    CONFIG.PSU_MIO_43_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_43_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_43_POLARITY {Default} \
    CONFIG.PSU_MIO_43_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_43_SLEW {fast} \
    CONFIG.PSU_MIO_44_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_44_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_44_POLARITY {Default} \
    CONFIG.PSU_MIO_44_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_44_SLEW {fast} \
    CONFIG.PSU_MIO_45_DRIVE_STRENGTH {2} \
    CONFIG.PSU_MIO_45_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_45_POLARITY {Default} \
    CONFIG.PSU_MIO_45_PULLUPDOWN {disable} \
    CONFIG.PSU_MIO_45_SLEW {fast} \
    CONFIG.PSU_MIO_46_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_46_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_46_POLARITY {Default} \
    CONFIG.PSU_MIO_46_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_46_SLEW {fast} \
    CONFIG.PSU_MIO_47_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_47_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_47_POLARITY {Default} \
    CONFIG.PSU_MIO_47_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_47_SLEW {fast} \
    CONFIG.PSU_MIO_48_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_48_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_48_POLARITY {Default} \
    CONFIG.PSU_MIO_48_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_48_SLEW {fast} \
    CONFIG.PSU_MIO_49_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_49_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_49_POLARITY {Default} \
    CONFIG.PSU_MIO_49_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_49_SLEW {fast} \
    CONFIG.PSU_MIO_4_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_4_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_4_POLARITY {Default} \
    CONFIG.PSU_MIO_4_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_4_SLEW {fast} \
    CONFIG.PSU_MIO_50_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_50_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_50_POLARITY {Default} \
    CONFIG.PSU_MIO_50_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_50_SLEW {fast} \
    CONFIG.PSU_MIO_51_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_51_POLARITY {Default} \
    CONFIG.PSU_MIO_51_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_51_SLEW {fast} \
    CONFIG.PSU_MIO_52_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_52_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_53_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_53_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_54_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_54_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_54_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_54_SLEW {fast} \
    CONFIG.PSU_MIO_55_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_55_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_56_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_56_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_56_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_56_SLEW {fast} \
    CONFIG.PSU_MIO_57_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_57_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_57_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_57_SLEW {fast} \
    CONFIG.PSU_MIO_58_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_58_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_58_SLEW {fast} \
    CONFIG.PSU_MIO_59_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_59_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_59_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_59_SLEW {fast} \
    CONFIG.PSU_MIO_5_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_5_POLARITY {Default} \
    CONFIG.PSU_MIO_5_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_5_SLEW {fast} \
    CONFIG.PSU_MIO_60_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_60_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_60_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_60_SLEW {fast} \
    CONFIG.PSU_MIO_61_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_61_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_61_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_61_SLEW {fast} \
    CONFIG.PSU_MIO_62_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_62_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_62_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_62_SLEW {fast} \
    CONFIG.PSU_MIO_63_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_63_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_63_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_63_SLEW {fast} \
    CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_64_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_65_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_66_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_66_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_66_SLEW {fast} \
    CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_67_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_68_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_68_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_68_SLEW {fast} \
    CONFIG.PSU_MIO_69_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_69_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_69_SLEW {fast} \
    CONFIG.PSU_MIO_6_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_6_POLARITY {Default} \
    CONFIG.PSU_MIO_6_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_6_SLEW {fast} \
    CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_70_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_70_SLEW {fast} \
    CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_71_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_71_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_71_SLEW {fast} \
    CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_72_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_72_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_72_SLEW {fast} \
    CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_73_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_73_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_73_SLEW {fast} \
    CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_74_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_74_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_74_SLEW {fast} \
    CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_75_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_75_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_75_SLEW {fast} \
    CONFIG.PSU_MIO_76_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_76_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_76_SLEW {fast} \
    CONFIG.PSU_MIO_77_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_77_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_77_POLARITY {Default} \
    CONFIG.PSU_MIO_77_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_77_SLEW {fast} \
    CONFIG.PSU_MIO_7_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_7_POLARITY {Default} \
    CONFIG.PSU_MIO_7_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_7_SLEW {fast} \
    CONFIG.PSU_MIO_8_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_8_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_8_POLARITY {Default} \
    CONFIG.PSU_MIO_8_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_8_SLEW {fast} \
    CONFIG.PSU_MIO_9_DRIVE_STRENGTH {12} \
    CONFIG.PSU_MIO_9_INPUT_TYPE {cmos} \
    CONFIG.PSU_MIO_9_POLARITY {Default} \
    CONFIG.PSU_MIO_9_PULLUPDOWN {pullup} \
    CONFIG.PSU_MIO_9_SLEW {fast} \
    CONFIG.PSU_MIO_TREE_PERIPHERALS {GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#SD 0#SD 0#SD 0#SD 0#GPIO0 MIO#GPIO0\
MIO#GPIO0 MIO#GPIO0 MIO#SD 0#SD 0#GPIO0 MIO#SD 0#GPIO0 MIO#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#UART 1#UART 1#I2C 0#I2C 0#I2C 1#I2C 1#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1\
MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB 1#USB\
1#USB 1#USB 1#USB0 Reset#GPIO2 MIO} \
    CONFIG.PSU_MIO_TREE_SIGNALS {gpio0[0]#gpio0[1]#gpio0[2]#gpio0[3]#gpio0[4]#gpio0[5]#gpio0[6]#gpio0[7]#gpio0[8]#gpio0[9]#gpio0[10]#gpio0[11]#gpio0[12]#sdio0_data_out[0]#sdio0_data_out[1]#sdio0_data_out[2]#sdio0_data_out[3]#gpio0[17]#gpio0[18]#gpio0[19]#gpio0[20]#sdio0_cmd_out#sdio0_clk_out#gpio0[23]#sdio0_cd_n#gpio0[25]#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#txd#rxd#scl_out#sda_out#scl_out#sda_out#gpio1[38]#gpio1[39]#gpio1[40]#gpio1[41]#gpio1[42]#gpio1[43]#gpio1[44]#gpio1[45]#gpio1[46]#gpio1[47]#gpio1[48]#gpio1[49]#gpio1[50]#gpio1[51]#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#reset#gpio2[77]}\
\
    CONFIG.PSU_PERIPHERAL_BOARD_PRESET {} \
    CONFIG.PSU_SD0_INTERNAL_BUS_WIDTH {4} \
    CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
    CONFIG.PSU_SMC_CYCLE_T0 {NA} \
    CONFIG.PSU_SMC_CYCLE_T1 {NA} \
    CONFIG.PSU_SMC_CYCLE_T2 {NA} \
    CONFIG.PSU_SMC_CYCLE_T3 {NA} \
    CONFIG.PSU_SMC_CYCLE_T4 {NA} \
    CONFIG.PSU_SMC_CYCLE_T5 {NA} \
    CONFIG.PSU_SMC_CYCLE_T6 {NA} \
    CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
    CONFIG.PSU_VALUE_SILVERSION {3} \
    CONFIG.PSU__ACPU0__POWER__ON {1} \
    CONFIG.PSU__ACPU1__POWER__ON {1} \
    CONFIG.PSU__ACPU2__POWER__ON {1} \
    CONFIG.PSU__ACPU3__POWER__ON {1} \
    CONFIG.PSU__ACTUAL__IP {1} \
    CONFIG.PSU__ACT_DDR_FREQ_MHZ {1199.999756} \
    CONFIG.PSU__AUX_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__CAN0_LOOP_CAN1__ENABLE {0} \
    CONFIG.PSU__CAN0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.999756} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
    CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
    CONFIG.PSU__CRF_APB__ACPU__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI0_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI0_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI1_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI1_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI2_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI2_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI3_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI3_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI4_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI4_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__ACT_FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__DIVISOR0 {2} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__FREQMHZ {667} \
    CONFIG.PSU__CRF_APB__AFI5_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__AFI5_REF__ENABLE {0} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__APM_CTRL__ACT_FREQMHZ {1} \
    CONFIG.PSU__CRF_APB__APM_CTRL__DIVISOR0 {1} \
    CONFIG.PSU__CRF_APB__APM_CTRL__FREQMHZ {1} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.999954} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.999954} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {599.999878} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1200} \
    CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.999878} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.999996} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__FREQMHZ {25} \
    CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.249996} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__FREQMHZ {27} \
    CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.999939} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__FREQMHZ {300} \
    CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.999878} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {599.999878} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {600} \
    CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__ACT_FREQMHZ {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__DIVISOR0 {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__FREQMHZ {-1} \
    CONFIG.PSU__CRF_APB__GTGREF0_REF_CTRL__SRCSEL {NA} \
    CONFIG.PSU__CRF_APB__GTGREF0__ENABLE {NA} \
    CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {399.999908} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.333} \
    CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {524.999939} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {533.333} \
    CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__ACT_FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__AFI6__ENABLE {0} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999992} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__FREQMHZ {50} \
    CONFIG.PSU__CRL_APB__AMS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.999908} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__ACT_FREQMHZ {180} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__DIVISOR0 {3} \
    CONFIG.PSU__CRL_APB__CSU_PLL_CTRL__SRCSEL {SysOsc} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.999954} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__ACT_FREQMHZ {1000} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__DIVISOR0 {6} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__FREQMHZ {1000} \
    CONFIG.PSU__CRL_APB__DEBUG_R5_ATCLK_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.999756} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__FREQMHZ {1500} \
    CONFIG.PSU__CRL_APB__DLL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
    CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {262.499969} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {267} \
    CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {524.999939} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {533.333} \
    CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__NAND_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__ACT_FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__DIVISOR0 {3} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__FREQMHZ {500} \
    CONFIG.PSU__CRL_APB__OCM_MAIN_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.499969} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__ACT_FREQMHZ {299.999939} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {300} \
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__PL2_REF_CTRL__ACT_FREQMHZ {9.999999} \
    CONFIG.PSU__CRL_APB__PL3_REF_CTRL__ACT_FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {299.997009} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {300} \
    CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACFREQ {27.138} \
    CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__ACT_FREQMHZ {187.499969} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__ACT_FREQMHZ {199.998001} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__ACT_FREQMHZ {199.998001} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__FREQMHZ {200} \
    CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__SRCSEL {RPLL} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {33.333328} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {PSS_REF_CLK} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999985} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
    CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.999954} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__ACT_FREQMHZ {249.999954} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__FREQMHZ {250} \
    CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999996} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
    CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
    CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
    CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_0__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_10__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_11__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_12__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_1__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_2__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_3__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_4__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_5__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_6__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_7__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_8__ENABLE {0} \
    CONFIG.PSU__CSU__CSU_TAMPER_9__ENABLE {0} \
    CONFIG.PSU__CSU__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__DDRC__AL {0} \
    CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
    CONFIG.PSU__DDRC__BRC_MAPPING {BANK_ROW_COL} \
    CONFIG.PSU__DDRC__BUS_WIDTH {32 Bit} \
    CONFIG.PSU__DDRC__CL {17} \
    CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
    CONFIG.PSU__DDRC__COMPONENTS {Components} \
    CONFIG.PSU__DDRC__CWL {16} \
    CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {1} \
    CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
    CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
    CONFIG.PSU__DDRC__DDR4_MAXPWR_SAVING_EN {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
    CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
    CONFIG.PSU__DDRC__DEVICE_CAPACITY {16384 MBits} \
    CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
    CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
    CONFIG.PSU__DDRC__ECC {Disabled} \
    CONFIG.PSU__DDRC__ECC_SCRUB {0} \
    CONFIG.PSU__DDRC__ENABLE {1} \
    CONFIG.PSU__DDRC__ENABLE_2T_TIMING {0} \
    CONFIG.PSU__DDRC__ENABLE_DP_SWITCH {0} \
    CONFIG.PSU__DDRC__EN_2ND_CLK {0} \
    CONFIG.PSU__DDRC__FGRM {1X} \
    CONFIG.PSU__DDRC__FREQ_MHZ {1} \
    CONFIG.PSU__DDRC__LPDDR3_DUALRANK_SDP {0} \
    CONFIG.PSU__DDRC__LP_ASR {manual normal} \
    CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
    CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
    CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
    CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
    CONFIG.PSU__DDRC__PLL_BYPASS {0} \
    CONFIG.PSU__DDRC__PWR_DOWN_EN {0} \
    CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
    CONFIG.PSU__DDRC__RD_DQS_CENTER {0} \
    CONFIG.PSU__DDRC__ROW_ADDR_COUNT {17} \
    CONFIG.PSU__DDRC__SB_TARGET {<Select>} \
    CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
    CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2400T} \
    CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
    CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
    CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
    CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
    CONFIG.PSU__DDRC__T_FAW {30.0} \
    CONFIG.PSU__DDRC__T_RAS_MIN {32.0} \
    CONFIG.PSU__DDRC__T_RC {46.16} \
    CONFIG.PSU__DDRC__T_RCD {17} \
    CONFIG.PSU__DDRC__T_RP {17} \
    CONFIG.PSU__DDRC__VIDEO_BUFFER_SIZE {0} \
    CONFIG.PSU__DDRC__VREF {1} \
    CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
    CONFIG.PSU__DDR_QOS_ENABLE {0} \
    CONFIG.PSU__DDR_QOS_HP0_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP0_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP1_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP1_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP2_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP2_WRQOS {} \
    CONFIG.PSU__DDR_QOS_HP3_RDQOS {} \
    CONFIG.PSU__DDR_QOS_HP3_WRQOS {} \
    CONFIG.PSU__DDR_SW_REFRESH_ENABLED {1} \
    CONFIG.PSU__DDR__INTERFACE__FREQMHZ {600.000} \
    CONFIG.PSU__DEVICE_TYPE {EG} \
    CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
    CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
    CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DLL__ISUSED {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
    CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
    CONFIG.PSU__DP__REF_CLK_FREQ {27} \
    CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk0} \
    CONFIG.PSU__ENABLE__DDR__REFRESH__SIGNALS {0} \
    CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET2__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__EN_AXI_STATUS_PORTS {0} \
    CONFIG.PSU__EN_EMIO_TRACE {0} \
    CONFIG.PSU__EP__IP {0} \
    CONFIG.PSU__EXPAND__CORESIGHT {0} \
    CONFIG.PSU__EXPAND__FPD_SLAVES {0} \
    CONFIG.PSU__EXPAND__GIC {0} \
    CONFIG.PSU__EXPAND__LOWER_LPS_SLAVES {0} \
    CONFIG.PSU__EXPAND__UPPER_LPS_SLAVES {0} \
    CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100} \
    CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__FPGA_PL1_ENABLE {1} \
    CONFIG.PSU__FPGA_PL2_ENABLE {0} \
    CONFIG.PSU__FPGA_PL3_ENABLE {0} \
    CONFIG.PSU__FP__POWER__ON {1} \
    CONFIG.PSU__FTM__CTI_IN_0 {0} \
    CONFIG.PSU__FTM__CTI_IN_1 {0} \
    CONFIG.PSU__FTM__CTI_IN_2 {0} \
    CONFIG.PSU__FTM__CTI_IN_3 {0} \
    CONFIG.PSU__FTM__CTI_OUT_0 {0} \
    CONFIG.PSU__FTM__CTI_OUT_1 {0} \
    CONFIG.PSU__FTM__CTI_OUT_2 {0} \
    CONFIG.PSU__FTM__CTI_OUT_3 {0} \
    CONFIG.PSU__FTM__GPI {0} \
    CONFIG.PSU__FTM__GPO {0} \
    CONFIG.PSU__GEN_IPI_0__MASTER {APU} \
    CONFIG.PSU__GEN_IPI_10__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_1__MASTER {RPU0} \
    CONFIG.PSU__GEN_IPI_2__MASTER {RPU1} \
    CONFIG.PSU__GEN_IPI_3__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_4__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_5__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_6__MASTER {PMU} \
    CONFIG.PSU__GEN_IPI_7__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_8__MASTER {NONE} \
    CONFIG.PSU__GEN_IPI_9__MASTER {NONE} \
    CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
    CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO2_MIO__IO {MIO 52 .. 77} \
    CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO_EMIO_WIDTH {64} \
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {64} \
    CONFIG.PSU__GPIO_EMIO__WIDTH {[94:0]} \
    CONFIG.PSU__GPU_PP0__POWER__ON {1} \
    CONFIG.PSU__GPU_PP1__POWER__ON {1} \
    CONFIG.PSU__GT_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__GT__LINK_SPEED {HBR} \
    CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
    CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
    CONFIG.PSU__HPM0_FPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM0_FPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__HPM0_LPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM0_LPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__HPM1_FPD__NUM_READ_THREADS {4} \
    CONFIG.PSU__HPM1_FPD__NUM_WRITE_THREADS {4} \
    CONFIG.PSU__I2C0_LOOP_I2C1__ENABLE {0} \
    CONFIG.PSU__I2C0__GRP_INT__ENABLE {0} \
    CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 34 .. 35} \
    CONFIG.PSU__I2C1__GRP_INT__ENABLE {0} \
    CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 36 .. 37} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
    CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100} \
    CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100} \
    CONFIG.PSU__IRQ_P2F_ADMA_CHAN__INT {0} \
    CONFIG.PSU__IRQ_P2F_AIB_AXI__INT {0} \
    CONFIG.PSU__IRQ_P2F_AMS__INT {0} \
    CONFIG.PSU__IRQ_P2F_APM_FPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_COMM__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_CPUMNT__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_CTI__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_EXTERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_L2ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_PMU__INT {0} \
    CONFIG.PSU__IRQ_P2F_APU_REGS__INT {0} \
    CONFIG.PSU__IRQ_P2F_ATB_LPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_CLKMON__INT {0} \
    CONFIG.PSU__IRQ_P2F_DDR_SS__INT {0} \
    CONFIG.PSU__IRQ_P2F_DPDMA__INT {0} \
    CONFIG.PSU__IRQ_P2F_DPORT__INT {0} \
    CONFIG.PSU__IRQ_P2F_EFUSE__INT {0} \
    CONFIG.PSU__IRQ_P2F_FPD_APB__INT {0} \
    CONFIG.PSU__IRQ_P2F_FPD_ATB_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_FP_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_GDMA_CHAN__INT {0} \
    CONFIG.PSU__IRQ_P2F_GPIO__INT {0} \
    CONFIG.PSU__IRQ_P2F_GPU__INT {0} \
    CONFIG.PSU__IRQ_P2F_I2C0__INT {0} \
    CONFIG.PSU__IRQ_P2F_I2C1__INT {0} \
    CONFIG.PSU__IRQ_P2F_LPD_APB__INT {0} \
    CONFIG.PSU__IRQ_P2F_LPD_APM__INT {0} \
    CONFIG.PSU__IRQ_P2F_LP_WDT__INT {0} \
    CONFIG.PSU__IRQ_P2F_OCM_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_DMA__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_LEGACY__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_MSC__INT {0} \
    CONFIG.PSU__IRQ_P2F_PCIE_MSI__INT {0} \
    CONFIG.PSU__IRQ_P2F_PL_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_R5_CORE0_ECC_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_R5_CORE1_ECC_ERR__INT {0} \
    CONFIG.PSU__IRQ_P2F_RPU_IPI__INT {0} \
    CONFIG.PSU__IRQ_P2F_RPU_PERMON__INT {0} \
    CONFIG.PSU__IRQ_P2F_RTC_ALARM__INT {0} \
    CONFIG.PSU__IRQ_P2F_RTC_SECONDS__INT {0} \
    CONFIG.PSU__IRQ_P2F_SATA__INT {0} \
    CONFIG.PSU__IRQ_P2F_SDIO0_WAKE__INT {0} \
    CONFIG.PSU__IRQ_P2F_SDIO0__INT {0} \
    CONFIG.PSU__IRQ_P2F_UART1__INT {0} \
    CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_ENDPOINT__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_OTG__INT0 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_OTG__INT1 {0} \
    CONFIG.PSU__IRQ_P2F_USB3_PMU_WAKEUP__INT {0} \
    CONFIG.PSU__IRQ_P2F_XMPU_FPD__INT {0} \
    CONFIG.PSU__IRQ_P2F_XMPU_LPD__INT {0} \
    CONFIG.PSU__IRQ_P2F__INTF_FPD_SMMU__INT {0} \
    CONFIG.PSU__IRQ_P2F__INTF_PPD_CCI__INT {0} \
    CONFIG.PSU__L2_BANK0__POWER__ON {1} \
    CONFIG.PSU__LPDMA0_COHERENCY {0} \
    CONFIG.PSU__LPDMA1_COHERENCY {0} \
    CONFIG.PSU__LPDMA2_COHERENCY {0} \
    CONFIG.PSU__LPDMA3_COHERENCY {0} \
    CONFIG.PSU__LPDMA4_COHERENCY {0} \
    CONFIG.PSU__LPDMA5_COHERENCY {0} \
    CONFIG.PSU__LPDMA6_COHERENCY {0} \
    CONFIG.PSU__LPDMA7_COHERENCY {0} \
    CONFIG.PSU__LPD_SLCR__CSUPMU_WDT_CLK_SEL__SELECT {APB} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100} \
    CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100} \
    CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
    CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
    CONFIG.PSU__M_AXI_GP0_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__M_AXI_GP1_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__M_AXI_GP2_SUPPORTS_NARROW_BURST {1} \
    CONFIG.PSU__NAND__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__NAND__READY_BUSY__ENABLE {0} \
    CONFIG.PSU__NUM_FABRIC_RESETS {1} \
    CONFIG.PSU__OCM_BANK0__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK1__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK2__POWER__ON {1} \
    CONFIG.PSU__OCM_BANK3__POWER__ON {1} \
    CONFIG.PSU__OVERRIDE_HPX_QOS {0} \
    CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
    CONFIG.PSU__PCIE__ACS_VIOLAION {0} \
    CONFIG.PSU__PCIE__AER_CAPABILITY {0} \
    CONFIG.PSU__PCIE__CLASS_CODE_BASE {} \
    CONFIG.PSU__PCIE__CLASS_CODE_INTERFACE {} \
    CONFIG.PSU__PCIE__CLASS_CODE_SUB {} \
    CONFIG.PSU__PCIE__DEVICE_ID {} \
    CONFIG.PSU__PCIE__INTX_GENERATION {0} \
    CONFIG.PSU__PCIE__MSIX_CAPABILITY {0} \
    CONFIG.PSU__PCIE__MSI_CAPABILITY {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PCIE__PERIPHERAL__ENDPOINT_ENABLE {1} \
    CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_ENABLE {0} \
    CONFIG.PSU__PCIE__RESET__POLARITY {Active Low} \
    CONFIG.PSU__PCIE__REVISION_ID {} \
    CONFIG.PSU__PCIE__SUBSYSTEM_ID {} \
    CONFIG.PSU__PCIE__SUBSYSTEM_VENDOR_ID {} \
    CONFIG.PSU__PCIE__VENDOR_ID {} \
    CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PL_CLK0_BUF {TRUE} \
    CONFIG.PSU__PL_CLK1_BUF {FALSE} \
    CONFIG.PSU__PL__POWER__ON {1} \
    CONFIG.PSU__PMU__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__PRESET_APPLIED {0} \
    CONFIG.PSU__PROTECTION__DDR_SEGMENTS {NONE} \
    CONFIG.PSU__PROTECTION__ENABLE {0} \
    CONFIG.PSU__PROTECTION__FPD_SEGMENTS {SA:0xFD1A0000; SIZE:1280; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD000000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD010000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD020000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD030000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD040000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD050000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |   SA:0xFD610000; SIZE:512; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware  |   SA:0xFD5D0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware  |  SA:0xFD1A0000 ; SIZE:1280; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write;\
subsystemId:Secure Subsystem} \
    CONFIG.PSU__PROTECTION__LPD_SEGMENTS {SA:0xFF980000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF5E0000; SIZE:2560; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write;\
subsystemId:PMU Firmware| SA:0xFFCC0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFF180000; SIZE:768; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU\
Firmware| SA:0xFF410000; SIZE:640; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware| SA:0xFFA70000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|\
SA:0xFF9A0000; SIZE:64; UNIT:KB; RegionTZ:Secure; WrAllowed:Read/Write; subsystemId:PMU Firmware|SA:0xFF5E0000 ; SIZE:2560; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFFCC0000\
; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF180000 ; SIZE:768; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem|SA:0xFF9A0000\
; SIZE:64; UNIT:KB; RegionTZ:Secure ; WrAllowed:Read/Write; subsystemId:Secure Subsystem} \
    CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;1|USB0:NonSecure;1|S_AXI_LPD:NA;1|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;0|SD0:NonSecure;1|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;0|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1}\
\
    CONFIG.PSU__PROTECTION__MASTERS_TZ {GEM0:NonSecure|SD1:NonSecure|GEM2:NonSecure|GEM1:NonSecure|GEM3:NonSecure|PCIe:NonSecure|DP:NonSecure|NAND:NonSecure|GPU:NonSecure|USB1:NonSecure|USB0:NonSecure|LDMA:NonSecure|FDMA:NonSecure|QSPI:NonSecure|SD0:NonSecure}\
\
    CONFIG.PSU__PROTECTION__OCM_SEGMENTS {NONE} \
    CONFIG.PSU__PROTECTION__PRESUBSYSTEMS {NONE} \
    CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;1|LPD;USB3_1;FF9E0000;FF9EFFFF;1|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;0|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;0|LPD;SD0;FF160000;FF16FFFF;1|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;0|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display\
Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1}\
\
    CONFIG.PSU__PROTECTION__SUBSYSTEMS {PMU Firmware:PMU|Secure Subsystem:} \
    CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0} \
    CONFIG.PSU__PSS_ALT_REF_CLK__FREQMHZ {33.333} \
    CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.33333} \
    CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__REPORT__DBGLOG {0} \
    CONFIG.PSU__RPU_COHERENCY {0} \
    CONFIG.PSU__RPU__POWER__ON {1} \
    CONFIG.PSU__SATA__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
    CONFIG.PSU__SAXIGP6__DATA_WIDTH {128} \
    CONFIG.PSU__SD0_COHERENCY {0} \
    CONFIG.PSU__SD0_ROUTE_THROUGH_FPD {0} \
    CONFIG.PSU__SD0__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD0__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD0__DATA_TRANSFER_MODE {4Bit} \
    CONFIG.PSU__SD0__GRP_CD__ENABLE {1} \
    CONFIG.PSU__SD0__GRP_CD__IO {MIO 24} \
    CONFIG.PSU__SD0__GRP_POW__ENABLE {0} \
    CONFIG.PSU__SD0__GRP_WP__ENABLE {0} \
    CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 16 21 22} \
    CONFIG.PSU__SD0__SLOT_TYPE {SD 2.0} \
    CONFIG.PSU__SD1__CLK_100_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_200_SDR_OTAP_DLY {0x3} \
    CONFIG.PSU__SD1__CLK_50_DDR_ITAP_DLY {0x3D} \
    CONFIG.PSU__SD1__CLK_50_DDR_OTAP_DLY {0x4} \
    CONFIG.PSU__SD1__CLK_50_SDR_ITAP_DLY {0x15} \
    CONFIG.PSU__SD1__CLK_50_SDR_OTAP_DLY {0x5} \
    CONFIG.PSU__SD1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SD1__RESET__ENABLE {0} \
    CONFIG.PSU__SPI0_LOOP_SPI1__ENABLE {0} \
    CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SWDT0__PERIPHERAL__IO {NA} \
    CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__SWDT1__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TCM0A__POWER__ON {1} \
    CONFIG.PSU__TCM0B__POWER__ON {1} \
    CONFIG.PSU__TCM1A__POWER__ON {1} \
    CONFIG.PSU__TCM1B__POWER__ON {1} \
    CONFIG.PSU__TESTSCAN__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TRACE__INTERNAL_WIDTH {32} \
    CONFIG.PSU__TRACE__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TRISTATE__INVERTED {1} \
    CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC0__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC1__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC2__PERIPHERAL__IO {NA} \
    CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__TTC3__PERIPHERAL__IO {NA} \
    CONFIG.PSU__UART0_LOOP_UART1__ENABLE {0} \
    CONFIG.PSU__UART0__PERIPHERAL__ENABLE {0} \
    CONFIG.PSU__UART1__BAUD_RATE {115200} \
    CONFIG.PSU__UART1__MODEM__ENABLE {0} \
    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 32 .. 33} \
    CONFIG.PSU__USB0_COHERENCY {0} \
    CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
    CONFIG.PSU__USB0__REF_CLK_FREQ {100} \
    CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk1} \
    CONFIG.PSU__USB0__RESET__ENABLE {1} \
    CONFIG.PSU__USB0__RESET__IO {MIO 76} \
    CONFIG.PSU__USB1_COHERENCY {0} \
    CONFIG.PSU__USB1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB1__PERIPHERAL__IO {MIO 64 .. 75} \
    CONFIG.PSU__USB1__REF_CLK_FREQ {100} \
    CONFIG.PSU__USB1__REF_CLK_SEL {Ref Clk1} \
    CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB2_1__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
    CONFIG.PSU__USB3_1__EMIO__ENABLE {0} \
    CONFIG.PSU__USB3_1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__USB3_1__PERIPHERAL__IO {GT Lane3} \
    CONFIG.PSU__USB__RESET__MODE {Shared MIO Pin} \
    CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
    CONFIG.PSU__USE_DIFF_RW_CLK_GP2 {0} \
    CONFIG.PSU__USE__ADMA {0} \
    CONFIG.PSU__USE__APU_LEGACY_INTERRUPT {0} \
    CONFIG.PSU__USE__AUDIO {0} \
    CONFIG.PSU__USE__CLK {0} \
    CONFIG.PSU__USE__CLK0 {0} \
    CONFIG.PSU__USE__CLK1 {0} \
    CONFIG.PSU__USE__CLK2 {0} \
    CONFIG.PSU__USE__CLK3 {0} \
    CONFIG.PSU__USE__CROSS_TRIGGER {0} \
    CONFIG.PSU__USE__DDR_INTF_REQUESTED {0} \
    CONFIG.PSU__USE__DEBUG__TEST {0} \
    CONFIG.PSU__USE__EVENT_RPU {0} \
    CONFIG.PSU__USE__FABRIC__RST {1} \
    CONFIG.PSU__USE__FTM {0} \
    CONFIG.PSU__USE__GDMA {0} \
    CONFIG.PSU__USE__IRQ {0} \
    CONFIG.PSU__USE__IRQ0 {1} \
    CONFIG.PSU__USE__IRQ1 {1} \
    CONFIG.PSU__USE__M_AXI_GP0 {1} \
    CONFIG.PSU__USE__M_AXI_GP1 {0} \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__USE__PROC_EVENT_BUS {0} \
    CONFIG.PSU__USE__RPU_LEGACY_INTERRUPT {0} \
    CONFIG.PSU__USE__RST0 {0} \
    CONFIG.PSU__USE__RST1 {0} \
    CONFIG.PSU__USE__RST2 {0} \
    CONFIG.PSU__USE__RST3 {0} \
    CONFIG.PSU__USE__RTC {0} \
    CONFIG.PSU__USE__STM {0} \
    CONFIG.PSU__USE__S_AXI_ACE {0} \
    CONFIG.PSU__USE__S_AXI_ACP {0} \
    CONFIG.PSU__USE__S_AXI_GP0 {0} \
    CONFIG.PSU__USE__S_AXI_GP1 {0} \
    CONFIG.PSU__USE__S_AXI_GP2 {1} \
    CONFIG.PSU__USE__S_AXI_GP3 {1} \
    CONFIG.PSU__USE__S_AXI_GP4 {0} \
    CONFIG.PSU__USE__S_AXI_GP5 {0} \
    CONFIG.PSU__USE__S_AXI_GP6 {1} \
    CONFIG.PSU__USE__USB3_0_HUB {0} \
    CONFIG.PSU__USE__USB3_1_HUB {0} \
    CONFIG.PSU__USE__VIDEO {0} \
    CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0} \
    CONFIG.PSU__VIDEO_REF_CLK__FREQMHZ {33.333} \
    CONFIG.QSPI_BOARD_INTERFACE {custom} \
    CONFIG.SATA_BOARD_INTERFACE {custom} \
    CONFIG.SD0_BOARD_INTERFACE {custom} \
    CONFIG.SD1_BOARD_INTERFACE {custom} \
    CONFIG.SPI0_BOARD_INTERFACE {custom} \
    CONFIG.SPI1_BOARD_INTERFACE {custom} \
    CONFIG.SUBPRESET1 {Custom} \
    CONFIG.SUBPRESET2 {Custom} \
    CONFIG.SWDT0_BOARD_INTERFACE {custom} \
    CONFIG.SWDT1_BOARD_INTERFACE {custom} \
    CONFIG.TRACE_BOARD_INTERFACE {custom} \
    CONFIG.TTC0_BOARD_INTERFACE {custom} \
    CONFIG.TTC1_BOARD_INTERFACE {custom} \
    CONFIG.TTC2_BOARD_INTERFACE {custom} \
    CONFIG.TTC3_BOARD_INTERFACE {custom} \
    CONFIG.UART0_BOARD_INTERFACE {custom} \
    CONFIG.UART1_BOARD_INTERFACE {custom} \
    CONFIG.USB0_BOARD_INTERFACE {custom} \
    CONFIG.USB1_BOARD_INTERFACE {custom} \
  ] $zynq_ultra_ps_e_0


  # Create instance: audio
  create_hier_cell_audio [current_bd_instance .] audio

  # Create instance: mipi
  create_hier_cell_mipi [current_bd_instance .] mipi

  # Create instance: pl_user_led, and set properties
  set pl_user_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_user_led ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {8} \
  ] $pl_user_led


  # Create instance: pl_rgb0_led, and set properties
  set pl_rgb0_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_rgb0_led ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $pl_rgb0_led


  # Create instance: pl_rgb1_led, and set properties
  set pl_rgb1_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_rgb1_led ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $pl_rgb1_led


  # Create instance: pl_rgb2_led, and set properties
  set pl_rgb2_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_rgb2_led ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $pl_rgb2_led


  # Create instance: pl_rgb3_led, and set properties
  set pl_rgb3_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_rgb3_led ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $pl_rgb3_led


  # Create instance: SEL_JOYSTICK, and set properties
  set SEL_JOYSTICK [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 SEL_JOYSTICK ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $SEL_JOYSTICK


  # Create instance: pl_user_pb, and set properties
  set pl_user_pb [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_user_pb ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {4} \
    CONFIG.C_INTERRUPT_PRESENT {1} \
  ] $pl_user_pb


  # Create instance: pl_user_sw, and set properties
  set pl_user_sw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_user_sw ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_GPIO_WIDTH {8} \
    CONFIG.C_INTERRUPT_PRESENT {1} \
  ] $pl_user_sw


  # Create instance: shutdown_HP0_FPD, and set properties
  set shutdown_HP0_FPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 shutdown_HP0_FPD ]
  set_property -dict [list \
    CONFIG.CTRL_INTERFACE_TYPE {1} \
    CONFIG.DP_AXI_DATA_WIDTH {128} \
  ] $shutdown_HP0_FPD


  # Create instance: iop_grove0
  create_hier_cell_iop_grove0 [current_bd_instance .] iop_grove0

  # Create instance: iop_rpi0
  create_hier_cell_iop_rpi0 [current_bd_instance .] iop_rpi0

  # Create instance: iop_pmod0
  create_hier_cell_iop_pmod0 [current_bd_instance .] iop_pmod0

  # Create instance: iop_pmod1
  create_hier_cell_iop_pmod1 [current_bd_instance .] iop_pmod1

  # Create instance: mdm_0, and set properties
  set mdm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_0 ]
  set_property CONFIG.C_MB_DBG_PORTS {4} $mdm_0


  # Create instance: mb_iop_pmod0_reset, and set properties
  set mb_iop_pmod0_reset [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_pmod0_reset ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_pmod0_reset


  # Create instance: mb_iop_pmod0_intr_ack, and set properties
  set mb_iop_pmod0_intr_ack [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_pmod0_intr_ack ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_pmod0_intr_ack


  # Create instance: iop_pmod0_buf, and set properties
  set iop_pmod0_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 iop_pmod0_buf ]
  set_property -dict [list \
    CONFIG.C_BUF_TYPE {IOBUF} \
    CONFIG.C_SIZE {8} \
  ] $iop_pmod0_buf


  # Create instance: mb_iop_pmod1_reset, and set properties
  set mb_iop_pmod1_reset [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_pmod1_reset ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_pmod1_reset


  # Create instance: mb_iop_pmod1_intr_ack, and set properties
  set mb_iop_pmod1_intr_ack [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_pmod1_intr_ack ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_pmod1_intr_ack


  # Create instance: iop_pmod1_buf, and set properties
  set iop_pmod1_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 iop_pmod1_buf ]
  set_property -dict [list \
    CONFIG.C_BUF_TYPE {IOBUF} \
    CONFIG.C_SIZE {8} \
  ] $iop_pmod1_buf


  # Create instance: mb_iop_rpi0_reset, and set properties
  set mb_iop_rpi0_reset [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_rpi0_reset ]
  set_property -dict [list \
    CONFIG.DIN_FROM {2} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_rpi0_reset


  # Create instance: mb_iop_rpi0_intr_ack, and set properties
  set mb_iop_rpi0_intr_ack [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_rpi0_intr_ack ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_rpi0_intr_ack


  # Create instance: iop_rpi0_buf, and set properties
  set iop_rpi0_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 iop_rpi0_buf ]
  set_property -dict [list \
    CONFIG.C_BUF_TYPE {IOBUF} \
    CONFIG.C_SIZE {28} \
  ] $iop_rpi0_buf


  # Create instance: mb_iop_grove0_reset, and set properties
  set mb_iop_grove0_reset [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_grove0_reset ]
  set_property -dict [list \
    CONFIG.DIN_FROM {3} \
    CONFIG.DIN_TO {3} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_grove0_reset


  # Create instance: mb_iop_grove0_intr_ack, and set properties
  set mb_iop_grove0_intr_ack [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 mb_iop_grove0_intr_ack ]
  set_property -dict [list \
    CONFIG.DIN_FROM {4} \
    CONFIG.DIN_TO {4} \
    CONFIG.DIN_WIDTH {10} \
  ] $mb_iop_grove0_intr_ack


  # Create instance: iop_grove0_buf, and set properties
  set iop_grove0_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 iop_grove0_buf ]
  set_property -dict [list \
    CONFIG.C_BUF_TYPE {IOBUF} \
    CONFIG.C_SIZE {4} \
  ] $iop_grove0_buf


  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property CONFIG.C_IRQ_CONNECTION {1} $axi_intc_0


  # Create instance: iop_axi_interconnect_lpd, and set properties
  set iop_axi_interconnect_lpd [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 iop_axi_interconnect_lpd ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {4} \
  ] $iop_axi_interconnect_lpd


  # Create instance: address_remap_0, and set properties
  set address_remap_0 [ create_bd_cell -type ip -vlnv user.org:user:address_remap:1.0 address_remap_0 ]
  set_property -dict [list \
    CONFIG.C_M_AXI_out_ADDR_WIDTH {31} \
    CONFIG.C_M_AXI_out_DATA_WIDTH {128} \
    CONFIG.C_S_AXI_in_ADDR_WIDTH {31} \
    CONFIG.C_S_AXI_in_DATA_WIDTH {128} \
  ] $address_remap_0


  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_register_slice_0 ]

  # Create instance: shutdown_LPD, and set properties
  set shutdown_LPD [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_axi_shutdown_manager:1.0 shutdown_LPD ]
  set_property -dict [list \
    CONFIG.CTRL_INTERFACE_TYPE {1} \
    CONFIG.DP_AXI_DATA_WIDTH {128} \
  ] $shutdown_LPD


  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [list \
    CONFIG.c_include_sg {0} \
    CONFIG.c_m_axi_mm2s_data_width {128} \
    CONFIG.c_m_axi_s2mm_data_width {128} \
    CONFIG.c_m_axis_mm2s_tdata_width {32} \
    CONFIG.c_s_axis_s2mm_tdata_width {32} \
    CONFIG.c_sg_length_width {26} \
  ] $axi_dma_0


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property CONFIG.NUM_SI {2} $smartconnect_0


  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 axis_data_fifo_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net CAM_1 [get_bd_intf_ports CAM] [get_bd_intf_pins mipi/mipi_phy_if_0]
  connect_bd_intf_net -intf_net DEBUG_1 [get_bd_intf_pins iop_pmod0/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_0]
  connect_bd_intf_net -intf_net DEBUG_2 [get_bd_intf_pins iop_pmod1/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_1]
  connect_bd_intf_net -intf_net DEBUG_3 [get_bd_intf_pins iop_rpi0/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_2]
  connect_bd_intf_net -intf_net DEBUG_4 [get_bd_intf_pins iop_grove0/DEBUG] [get_bd_intf_pins mdm_0/MBDEBUG_3]
  connect_bd_intf_net -intf_net SEL_JOYSTICK_GPIO [get_bd_intf_ports SEL_JOYSTICK] [get_bd_intf_pins SEL_JOYSTICK/GPIO]
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_pins iop_pmod0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M20_AXI]
  connect_bd_intf_net -intf_net S_AXI_2 [get_bd_intf_pins iop_pmod1/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M21_AXI]
  connect_bd_intf_net -intf_net S_AXI_3 [get_bd_intf_pins iop_rpi0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M22_AXI]
  connect_bd_intf_net -intf_net S_AXI_4 [get_bd_intf_pins iop_grove0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M23_AXI]
  connect_bd_intf_net -intf_net Vp_Vn_0_1 [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins system_management_wiz_0/Vp_Vn]
  connect_bd_intf_net -intf_net address_remap_0_M_AXI_out [get_bd_intf_pins address_remap_0/M_AXI_out] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net audio_i2c_aic [get_bd_intf_ports i2c_aic] [get_bd_intf_pins audio/i2c_aic]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins shutdown_LPD/S_AXI]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins axis_data_fifo_0/M_AXIS] [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net diff_analog_io_rtl_0_1 [get_bd_intf_ports HORZ] [get_bd_intf_pins system_management_wiz_0/Vaux8]
  connect_bd_intf_net -intf_net diff_analog_io_rtl_1_1 [get_bd_intf_ports VERT] [get_bd_intf_pins system_management_wiz_0/Vaux9]
  connect_bd_intf_net -intf_net i2s_rx_s_axi_ctrl_i_1 [get_bd_intf_pins audio/i2s_rx_s_axi_ctrl_i] [get_bd_intf_pins ps8_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net i2s_tx_s_axi_ctrl_i_1 [get_bd_intf_pins audio/i2s_tx_s_axi_ctrl_i] [get_bd_intf_pins ps8_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net iop_axi_interconnect_lpd_M00_AXI [get_bd_intf_pins iop_axi_interconnect_lpd/M00_AXI] [get_bd_intf_pins address_remap_0/S_AXI_in]
  connect_bd_intf_net -intf_net iop_grove0_M_AXI [get_bd_intf_pins iop_grove0/M_AXI] [get_bd_intf_pins iop_axi_interconnect_lpd/S03_AXI]
  connect_bd_intf_net -intf_net iop_pmod0_M_AXI [get_bd_intf_pins iop_pmod0/M_AXI] [get_bd_intf_pins iop_axi_interconnect_lpd/S00_AXI]
  connect_bd_intf_net -intf_net iop_pmod1_M_AXI [get_bd_intf_pins iop_pmod1/M_AXI] [get_bd_intf_pins iop_axi_interconnect_lpd/S01_AXI]
  connect_bd_intf_net -intf_net iop_rpi0_M_AXI [get_bd_intf_pins iop_rpi0/M_AXI] [get_bd_intf_pins iop_axi_interconnect_lpd/S02_AXI]
  connect_bd_intf_net -intf_net mipi_IIC_0_0 [get_bd_intf_ports IIC_0_0] [get_bd_intf_pins mipi/IIC_0_0]
  connect_bd_intf_net -intf_net pl_rgb0_led_GPIO [get_bd_intf_ports PL_LEDRGB0] [get_bd_intf_pins pl_rgb0_led/GPIO]
  connect_bd_intf_net -intf_net pl_rgb1_led_GPIO [get_bd_intf_ports PL_LEDRGB1] [get_bd_intf_pins pl_rgb1_led/GPIO]
  connect_bd_intf_net -intf_net pl_rgb2_led_GPIO [get_bd_intf_ports PL_LEDRGB2] [get_bd_intf_pins pl_rgb2_led/GPIO]
  connect_bd_intf_net -intf_net pl_rgb3_led_GPIO [get_bd_intf_ports PL_LEDRGB3] [get_bd_intf_pins pl_rgb3_led/GPIO]
  connect_bd_intf_net -intf_net pl_user_led_GPIO [get_bd_intf_ports PL_USER_LED] [get_bd_intf_pins pl_user_led/GPIO]
  connect_bd_intf_net -intf_net pl_user_pb_GPIO [get_bd_intf_ports PL_USER_PB] [get_bd_intf_pins pl_user_pb/GPIO]
  connect_bd_intf_net -intf_net pl_user_sw_GPIO [get_bd_intf_ports PL_USER_SW] [get_bd_intf_pins pl_user_sw/GPIO]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins ps8_0_axi_periph/M00_AXI] [get_bd_intf_pins pl_rgb0_led/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins ps8_0_axi_periph/M01_AXI] [get_bd_intf_pins pl_rgb1_led/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins ps8_0_axi_periph/M02_AXI] [get_bd_intf_pins pl_rgb2_led/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins ps8_0_axi_periph/M03_AXI] [get_bd_intf_pins pl_rgb3_led/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins ps8_0_axi_periph/M04_AXI] [get_bd_intf_pins pl_user_led/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins ps8_0_axi_periph/M05_AXI] [get_bd_intf_pins axi_intc_0/s_axi]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M08_AXI [get_bd_intf_pins ps8_0_axi_periph/M08_AXI] [get_bd_intf_pins audio/axi_i2c_ctrl_i]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M09_AXI [get_bd_intf_pins ps8_0_axi_periph/M09_AXI] [get_bd_intf_pins SEL_JOYSTICK/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M10_AXI [get_bd_intf_pins ps8_0_axi_periph/M10_AXI] [get_bd_intf_pins audio/axi_gpio_ctrl_i]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M11_AXI [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M12_AXI [get_bd_intf_pins ps8_0_axi_periph/M12_AXI] [get_bd_intf_pins pl_user_pb/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M13_AXI [get_bd_intf_pins ps8_0_axi_periph/M13_AXI] [get_bd_intf_pins pl_user_sw/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M14_AXI [get_bd_intf_pins ps8_0_axi_periph/M14_AXI] [get_bd_intf_pins shutdown_HP0_FPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M15_AXI [get_bd_intf_pins ps8_0_axi_periph/M15_AXI] [get_bd_intf_pins mipi/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M16_AXI [get_bd_intf_pins ps8_0_axi_periph/M16_AXI] [get_bd_intf_pins mipi/csirxss_s_axi]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M17_AXI [get_bd_intf_pins ps8_0_axi_periph/M17_AXI] [get_bd_intf_pins mipi/S_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M18_AXI [get_bd_intf_pins ps8_0_axi_periph/M18_AXI] [get_bd_intf_pins shutdown_LPD/S_AXI_CTRL]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M19_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M19_AXI]
  connect_bd_intf_net -intf_net shutdown_HP0_FPD_M_AXI [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD] [get_bd_intf_pins shutdown_HP0_FPD/M_AXI]
  connect_bd_intf_net -intf_net shutdown_LPD_M_AXI [get_bd_intf_pins shutdown_LPD/M_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_LPD]
  connect_bd_intf_net -intf_net shutdown_hp0_fdp [get_bd_intf_pins mipi/M00_AXI] [get_bd_intf_pins shutdown_HP0_FPD/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins mipi/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_LPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD]

  # Create port connections
  connect_bd_net -net Net  [get_bd_ports iop_pmod0] \
  [get_bd_pins iop_pmod0_buf/IOBUF_IO_IO]
  connect_bd_net -net Net1  [get_bd_ports iop_pmod1] \
  [get_bd_pins iop_pmod1_buf/IOBUF_IO_IO]
  connect_bd_net -net Net2  [get_bd_ports iop_rpi0] \
  [get_bd_pins iop_rpi0_buf/IOBUF_IO_IO]
  connect_bd_net -net Net3  [get_bd_ports iop_grove0] \
  [get_bd_pins iop_grove0_buf/IOBUF_IO_IO]
  connect_bd_net -net audio_AIC_mclk_o  [get_bd_pins audio/AIC_mclk_o] \
  [get_bd_ports AIC_mclk_o]
  connect_bd_net -net audio_AIC_nRST_tri_o  [get_bd_pins audio/AIC_nRST_tri_o] \
  [get_bd_ports AIC_nRST]
  connect_bd_net -net audio_i2s_rx_irq_o  [get_bd_pins audio/i2s_rx_irq_o] \
  [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net audio_i2s_tx_irq_o  [get_bd_pins audio/i2s_tx_irq_o] \
  [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net audio_iic2intc_irpt  [get_bd_pins audio/iic2intc_irpt] \
  [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net audio_lrclk_out_0  [get_bd_pins audio/lrclk_o] \
  [get_bd_ports AIC_lrclk_o]
  connect_bd_net -net audio_sclk_out_0  [get_bd_pins audio/sclk_o] \
  [get_bd_ports AIC_sclk_o]
  connect_bd_net -net audio_sdata_0_out_0  [get_bd_pins audio/i2s_tx_sdata_o] \
  [get_bd_ports AIC_sdata_o]
  connect_bd_net -net axi_intc_0_irq  [get_bd_pins axi_intc_0/irq] \
  [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net data_i_1  [get_bd_pins iop_pmod0_buf/IOBUF_IO_O] \
  [get_bd_pins iop_pmod0/data_i]
  connect_bd_net -net data_i_2  [get_bd_pins iop_pmod1_buf/IOBUF_IO_O] \
  [get_bd_pins iop_pmod1/data_i]
  connect_bd_net -net data_i_3  [get_bd_pins iop_rpi0_buf/IOBUF_IO_O] \
  [get_bd_pins iop_rpi0/data_i]
  connect_bd_net -net data_i_4  [get_bd_pins iop_grove0_buf/IOBUF_IO_O] \
  [get_bd_pins iop_grove0/data_i]
  connect_bd_net -net i2s_rx_sdata_i_0_1  [get_bd_ports AIC_sdata_i] \
  [get_bd_pins audio/i2s_rx_sdata_i]
  connect_bd_net -net iop_grove0_data_o  [get_bd_pins iop_grove0/data_o] \
  [get_bd_pins iop_grove0_buf/IOBUF_IO_I]
  connect_bd_net -net iop_grove0_intr_req  [get_bd_pins iop_grove0/intr_req] \
  [get_bd_pins xlconcat_0/In11]
  connect_bd_net -net iop_grove0_peripheral_aresetn  [get_bd_pins iop_grove0/peripheral_aresetn] \
  [get_bd_pins iop_axi_interconnect_lpd/S03_ARESETN]
  connect_bd_net -net iop_grove0_tri_o  [get_bd_pins iop_grove0/tri_o] \
  [get_bd_pins iop_grove0_buf/IOBUF_IO_T]
  connect_bd_net -net iop_pmod0_data_o  [get_bd_pins iop_pmod0/data_o] \
  [get_bd_pins iop_pmod0_buf/IOBUF_IO_I]
  connect_bd_net -net iop_pmod0_intr_req  [get_bd_pins iop_pmod0/intr_req] \
  [get_bd_pins xlconcat_0/In8]
  connect_bd_net -net iop_pmod0_peripheral_aresetn  [get_bd_pins iop_pmod0/peripheral_aresetn] \
  [get_bd_pins iop_axi_interconnect_lpd/S00_ARESETN]
  connect_bd_net -net iop_pmod0_tri_o  [get_bd_pins iop_pmod0/tri_o] \
  [get_bd_pins iop_pmod0_buf/IOBUF_IO_T]
  connect_bd_net -net iop_pmod1_data_o  [get_bd_pins iop_pmod1/data_o] \
  [get_bd_pins iop_pmod1_buf/IOBUF_IO_I]
  connect_bd_net -net iop_pmod1_intr_req  [get_bd_pins iop_pmod1/intr_req] \
  [get_bd_pins xlconcat_0/In9]
  connect_bd_net -net iop_pmod1_peripheral_aresetn  [get_bd_pins iop_pmod1/peripheral_aresetn] \
  [get_bd_pins address_remap_0/s_axi_in_aresetn] \
  [get_bd_pins address_remap_0/m_axi_out_aresetn] \
  [get_bd_pins iop_axi_interconnect_lpd/S01_ARESETN]
  connect_bd_net -net iop_pmod1_tri_o  [get_bd_pins iop_pmod1/tri_o] \
  [get_bd_pins iop_pmod1_buf/IOBUF_IO_T]
  connect_bd_net -net iop_rpi0_data_o  [get_bd_pins iop_rpi0/data_o] \
  [get_bd_pins iop_rpi0_buf/IOBUF_IO_I]
  connect_bd_net -net iop_rpi0_intr_req  [get_bd_pins iop_rpi0/intr_req] \
  [get_bd_pins xlconcat_0/In10]
  connect_bd_net -net iop_rpi0_peripheral_aresetn  [get_bd_pins iop_rpi0/peripheral_aresetn] \
  [get_bd_pins iop_axi_interconnect_lpd/S02_ARESETN]
  connect_bd_net -net iop_rpi0_tri_o  [get_bd_pins iop_rpi0/tri_o] \
  [get_bd_pins iop_rpi0_buf/IOBUF_IO_T]
  connect_bd_net -net mb_debug_sys_rst_1  [get_bd_pins mdm_0/Debug_SYS_Rst] \
  [get_bd_pins iop_pmod0/mb_debug_sys_rst] \
  [get_bd_pins iop_pmod1/mb_debug_sys_rst] \
  [get_bd_pins iop_rpi0/mb_debug_sys_rst] \
  [get_bd_pins iop_grove0/mb_debug_sys_rst]
  connect_bd_net -net mb_iop_grove0_intr_ack_Dout  [get_bd_pins mb_iop_grove0_intr_ack/Dout] \
  [get_bd_pins iop_grove0/intr_ack]
  connect_bd_net -net mb_iop_grove0_reset_Dout  [get_bd_pins mb_iop_grove0_reset/Dout] \
  [get_bd_pins iop_grove0/aux_reset_in]
  connect_bd_net -net mb_iop_pmod0_intr_ack_Dout  [get_bd_pins mb_iop_pmod0_intr_ack/Dout] \
  [get_bd_pins iop_pmod0/intr_ack]
  connect_bd_net -net mb_iop_pmod0_reset_Dout  [get_bd_pins mb_iop_pmod0_reset/Dout] \
  [get_bd_pins iop_pmod0/aux_reset_in]
  connect_bd_net -net mb_iop_pmod1_intr_ack_Dout  [get_bd_pins mb_iop_pmod1_intr_ack/Dout] \
  [get_bd_pins iop_pmod1/intr_ack]
  connect_bd_net -net mb_iop_pmod1_reset_Dout  [get_bd_pins mb_iop_pmod1_reset/Dout] \
  [get_bd_pins iop_pmod1/aux_reset_in]
  connect_bd_net -net mb_iop_rpi0_intr_ack_Dout  [get_bd_pins mb_iop_rpi0_intr_ack/Dout] \
  [get_bd_pins iop_rpi0/intr_ack]
  connect_bd_net -net mb_iop_rpi0_reset_Dout  [get_bd_pins mb_iop_rpi0_reset/Dout] \
  [get_bd_pins iop_rpi0/aux_reset_in]
  connect_bd_net -net mipi_cam_gpio_tri_o  [get_bd_pins mipi/cam_gpio_tri_o] \
  [get_bd_ports rpi_enb]
  connect_bd_net -net mipi_csirxss_csi_irq_o  [get_bd_pins mipi/csirxss_csi_irq] \
  [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net mipi_peripheral_aresetn  [get_bd_pins mipi/peripheral_aresetn] \
  [get_bd_pins shutdown_HP0_FPD/resetn] \
  [get_bd_pins ps8_0_axi_periph/M14_ARESETN]
  connect_bd_net -net mipi_s2mm_introut  [get_bd_pins mipi/s2mm_introut] \
  [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net pl_ps_irq1  [get_bd_pins mipi/iic2intc_irpt] \
  [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]
  connect_bd_net -net pl_user_pb_ip2intc_irpt  [get_bd_pins pl_user_pb/ip2intc_irpt] \
  [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net pl_user_sw_ip2intc_irpt  [get_bd_pins pl_user_sw/ip2intc_irpt] \
  [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net rst_ps8_0_99M_interconnect_aresetn  [get_bd_pins rst_ps8_0_99M/interconnect_aresetn] \
  [get_bd_pins iop_axi_interconnect_lpd/M00_ARESETN] \
  [get_bd_pins axi_register_slice_0/aresetn] \
  [get_bd_pins shutdown_LPD/resetn] \
  [get_bd_pins iop_axi_interconnect_lpd/ARESETN]
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn  [get_bd_pins rst_ps8_0_99M/peripheral_aresetn] \
  [get_bd_pins mipi/lite_aresetn] \
  [get_bd_pins ps8_0_axi_periph/ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M00_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M01_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M02_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M03_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M04_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M05_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M06_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M07_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M08_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M09_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M10_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M11_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M12_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M13_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M15_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M16_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M17_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M18_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M19_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/S00_ARESETN] \
  [get_bd_pins system_management_wiz_0/s_axi_aresetn] \
  [get_bd_pins audio/axi_ctrl_nrst_i] \
  [get_bd_pins pl_user_sw/s_axi_aresetn] \
  [get_bd_pins pl_rgb0_led/s_axi_aresetn] \
  [get_bd_pins pl_rgb1_led/s_axi_aresetn] \
  [get_bd_pins pl_rgb2_led/s_axi_aresetn] \
  [get_bd_pins pl_rgb3_led/s_axi_aresetn] \
  [get_bd_pins pl_user_led/s_axi_aresetn] \
  [get_bd_pins SEL_JOYSTICK/s_axi_aresetn] \
  [get_bd_pins pl_user_pb/s_axi_aresetn] \
  [get_bd_pins iop_pmod0/s_axi_aresetn] \
  [get_bd_pins iop_pmod1/s_axi_aresetn] \
  [get_bd_pins iop_rpi0/s_axi_aresetn] \
  [get_bd_pins iop_grove0/s_axi_aresetn] \
  [get_bd_pins axi_intc_0/s_axi_aresetn] \
  [get_bd_pins ps8_0_axi_periph/M20_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M21_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M22_ARESETN] \
  [get_bd_pins ps8_0_axi_periph/M23_ARESETN] \
  [get_bd_pins smartconnect_0/aresetn] \
  [get_bd_pins axi_dma_0/axi_resetn] \
  [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
  connect_bd_net -net system_management_wiz_0_ip2intc_irpt  [get_bd_pins system_management_wiz_0/ip2intc_irpt] \
  [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net xlconcat_0_dout  [get_bd_pins xlconcat_0/dout] \
  [get_bd_pins axi_intc_0/intr]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o  [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] \
  [get_bd_pins mb_iop_pmod0_reset/Din] \
  [get_bd_pins mb_iop_pmod0_intr_ack/Din] \
  [get_bd_pins mb_iop_pmod1_reset/Din] \
  [get_bd_pins mb_iop_pmod1_intr_ack/Din] \
  [get_bd_pins mb_iop_rpi0_reset/Din] \
  [get_bd_pins mb_iop_rpi0_intr_ack/Din] \
  [get_bd_pins mb_iop_grove0_reset/Din] \
  [get_bd_pins mb_iop_grove0_intr_ack/Din]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0  [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
  [get_bd_pins mipi/lite_aclk] \
  [get_bd_pins ps8_0_axi_periph/ACLK] \
  [get_bd_pins ps8_0_axi_periph/M00_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M01_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M02_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M03_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M04_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M05_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M06_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M07_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M08_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M09_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M10_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M11_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M12_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M13_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M15_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M16_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M17_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M18_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M19_ACLK] \
  [get_bd_pins ps8_0_axi_periph/S00_ACLK] \
  [get_bd_pins rst_ps8_0_99M/slowest_sync_clk] \
  [get_bd_pins system_management_wiz_0/s_axi_aclk] \
  [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] \
  [get_bd_pins audio/axi_ctrl_clk_i] \
  [get_bd_pins pl_rgb0_led/s_axi_aclk] \
  [get_bd_pins pl_rgb1_led/s_axi_aclk] \
  [get_bd_pins pl_rgb2_led/s_axi_aclk] \
  [get_bd_pins pl_rgb3_led/s_axi_aclk] \
  [get_bd_pins pl_user_led/s_axi_aclk] \
  [get_bd_pins SEL_JOYSTICK/s_axi_aclk] \
  [get_bd_pins pl_user_pb/s_axi_aclk] \
  [get_bd_pins pl_user_sw/s_axi_aclk] \
  [get_bd_pins iop_pmod0/clk_100M] \
  [get_bd_pins iop_pmod1/clk_100M] \
  [get_bd_pins iop_rpi0/clk_100M] \
  [get_bd_pins iop_grove0/clk_100M] \
  [get_bd_pins axi_intc_0/s_axi_aclk] \
  [get_bd_pins zynq_ultra_ps_e_0/saxi_lpd_aclk] \
  [get_bd_pins iop_axi_interconnect_lpd/M00_ACLK] \
  [get_bd_pins address_remap_0/s_axi_in_aclk] \
  [get_bd_pins address_remap_0/m_axi_out_aclk] \
  [get_bd_pins axi_register_slice_0/aclk] \
  [get_bd_pins shutdown_LPD/clk] \
  [get_bd_pins iop_axi_interconnect_lpd/ACLK] \
  [get_bd_pins iop_axi_interconnect_lpd/S00_ACLK] \
  [get_bd_pins iop_axi_interconnect_lpd/S01_ACLK] \
  [get_bd_pins iop_axi_interconnect_lpd/S02_ACLK] \
  [get_bd_pins iop_axi_interconnect_lpd/S03_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M20_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M21_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M22_ACLK] \
  [get_bd_pins ps8_0_axi_periph/M23_ACLK] \
  [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk] \
  [get_bd_pins axis_data_fifo_0/s_axis_aclk] \
  [get_bd_pins axi_dma_0/s_axi_lite_aclk] \
  [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] \
  [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] \
  [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk1  [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] \
  [get_bd_pins mipi/video_aclk] \
  [get_bd_pins ps8_0_axi_periph/M14_ACLK] \
  [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] \
  [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] \
  [get_bd_pins shutdown_HP0_FPD/clk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0  [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
  [get_bd_pins mipi/aux_reset_in] \
  [get_bd_pins rst_ps8_0_99M/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0x800B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs SEL_JOYSTICK/S_AXI/Reg] -force
  assign_bd_address -offset 0x800F0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x80090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80140000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x800A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio/axi_iic_aic/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80150000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/axi_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/demosaic/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/gamma_lut/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/gpio_ip_reset/S_AXI/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio/i2s_receiver_0/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0x80080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs audio/i2s_transmitter_0/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0x80100000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs iop_grove0/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80110000 -range 0x00010000 -with_name SEG_mb_bram_ctrl_Mem0_1 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs iop_pmod0/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80120000 -range 0x00010000 -with_name SEG_mb_bram_ctrl_Mem0_2 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs iop_pmod1/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80130000 -range 0x00010000 -with_name SEG_mb_bram_ctrl_Mem0_3 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs iop_rpi0/mb_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x80160000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/mipi_csi2_rx_subsyst/csirxss_s_axi/Reg] -force
  assign_bd_address -offset 0xA0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/pixel_pack/s_axi_control/Reg] -force
  assign_bd_address -offset 0x800E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_rgb0_led/S_AXI/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_rgb1_led/S_AXI/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_rgb2_led/S_AXI/Reg] -force
  assign_bd_address -offset 0x80030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_rgb3_led/S_AXI/Reg] -force
  assign_bd_address -offset 0x80040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_user_led/S_AXI/Reg] -force
  assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_user_pb/S_AXI/Reg] -force
  assign_bd_address -offset 0x800D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_user_sw/S_AXI/Reg] -force
  assign_bd_address -offset 0x80170000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs shutdown_HP0_FPD/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x80060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs shutdown_LPD/S_AXI_CTRL/Reg] -force
  assign_bd_address -offset 0x80070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs system_management_wiz_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0xA0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs mipi/v_proc_sys/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces address_remap_0/M_AXI_out] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces mipi/axi_vdma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/iic0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/iic1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/timer0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Data] [get_bd_addr_segs iop_grove0/timer1/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_grove0/mb/Instruction] [get_bd_addr_segs iop_grove0/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/iic_subsystem/iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40810000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/iic_subsystem/iic_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/rpi_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/spi_subsystem/spi_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/spi_subsystem/spi_1/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/timers_subsystem/timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41C10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/timers_subsystem/timer_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Data] [get_bd_addr_segs iop_rpi0/uartlite/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_rpi0/mb/Instruction] [get_bd_addr_segs iop_rpi0/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/spi/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Data] [get_bd_addr_segs iop_pmod0/timer/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod0/mb/Instruction] [get_bd_addr_segs iop_pmod0/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs address_remap_0/S_AXI_in/memory] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/intr/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/io_switch/S_AXI/S_AXI_reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/lmb/lmb_bram_if_cntlr/SLMB1/Mem] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/spi/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Data] [get_bd_addr_segs iop_pmod1/timer/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces iop_pmod1/mb/Instruction] [get_bd_addr_segs iop_pmod1/lmb/lmb_bram_if_cntlr/SLMB/Mem] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces address_remap_0/M_AXI_out] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_DDR_HIGH]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces address_remap_0/M_AXI_out] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP6/LPD_LPS_OCM]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces mipi/axi_vdma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_HIGH]
  exclude_bd_addr_seg -offset 0xFF000000 -range 0x01000000 -target_address_space [get_bd_addr_spaces mipi/axi_vdma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


