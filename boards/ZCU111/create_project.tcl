# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause
set proj_name "dsp_pynq"

create_project ${proj_name} ./${proj_name} -part xczu28dr-ffvg1517-2-e
set_property board_part xilinx.com:zcu111:part0:1.1 [current_project]
set_property target_language VHDL [current_project]

source ./block_design.tcl
make_wrapper -files [get_files ./${proj_name}/${proj_name}.srcs/sources_1/bd/block_design/block_design.bd] -top
add_files -norecurse ./${proj_name}/${proj_name}.srcs/sources_1/bd/block_design/hdl/block_design_wrapper.vhd
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# get bitstream and hwh files
if {![file exists ./bitstreams/]} {
	file mkdir ./bitstreams/
	}

file copy -force ./${proj_name}/${proj_name}.runs/impl_1/block_design_wrapper.bit ./bitstreams/${proj_name}.bit
file copy -force ./${proj_name}/${proj_name}.gen/sources_1/bd/block_design/hw_handoff/block_design.hwh ./bitstreams/${proj_name}.hwh
