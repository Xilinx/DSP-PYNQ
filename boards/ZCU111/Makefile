design_name := dsp_pynq
bitfile := bitstreams/$(design_name).bit

all: $(bitfile)

$(bitfile):
	vivado -mode batch -notrace -nojournal -nolog -source create_project.tcl

clean:
	rm -rf $(design_name) bitstreams *.jou *.log NA
