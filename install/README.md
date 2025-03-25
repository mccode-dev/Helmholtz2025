# Setup of environment for compilation and execution on JEDI
## Deployment based on micromamba and conda-forge

## Install a fresh micromamba environment:
Recommendation: install to `echo ${PROJECT_training2508}/McStasMcXtrace/${USER}` -  and keep on pasteboard
```bash 
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```
Recommendation: activate the resulting enviroment `base` and simply
work in that.
```bash 
micromamba activate
```

## Install build-dependencies for McStas/McXtrace:
```bash 
micromamba install git compilers cmake make flex bison
```

## Install runtime-dependencies for McStas/McXtrace (mcrun + basic calculations only)
```bash 
micromamba install bash pyaml numpy mcpl ncrystal xraylib cif2hkl gsl libnexus openmpi=4 ucx
```

## Install runtime-dependencies for McStas/McXtrace 
### (visualisation+gui+bells+whistles - requires downgrade to python 3.12...)
```bash 
micromamba install python=3.12 pyqt\>=5.10 qscintilla2 matplotlib-base tornado\>=5 scipy pillow pyqtgraph qtpy nodejs ply rsync jinja2 mcstasscript jupytext jupyterlab nexpy
```

# Build McStas / McXtrace
## (shallow) Clone the McCode repo hackathon branch:
```bash 
git clone --depth 1 https://github.com/mccode-dev/McCode.git -b Helmholtz-hackathon-2025
```

### a) Build McStas:
```bash https://github.com/mccode-dev/Helmholtz2025/tree/main/install
cd McCode
mkdir build && cd build
cmake \
    -DCMAKE_INSTALL_PREFIX="${CONDA_PREFIX}" \
    -S .. \
    -G "Unix Makefiles" \
    -DMCCODE_BUILD_CONDA_PKG=ON \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_MCSTAS=ON \
    -DMCCODE_USE_LEGACY_DESTINATIONS=OFF \
    -DBUILD_TOOLS=ON \
    -DENABLE_COMPONENTS=ON \
    -DENSURE_MCPL=OFF \
    -DENSURE_NCRYSTAL=OFF \
    -DENABLE_CIF2HKL=OFF \
    -DENABLE_NEUTRONICS=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DNEXUSLIB=${CONDA_PREFIX}/lib \
    -DNEXUSINCLUDE=${CONDA_PREFIX}/include/nexus \
    ${CMAKE_ARGS}
cmake --build . --config Release
cmake --build . --target install --config Release
```

### b) Build McXtrace:
```bash 
cd McCode
mkdir build && cd build
cmake \
    -DCMAKE_INSTALL_PREFIX="${CONDA_PREFIX}" \
    -S .. \
    -G "Unix Makefiles" \
    -DMCCODE_BUILD_CONDA_PKG=ON \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_MCXTRACE=ON \
    -DMCCODE_USE_LEGACY_DESTINATIONS=OFF \
    -DBUILD_TOOLS=ON \
    -DENABLE_COMPONENTS=ON \
    -DENSURE_MCPL=OFF \
    -DENSURE_NCRYSTAL=OFF \
    -DENABLE_CIF2HKL=OFF \
    -DENABLE_NEUTRONICS=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DNEXUSLIB=${CONDA_PREFIX}/lib \
    -DNEXUSINCLUDE=${CONDA_PREFIX}/include/nexus \
    ${CMAKE_ARGS}
cmake --build . --config Release
cmake --build . --target install --config Release
```





## NVIDIA tools
### NVHPC
On JEDI matter of
```bash 
module load NVHPC
```
### Profiling tools are availble via
```bash 
module load Nsight-Compute
module load Nsight-Systems
```
## Using "Nsight Systens and Compute" 
* Get [Nsight Systems](https://developer.nvidia.com/nsight-systems) for your local laptop
* Get [Nsight Compute](https://developer.nvidia.com/nsight-compute) for your laptop

### [Running simulations / tests](TESTS.md)




