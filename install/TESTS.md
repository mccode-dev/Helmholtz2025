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
