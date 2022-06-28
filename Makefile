# Copyright (C) 2021 Xilinx, Inc
# SPDX-License-Identifier: BSD-3-Clause
all: rfsoc2x2 zcu111 rfsoc4x2 ultra96 tarball

rfsoc2x2:
	$(MAKE) -C boards/RFSoC2x2/

zcu111:
	$(MAKE) -C boards/ZCU111/

rfsoc4x2:
	$(MAKE) -C boards/RFSoC4x2/

ultra96:
	$(MAKE) -C boards/Ultra96/
	
tarball:
	touch dsp_pynq.tar.gz
	tar --exclude='.[^/]*' --exclude="dsp_pynq.tar.gz" -czvf dsp_pynq.tar.gz .
