**!!! UNDER CONSTRUCTION!!!**


# Tools
## mcrun / mxrun
The basic "high-level" CLI interface to McStas is `mcrun` / for McXtrace `mxrun`. It automates conversion from McCode `DSL` grammar in instrument files to a functional binary for performing a given simulation. This includes:
1. Calling the `mcstas` / `mcxtrace` code generator that translates the McCode `DSL` to `c`-code
2. Taking various parallelsation-options and other setting into account during compilation
3. Calling the relevant compiler with the relevant settings, thereby generating an `.out` binary

During the compile-process, file time-stamps are investigated so that:
* A new `.c` code is generated if the `.instr` is newer than an existing `.c`
* A new binary `.out` is generated if the `.c` is newer than an existing `.out`
* add `--verbose` to get a glance at what is happening

Once a binary exists this is executed and any "simulation parameters" forwarded to the binary. Example run for single-cpu run:
```bash
export MCSTAS=$CONDA_PREFIX/share/mcstas/resources
cp $MCSTAS/examples/Templates/mini/mini.instr .
mcrun -c mini.instr --verbose dummy=0 -n1e7
INFO: No output directory specified (--dir)
INFO: Using directory: "mini_20250326_153956"
INFO: Regenerating c-file: mini.c
DEBUG: CMD: /where/youinstalled/mcstas/bin/mcstas -t -o ./mini.c mini.instr

-----------------------------------------------------------

Generating single GPU kernel or single CPU section layout: 

-----------------------------------------------------------

Generating GPU/CPU -DFUNNEL layout:

-----------------------------------------------------------
CFLAGS=
DEBUG: CMD: /where/youinstalled/mcstas/bin/mcstas finished
INFO: Recompiling: ./mini.out
DEBUG: CMD: /where/youinstalled/mcstas/bin/aarch64-conda-linux-gnu-cc -o ./mini.out ./mini.c -Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--allow-shlib-undefined -Wl,-rpath,/where/youinstalled/mcstas/lib -Wl,-rpath-link,/where/youinstalled/mcstas/lib -L/where/youinstalled/mcstas/lib -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O3 -pipe -isystem /where/youinstalled/mcstas/include -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O3 -pipe -isystem /where/youinstalled/mcstas/include -O2 -g -DNDEBUG -I/p/project1/training2508/McStasMcXtrace/willendrup1/include -Wl,-rpath,/where/youinstalled/mcstas/lib -L/where/youinstalled/mcstas/lib -fno-PIC -fPIE -flto -O3 -mtune=native -march=native -fno-math-errno -ftree-vectorize -g -DNDEBUG -D_POSIX_SOURCE -std=c99 -lm
DEBUG: CMD: /where/youinstalled/mcstas/bin/aarch64-conda-linux-gnu-cc finished
INFO: ===
DEBUG: CMD: ./mini.out --trace=0 --ncount=10000000.0 --dir=mini_20250326_153956 --format=McCode --bufsiz=10000000 dummy=0
*** TRACE end *** 
Detector: detector_I=345.985 detector_ERR=0.219791 detector_N=2.47797e+06 "PSD.dat"
DEBUG: CMD: ./mini.out finished
INFO: Placing instr file copy mini.instr in dataset mini_20250326_153956
INFO: Placing generated c-code copy mini.c in dataset mini_20250326_153956
```





The tools have the following main switches:



# Running on a GPU machine with --openacc, 
## OS requirement: Linux (x86_64 or arm64)
## Compile and run a McStas instrument on GPU (use `mxrun` and `$MCXTRACE for McXtrace`)
```bash
export MCSTAS=$CONDA_PREFIX/share/mcstas/resources
cp $MCSTAS/examples/Templates/mini/mini.instr .
mcrun -c mini.instr --openacc dummy=0 -n1e7
```
* Leaving out `--openacc` means targeting CPU
* `-n` specifies problem size
* Use `--verbose` to get increased cogen / compilation output
* `--mpi=N` parallelizes by mpi


## Run a GPU test for a named McStas instrument (use `mxtest` for McXtrace)
```bash 
mctest --testdir $PWD --openacc -n1e7 --instr=PSI_DMC
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
