set proj_name "dsp_pynq"

create_project ${proj_name} ./${proj_name} -part xczu3eg-sbva484-1-i
#set_property BOARD_PART em.avnet.com:ultra96v2:part0:1.0 [current_project]
set_property target_language VHDL [current_project]

source ./block_design.tcl
make_wrapper -files [get_files ./${proj_name}/${proj_name}.srcs/sources_1/bd/block_design/block_design.bd] -top
add_files -norecurse ./${proj_name}/${proj_name}.srcs/sources_1/bd/block_design/hdl/block_design_wrapper.vhd
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream -jobs 16
wait_on_run impl_1

#get bitstream and hwh files
if {![file exists ./bitstreams/]} {
	file mkdir ./bitstreams/
	}

file copy -force ./${proj_name}/${proj_name}.runs/impl_1/block_design_wrapper.bit ./bitstreams/${proj_name}.bit
file copy -force ./${proj_name}/${proj_name}.srcs/sources_1/bd/block_design/hw_handoff/block_design.hwh ./bitstreams/${proj_name}.hwh
