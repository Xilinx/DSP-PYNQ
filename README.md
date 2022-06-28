# DSP-PYNQ
These notebooks act as a tutorial on how to develop a DSP application using Python and PYNQ. The first notebook is a primer on both DSP and Python packages centered around DSP functionality. The second notebook takes the knowledge learned from the first and uses it to perform similar functions, but using hardware IP on the programmable logic.

# Support
This repo supports the following boards:
   - ZCU111
   - Ultra96 v1
   - Ultra96 v2
   - RFSoC2x2
   - RFSoC4x2

> The Ultra96 version of the design only supports Jupyter Notebooks.

## Getting started
All the material in this repo is available in the [PYNQ RFSoC Workshop](https://github.com/Xilinx/PYNQ_RFSOC_Workshop). This is not the case for the Ultra96, meaning this repo has to be installed separately if using that board.

The SD card images for all boards can be downloaded from the [PYNQ website](http://www.pynq.io/board.html) and burned to a micro SD card with at least 16GB capacity.

To install this repo separately, follow the instructions below.

### Overlay installation
We supply a pre-built tarball containing the overlay for that tagged release. This can be installed directly with Pip using the Terminal built into JupyterLab.

```bash
pip3 install https://github.com/Xilinx/DSP-PYNQ/releases/download/v3.1/dsp_pynq-3.1.tar.gz
```

The notebooks should then be available from the Jupyter file browser inside the `dsp_pynq` directory.

## Building the project 
> NOTE: This must be built on an x86 Linux PC, with Vivado 2020.2 and Python 3 installed and available on $PATH. This cannot be built on the board.

If you want to rebuild the overlay yourself, this can be done from a Linux PC with Python3 and Vivado 2020.2 installed. Clone this repo and use make to build the overlays for all supported boards.:

```sh
git clone https://github.com/Xilinx/DSP-PYNQ.git
cd DSP-PYNQ
make
```

This will result in a tarball at the top directory named `dsp_pynq.tar.gz`. Copy this onto your board and run the following command to install:

```sh
pip install -I <path-to-tarball>
```

## License
[BSD 3-Clause](https://github.com/Xilinx/DSP-PYNQ/blob/master/LICENSE)
