all: wheel

wheel:
	python3 setup.py bdist_wheel

zcu111:
	cd boards/ZCU111 && $(MAKE)
	
ultra96:
	cd boards/Ultra96 && $(MAKE)

rfsoc2x2:
	cd boards/RFSoC2x2 && $(MAKE)

clean_zcu111:
	cd boards/ZCU111 && $(MAKE) clean
	
clean_ultra96:
	cd boards/Ultra96 && $(MAKE) clean

clean_rfsoc2x2:
	cd boards/RFSoC2x2 && $(MAKE) clean
