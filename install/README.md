# OS assumption: Linux (x86_64 or arm64)

## Install a fresh micromamba environment:
```bash 
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```
(Please do configure for conda-forge and start the environment - set up init as you wish, but do activate the base / created environment)

## Install build-dependencies for McStas/McXtrace:
```bash 
micromamba install git compilers cmake make flex bison
```

## Install runtime-dependencies for McStas/McXtrace (mcrun + basic calculations only)
```bash 
micromamba install bash pyaml numpy mcpl ncrystal xraylib cif2hkl gsl libnexus openmpi=4 ucx
```

## Install runtime-dependencies for McStas/McXtrace (visualisation+gui+bells+whistles)
```bash 
micromamba install python=3.12 pyqt\>=5.10 qscintilla2 matplotlib-base tornado\>=5 scipy pillow pyqtgraph qtpy nodejs ply rsync jinja2 mcstasscript jupytext jupyterlab nexpy
```

## (shallow) Clone the McCode repo hackathon branch:
```bash 
git clone --depth 1 https://github.com/mccode-dev/McCode.git -b Helmholtz-hackathon-2025
```

## Build McStas:
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

## Build McXtrace:
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

## Activate nvhpc
Likely just a matter of
```bash 
module load nvhpc
``` 
(If for your own machine, download from https://developer.nvidia.com/hpc-sdk-downloads) 

## Compile and run a McStas instrument on GPU (use `mxrun` and `$MCXTRACE for McXtrace`)
```bash 
cp $MCSTAS/examples/Templates/mini/mini.instr .
mcrun -c mini.instr --openacc dummy=0 -n1e7
```
* Leaving out `--openacc` means targeting CPU
* `-n` specifies problem size
* Use `--verbose` to get increased cogen / compilation output
* `--mpi=N` parallelizes by mpi


## Run a GPU test for a named McStas instrument (use `mxtest` for McXtrace)
```bash 
mctest --testdir /some/location --openacc -n1e7 --instr=PSI_DMC
```
* Leaving out the `--instr` filter runs the "full suite"
* Leaving out `--openacc` means targeting CPU
* `--mpi=N` parallelizes by mpi
* `mcviewtest` can be used to render a HTML result table [example](https://new-nightly.mcstas.org/2025-03-14_output.html) 

## Configure for "Multicore" OpenACC:
```bash
mcrun --write-user-config
```
and hack your `.mcstas/3.99.999/mccode_config.json` replacing `-acc=gpu -gpu=mem:managed` by `-acc=multicore`
