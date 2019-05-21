all: wheel

wheel:
	python3 setup.py bdist_wheel

bitstream:
	cd boards/ZCU111 && $(MAKE)

clean_bistream:
	cd boards/ZCU111 && $(MAKE) clean
