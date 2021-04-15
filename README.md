# DSP-PYNQ
These notebooks act as a tutorial on how to develop a DSP application using Python and PYNQ. The first notebook is a primer on both DSP and Python packages centered around DSP functionality. The second notebook takes the knowledge learned from the first and uses it to perform similar functions, but using hardware IP on the programmable logic.

# Support
This repo supports the following boards:
   - ZCU111
   - Ultra96 v1
   - Ultra96 v2
   - RFSoC2x2
   
> The Ultra96 version of the design only supports Jupyter Notebooks.

## Getting started
All the material in this repo is available on several PYNQ verions for the ZCU111 - and is included in the [PYNQ RFSoC Workshop](https://github.com/Xilinx/PYNQ_RFSOC_Workshop). This is not the case for the Ultra96 and RFSoC2x2, meaning this repo has to be installed separately if using either of those boards.

The SD card images for all boards can be downloaded from the [PYNQ website](http://www.pynq.io/board.html) and burned to a micro SD card with at least 8GB capacity.

To install this repo separately, follow the instructions below.

### Overlay installation
We supply a pre-built wheel containing the bitstream for that tagged release. This can be installed directly with Pip using the Terminal built in to JupyterLab.
```sh
# PYNQ v2.4.1 v2.5
pip3 install https://github.com/Xilinx/DSP-PYNQ/releases/download/v1.0_$BOARD/dsp_pynq-1.0-py3-none-any.whl

# PYNQ v2.6
pip3 install https://github.com/Xilinx/DSP-PYNQ/releases/download/v2.0_$BOARD/dsp_pynq-2.0-py3-none-any.whl

python3 -c 'import dsp_pynq; dsp_pynq.install_notebooks()'
```
The notebooks should then be available from the Jupyter file browser inside the `dsp_pynq` directory.

## Building the wheel
> NOTE: This must be built on an x86 Linux PC, with Vivado and Python 3 installed and available on $PATH. This cannot be built on the board.

You can rebuild the entire wheel by running the following commands.
```sh
$ git clone https://github.com/Xilinx/DSP-PYNQ
$ cd DSP-PYNQ
# to build for ZCU111
$ BOARD=ZCU111 make wheel
# to build for Ultra96
$ BOARD=Ultra96 make wheel
# to build for RFSoC2x2
$ BOARD=RFSoC2x2 make wheel
```

To build only the Vivado project you can run the following command.
```sh
# to build for ZCU111
$ make zcu111
# to build for Ultra96
$ make ultra96
# to build for RFSoC2x2
$ make rfsoc2x2
```
