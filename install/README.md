# Setup of environment for compilation and execution on JEDI
## 1. Deployment based on micromamba and conda-forge

### Install a fresh micromamba environment:
Recommendation: install to `echo ${PROJECT_training2508}/McStasMcXtrace/${USER}` -  and keep on pasteboard
```bash 
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```
Recommendation: activate the resulting enviroment `base` and simply
work in that.
```bash 
micromamba activate
```

### Install build-dependencies for McStas/McXtrace:
```bash 
micromamba install git compilers cmake make flex bison
```

### Install runtime-dependencies for McStas/McXtrace (mcrun + basic calculations only)
```bash 
micromamba install bash pyaml numpy mcpl ncrystal xraylib cif2hkl gsl libnexus
```
(On your own machine you may want `openmpi=4 ucx` too)

### Install runtime-dependencies for McStas/McXtrace 
#### _(visualisation+gui+bells+whistles - requires downgrade to python 3.12...)_
```bash 
micromamba install python=3.12 pyqt\>=5.10 qscintilla2 matplotlib-base tornado\>=5 scipy pillow pyqtgraph qtpy nodejs ply rsync jinja2 mcstasscript jupytext jupyterlab nexpy
```

## 2. Build McStas / McXtrace
### (shallow) Clone the McCode repo hackathon branch:
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


## 3. NVIDIA tools
### NVHPC
On JEDI a matter of
```bash 
module load NVHPC
```
For multiple GPU's via MPI also add
```
module load OpenMPI/5.0.5
```
Fur multiple GPU's you may need to:
* `export CUDA_VISIBLE_DEVICES=0,1,2,3
* configure `mpirun --oversubscribe` via `mcrun --write-user-config` and editing the resulting file
```
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.86.15              Driver Version: 570.86.15	   CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GH200 120GB             On  |   00000009:01:00.0 Off |                    0 |
| N/A   63C    P0            357W /  680W |     639MiB /  97871MiB |    100%	  Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+
|   1  NVIDIA GH200 120GB             On  |   00000019:01:00.0 Off |                    0 |
| N/A   62C    P0            345W /  680W |     639MiB /  97871MiB |    100%	  Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+
|   2  NVIDIA GH200 120GB             On  |   00000029:01:00.0 Off |                    0 |
| N/A   63C    P0            346W /  680W |     637MiB /  97871MiB |    100%	  Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+
|   3  NVIDIA GH200 120GB             On  |   00000039:01:00.0 Off |                    0 |
| N/A   62C    P0            321W /  680W |     638MiB /  97871MiB |    100%	  Default |
|                                         |                        |             Disabled |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage	  |
|=========================================================================================|
|    0   N/A  N/A          397006      C   ./mini.out                              622MiB |
|    1   N/A  N/A          397005      C   ./mini.out                              622MiB |
|    2   N/A  N/A          397003      C   ./mini.out                              622MiB |
|    3   N/A  N/A          397004      C   ./mini.out                              622MiB |
+-----------------------------------------------------------------------------------------+
``` 

### Profiling tools are available via
```bash 
module load Nsight-Compute
module load Nsight-Systems
```
## 4. Using "Nsight Systens and Compute" on own laptop
* Get [Nsight Systems](https://developer.nvidia.com/nsight-systems) for your local laptop
* Get [Nsight Compute](https://developer.nvidia.com/nsight-compute) for your laptop

# [Running simulations](running.md)
# [Plotting output](mcplot.md)
# [Suggested test-problems](TESTS.md)
# [Rough makeshift shell-scripts for investigating scalability](scripts)


