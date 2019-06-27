
################################################################
# This is a generated script based on design: block_design
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
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source block_design_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu3eg-sbva484-1-e
   set_property BOARD_PART em.avnet.com:ultra96v2:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name block_design

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
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

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

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:zynq_ultra_ps_e:3.2\
xilinx.com:ip:xfft:9.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:fir_compiler:7.2\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: filter
proc create_hier_cell_filter { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_filter() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk m_axi_mm2s_aclk

  # Create instance: fir, and set properties
  set fir [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir ]
  set_property -dict [ list \
   CONFIG.Clock_Frequency {100} \
   CONFIG.CoefficientVector {-0.000333912973374 -0.000158154938371 0.000056469747219 0.000292705879689 0.000525410677215 0.000720013808847 0.000834195940056 0.000823730019296 0.000652233264362 0.000303216517156 -0.000208353193715 -0.000828391759099 -0.001463187467247 -0.001988235274543 -0.002266782750391 -0.002176171236587 -0.001637786389659 -0.000644709120239 0.000719537168166 0.002277096045308 0.003770634484755 0.004897593023999 0.005360564380899 0.004926672497658 0.003485808121566 0.001096131079148 -0.001994132101091 -0.005356739841433 -0.008428716859416 -0.010590217098921 -0.011266011586396 -0.010036192553785 -0.006738178093881 -0.001541372645145 0.005021708824754 0.012078544584790 0.018496767659390 0.023015147188820 0.024410328537685 0.021677200554268 0.014196745919055 0.001865140602017 -0.014838047260028 -0.034856883959033 -0.056645157352880 -0.078323765831984 -0.097890754340091 -0.113456892948180 -0.123475093106866 0.872657653312830 -0.123475093106866 -0.113456892948180 -0.097890754340091 -0.078323765831984 -0.056645157352880 -0.034856883959033 -0.014838047260028 0.001865140602017 0.014196745919055 0.021677200554268 0.024410328537685 0.023015147188820 0.018496767659390 0.012078544584790 0.005021708824754 -0.001541372645145 -0.006738178093881 -0.010036192553785 -0.011266011586396 -0.010590217098921 -0.008428716859416 -0.005356739841433 -0.001994132101091 0.001096131079148 0.003485808121566 0.004926672497658 0.005360564380899 0.004897593023999 0.003770634484755 0.002277096045308 0.000719537168166 -0.000644709120239 -0.001637786389659 -0.002176171236587 -0.002266782750391 -0.001988235274543 -0.001463187467247 -0.000828391759099 -0.000208353193715 0.000303216517156 0.000652233264362 0.000823730019296 0.000834195940056 0.000720013808847 0.000525410677215 0.000292705879689 0.000056469747219 -0.000158154938371 -0.000333912973374} \
   CONFIG.Coefficient_Fractional_Bits {15} \
   CONFIG.Coefficient_Reload {true} \
   CONFIG.Coefficient_Sets {1} \
   CONFIG.Coefficient_Sign {Signed} \
   CONFIG.Coefficient_Structure {Inferred} \
   CONFIG.Coefficient_Width {16} \
   CONFIG.DATA_Has_TLAST {Packet_Framing} \
   CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
   CONFIG.M_DATA_Has_TREADY {true} \
   CONFIG.Output_Rounding_Mode {Truncate_LSBs} \
   CONFIG.Output_Width {32} \
   CONFIG.Quantization {Quantize_Only} \
   CONFIG.Sample_Frequency {0.048} \
 ] $fir

  # Create instance: fir_config, and set properties
  set fir_config [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 fir_config ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {8} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $fir_config

  # Create instance: fir_data, and set properties
  set fir_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 fir_data ]
  set_property -dict [ list \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $fir_data

  # Create instance: fir_reload, and set properties
  set fir_reload [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 fir_reload ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $fir_reload

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins fir_config/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins fir_config/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins fir/S_AXIS_DATA] [get_bd_intf_pins fir_data/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_1_M_AXIS_MM2S [get_bd_intf_pins fir/S_AXIS_RELOAD] [get_bd_intf_pins fir_reload/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net fir_M_AXIS_DATA [get_bd_intf_pins fir/M_AXIS_DATA] [get_bd_intf_pins fir_data/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net fir_config_M_AXIS_MM2S [get_bd_intf_pins fir/S_AXIS_CONFIG] [get_bd_intf_pins fir_config/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net fir_data_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins fir_data/M_AXI_MM2S]
  connect_bd_intf_net -intf_net fir_data_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins fir_data/M_AXI_S2MM]
  connect_bd_intf_net -intf_net fir_reload_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins fir_reload/M_AXI_MM2S]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins fir_data/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins fir_reload/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins fir_config/axi_resetn] [get_bd_pins fir_data/axi_resetn] [get_bd_pins fir_reload/axi_resetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins m_axi_mm2s_aclk] [get_bd_pins fir/aclk] [get_bd_pins fir_config/m_axi_mm2s_aclk] [get_bd_pins fir_config/s_axi_lite_aclk] [get_bd_pins fir_data/m_axi_mm2s_aclk] [get_bd_pins fir_data/m_axi_s2mm_aclk] [get_bd_pins fir_data/s_axi_lite_aclk] [get_bd_pins fir_reload/m_axi_mm2s_aclk] [get_bd_pins fir_reload/s_axi_lite_aclk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: fft
proc create_hier_cell_fft { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_fft() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: fft, and set properties
  set fft [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.1 fft ]
  set_property -dict [ list \
   CONFIG.implementation_options {automatically_select} \
   CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {7} \
   CONFIG.output_ordering {natural_order} \
   CONFIG.rounding_modes {convergent_rounding} \
   CONFIG.target_clock_frequency {100} \
   CONFIG.target_data_throughput {100} \
   CONFIG.transform_length {16384} \
 ] $fft

  # Create instance: fft_config, and set properties
  set fft_config [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 fft_config ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $fft_config

  # Create instance: fft_data, and set properties
  set fft_data [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 fft_data ]
  set_property -dict [ list \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $fft_data

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_3_M_AXIS_MM2S [get_bd_intf_pins fft/S_AXIS_DATA] [get_bd_intf_pins fft_data/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_dma_4_M_AXIS_MM2S [get_bd_intf_pins fft/S_AXIS_CONFIG] [get_bd_intf_pins fft_config/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net fft_M_AXIS_DATA [get_bd_intf_pins fft/M_AXIS_DATA] [get_bd_intf_pins fft_data/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net fft_config_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins fft_config/M_AXI_MM2S]
  connect_bd_intf_net -intf_net fft_data_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins fft_data/M_AXI_MM2S]
  connect_bd_intf_net -intf_net fft_data_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins fft_data/M_AXI_S2MM]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins fft_data/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins fft_config/S_AXI_LITE]

  # Create port connections
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins fft_config/axi_resetn] [get_bd_pins fft_data/axi_resetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axi_lite_aclk] [get_bd_pins fft/aclk] [get_bd_pins fft_config/m_axi_mm2s_aclk] [get_bd_pins fft_config/s_axi_lite_aclk] [get_bd_pins fft_data/m_axi_mm2s_aclk] [get_bd_pins fft_data/m_axi_s2mm_aclk] [get_bd_pins fft_data/s_axi_lite_aclk]

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
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {7} \
 ] $axi_smc

  # Create instance: fft
  create_hier_cell_fft [current_bd_instance .] fft

  # Create instance: filter
  create_hier_cell_filter [current_bd_instance .] filter

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {5} \
 ] $ps8_0_axi_periph

  # Create instance: rst_ps8_0_99M, and set properties
  set rst_ps8_0_99M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_99M ]

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x40000000} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;0|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;0|SD0:NonSecure;0|SATA1:NonSecure;0|SATA0:NonSecure;0|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;0|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;0|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;0|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;0|LPD;USB3_0;FF9D0000;FF9DFFFF;0|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;0|LPD;TTC3;FF140000;FF14FFFF;0|LPD;TTC2;FF130000;FF13FFFF;0|LPD;TTC1;FF120000;FF12FFFF;0|LPD;TTC0;FF110000;FF11FFFF;0|FPD;SWDT1;FD4D0000;FD4DFFFF;0|LPD;SWDT0;FF150000;FF15FFFF;0|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;0|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;0|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|FPD;RCPU_GIC;F9000000;F900FFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;0|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;0|LPD;I2C0;FF020000;FF02FFFF;0|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;0|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;0|FPD;DPDMA;FD4C0000;FD4CFFFF;0|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;3FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net fft_config_M_AXI_MM2S [get_bd_intf_pins axi_smc/S06_AXI] [get_bd_intf_pins fft/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net fft_data_M_AXI_MM2S [get_bd_intf_pins axi_smc/S04_AXI] [get_bd_intf_pins fft/M_AXI_MM2S]
  connect_bd_intf_net -intf_net fft_data_M_AXI_S2MM [get_bd_intf_pins axi_smc/S05_AXI] [get_bd_intf_pins fft/M_AXI_S2MM]
  connect_bd_intf_net -intf_net fir_data_M_AXI_MM2S [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins filter/M_AXI_MM2S]
  connect_bd_intf_net -intf_net fir_data_M_AXI_S2MM [get_bd_intf_pins axi_smc/S01_AXI] [get_bd_intf_pins filter/M_AXI_S2MM]
  connect_bd_intf_net -intf_net fir_reload_M_AXI_MM2S [get_bd_intf_pins axi_smc/S02_AXI] [get_bd_intf_pins filter/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net hier_0_M_AXI_MM2S2 [get_bd_intf_pins axi_smc/S03_AXI] [get_bd_intf_pins filter/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins filter/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins filter/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins filter/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins fft/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins fft/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

  # Create port connections
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins axi_smc/aresetn] [get_bd_pins fft/axi_resetn] [get_bd_pins filter/axi_resetn] [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_smc/aclk] [get_bd_pins fft/s_axi_lite_aclk] [get_bd_pins filter/m_axi_mm2s_aclk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps8_0_99M/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_ps8_0_99M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs fft/fft_config/S_AXI_LITE/Reg] SEG_fft_config_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0001000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs fft/fft_data/S_AXI_LITE/Reg] SEG_fft_data_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0002000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs filter/fir_config/S_AXI_LITE/Reg] SEG_fir_config_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0003000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs filter/fir_data/S_AXI_LITE/Reg] SEG_fir_data_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0004000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs filter/fir_reload/S_AXI_LITE/Reg] SEG_fir_reload_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces fft/fft_config/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces fft/fft_data/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces fft/fft_data/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces filter/fir_config/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces filter/fir_config/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces filter/fir_data/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces filter/fir_data/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces filter/fir_data/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces filter/fir_data/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces filter/fir_reload/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces filter/fir_reload/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM

  # Exclude Address Segments
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces fft/fft_config/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs fft/fft_config/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces fft/fft_data/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs fft/fft_data/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces fft/fft_data/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs fft/fft_data/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]



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


