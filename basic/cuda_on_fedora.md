# Prerequisites
Follow the instrcutions in `./fedora.md` to utilize the nvidia driver. 
Check Through `nvidia-smi`

# Install CUDA Toolkit
1. Download CUDA Toolkit from NVIDIA's website:[here](https://developer.nvidia.com/cuda-downloads)
   * You can check the document [here](https://developer.nvidia.com/cuda-toolkit-archive)
2. Follow the installation instructions for your system.
3. Add the path to the environment variable in `~/.bashrc`: `export PATH=/usr/local/cuda-11.0/bin:$PATH`. Remeber to `source ~/.bashrc`.
4. Check the installation by running `nvcc --version` in the terminal.
5. Use it!
> But wait, I encounter the gcc version requirement when compiling `.cu`
> So HERE is the MAIN CONTENT

## Install GCC from scratch
> You can use docker for sure. But the network problem troubles me. Hence, ONE host with different versions of GCC.
1. Download the source code of GCC from [here](https://ftp.gnu.org/gnu/gcc/)
2. unzipping the file
3. `./configure --prefix=/usr/local/gcc-10.2.0 --enable-languages=c,c++`
   * `--prefix` specifies the installation directory.
   * `--enable-languages` specifies the languages to be compiled. You can add `Fortran`
4. `make -j $(nproc) all`
5. `make install`
6. Add the path to the environment variable in different ways:
   * `export PATH=/usr/local/gcc-10.2.0/bin:$PATH`, it will replace the version installed before with your own.
   * write this in `bashrc`. Utilize GCC13 in specific directory.
        ```shell
        # >>> GCC-13 >>>
        export GCC_13="/usr/local/gcc13/"
        alias GCC13_INIT="export PATH=$GCC_13/bin:$PATH"
        ```
        `source` and Type `GCC13_INIT` to activate the environment.
    * You can specify it when compiling the `.cu` with `CC=/usr/local/gcc-10.2.0/bin/gcc-10.2.0 CXX=/usr/local/gcc-10.2.0/bin/g++-10.2.0` in the terminal.