# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause
design_name := dsp_pynq
bitfile := bitstreams/$(design_name).bit

all: $(bitfile) clean

$(bitfile):
	vivado -mode batch -notrace -nojournal -nolog -source create_project.tcl

clean:
	rm -rf $(design_name) *.jou *.log NA
