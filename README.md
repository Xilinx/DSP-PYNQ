# DSP-PYNQ
These notebooks act as a tutorial on how to develop a DSP application using Python and PYNQ. The first notebook is a primer on both DSP and Python packages centered around DSP functionality.  The second notebook takes the knowledge learned from the first and uses it to perform similar functions but using hardware IP on the programmable logic.

## Getting started
All the material in this repo is available on the v2.4.1 PYNQ image for the ZCU111 - as part of the [PYNQ RFSoC Workshop](https://github.com/Xilinx/PYNQ_RFSOC_Workshop). The image can be downloaded from the [PYNQ website](http://www.pynq.io/board.html) and burned to a micro SD card with at least 16GB capacity.

If for some reason you would prefer to install this repo separately, then follow the instructions below:

### Requirements
- RFSoC ZCU111
- Pynq 2.4.1 image

### Overlay installation
We supply a pre-built wheel containing the bitstream for that tagged release. This can be installed directly with Pip.
```sh
# pip3 install https://github.com/Xilinx/DSP-PYNQ/releases/download/v1.0_$BOARD/dsp_pynq-1.0-py3-none-any.whl
# python3 -c 'import dsp_pynq; dsp_pynq.install_notebooks()'
```
The notebooks should then be available from the JupyterLab file browser inside the `dsp_pynq` directory.

## Building the wheel
> NOTE: This must be built on an x86 Linux PC, with Vivado and Python 3 installed and available on $PATH. This cannot be built on the board.

You can rebuild the entire wheel by running the following commands
```sh
$ git clone https://github.com/Xilinx/DSP-PYNQ
$ cd DSP-PYNQ
$ BOARD=ZCU111 make wheel
```

To build only the Vivado project you can run the following command.
```sh
$ make bitstream
```
