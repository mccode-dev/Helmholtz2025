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
In this output, step 1. from above is seen here:
```
DEBUG: CMD: /where/youinstalled/mcstas/bin/mcstas -t -o ./mini.c mini.instr

-----------------------------------------------------------

Generating single GPU kernel or single CPU section layout: 

-----------------------------------------------------------

Generating GPU/CPU -DFUNNEL layout:

-----------------------------------------------------------
CFLAGS=
DEBUG: CMD: /where/youinstalled/mcstas/bin/mcstas finished
```
Step 2 is seen here:
```
DEBUG: CMD: /where/youinstalled/mcstas/bin/aarch64-conda-linux-gnu-cc -o ./mini.out ./mini.c -Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--allow-shlib-undefined -Wl,-rpath,/where/youinstalled/mcstas/lib -Wl,-rpath-link,/where/youinstalled/mcstas/lib -L/where/youinstalled/mcstas/lib -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O3 -pipe -isystem /where/youinstalled/mcstas/include -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O3 -pipe -isystem /where/youinstalled/mcstas/include -O2 -g -DNDEBUG -I/p/project1/training2508/McStasMcXtrace/willendrup1/include -Wl,-rpath,/where/youinstalled/mcstas/lib -L/where/youinstalled/mcstas/lib -fno-PIC -fPIE -flto -O3 -mtune=native -march=native -fno-math-errno -ftree-vectorize -g -DNDEBUG -D_POSIX_SOURCE -std=c99 -lm
```
Step 3 is seen here:
DEBUG: CMD: ./mini.out --trace=0 --ncount=10000000.0 --dir=mini_20250326_153956 --format=McCode --bufsiz=10000000 dummy=0
*** TRACE end *** 
Detector: detector_I=345.985 detector_ERR=0.219791 detector_N=2.47797e+06 "PSD.dat"
```

The run-tools have the following main switches:
```
mcrun --help
Usage: mcrun.py [-cpnN] Instr [-sndftgahi] params={val|min,max|min,guess,max}...

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit

  mcrun options:
    -c, --force-compile
                        force rebuilding of instrument
    --cogen=cogen       Choice of code-generator (implies -c)
    -I I                Append to McCode search path (implies -c)
    --D1=D1             Set extra -D args (implies -c)
    --D2=D2             Set extra -D args (implies -c)
    --D3=D3             Set extra -D args (implies -c)
    -p FILE, --param=FILE
                        Read parameters from file FILE
    -N NP, --numpoints=NP
                        Set number of scan points
    -L, --list          Use a fixed list of points for linear scanning
    -M, --multi         Run a multi-dimensional scan
    --autoplot          Open plotter on generated dataset
    --invcanvas         Forward request for inverted canvas to plotter
    --autoplotter=AUTOPLOTTER
                        Specify the plotter used with --autoplot
    --embed             Store copy of instrument file in output directory
    --mpi=NB_CPU        Spread simulation over NB_CPU machines using MPI
    --openacc           parallelize using openacc
    --funnel            funneling simulation flow, e.g. for mixed CPU/GPU
    --machines=machines
                        Defines path of MPI machinefile to use in parallel
                        mode
    --optimise-file=FILE
                        Store scan results in FILE (defaults to: "mccode.dat")
    --no-cflags         Disable optimising compiler flags for faster
                        compilation
    --no-main           Do not generate a main(), e.g. for use with
                        mcstas2vitess.pl. Implies -c
    --verbose           Enable verbose output
    --write-user-config
                        Generate a user config file
    --edit-user-config  Generate and edit user config file in EDITOR
    --override-config=PATH
                        Load config file from specific dir
    --optimize          Optimize instrument variable parameters to maximize
                        monitors
    --optimize-maxiter=optimize_maxiter
                        Maximum number of optimization iterations to perform.
                        Default=1000
    --optimize-tol=optimize_tol
                        Tolerance for optimization termination. When optimize-
                        tol is specified, the selected optimization algorithm
                        sets some relevant solver-specific tolerance(s) equal
                        to optimize-tol
    --optimize-method=optimize_method
                        Optimization solver in ['powell', 'nelder-mead', 'cg',
                        'bfgs', 'newton-cg', 'l-bfgs-b', 'tnc', 'cobyla',
                        'slsqp', 'trust-constr', 'dogleg', 'trust-ncg',
                        'trust-exact', 'trust-krylov'] (default: powell) You
                        can use your custom method method(fun, x0, args,
                        **kwargs, **options). Please refer to scipy
                        documentation for proper use of it: https://docs.scipy
                        .org/doc/scipy/reference/generated/scipy.optimize.mini
                        mize.html?highlight=minimize
    --optimize-eval=optimize_eval
                        Optimization expression to evaluate for each detector
                        "d" structure. You may combine: "d.intensity" The
                        detector intensity; "d.error"     The detector
                        intensity uncertainty; "d.values"    An array with
                        [intensity, error, counts]; "d.X0 d.Y0"   Center of
                        signal (1st moment); "d.dX d.dY"   Width  of signal
                        (2nd moment). Default is "d.intensity". Examples are:
                        "d.intensity/d.dX" and "d.intensity/d.dX/d.dY"
    --optimize-minimize
                        Choose to minimize the monitors instead of maximize
    --optimize-monitor=optimize_monitor
                        Name of a single monitor to optimize (default is to
                        use all)
    --showcfg=ITEM      Print selected cfg item and exit (paths are resolved
                        and absolute). Allowed values are "bindir", "libdir",
                        "resourcedir", and "tooldir".

  Instrument options:
    -s SEED, --seed=SEED
                        Set random seed (must be: SEED != 0)
    -n COUNT, --ncount=COUNT
                        Set number of neutron to simulate
    -t trace, --trace=trace
                        Enable trace of neutron through instrument
    -g, --gravitation, --gravity
                        Enable gravitation for all trajectories
    -d DIR, --dir=DIR   Put all data files in directory DIR
    --format=FORMAT     Output data files using format FORMAT, usually McCode
                        or NeXus (format list obtained from <instr>.out -h)
    --IDF               Flag to attempt inclusion of XML-based IDF when
                        --format=NeXus (format list obtained from <instr>.out
                        -h)
    --bufsiz=BUFSIZ     Monitor_nD list/buffer-size (defaults to 10000000)
    --vecsize=VECSIZE   vector length in OpenACC parallel scenarios
    --numgangs=NUMGANGS
                        number of 'gangs' in OpenACC parallel scenarios
    --gpu_innerloop=INNERLOOP
                        Maximum particles in an OpenACC kernel run. (If
                        INNERLOOP is smaller than ncount we repeat)
    --no-output-files   Do not write any data files
    -i, --info          Detailed instrument information
    --list-parameters   Print the instrument parameters to standard out
    --meta-list         Print all metadata defining component names
    --meta-defined=META_DEFINED
                        Print metadata names for component, or indicate if
                        component:name exists
    --meta-type=META_TYPE
                        Print metadata type for component:name
    --meta-data=META_DATA
                        Print metadata for component:name
```

_______________________________-


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
