## mcrun / mxrun switches:
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

## mcrun / mxrun OpenACC / GPU-specific switches:
### Compile time, add `-c` to ensure (re-)compilation:
 ```
    --openacc           parallelize using openacc
    --funnel            funneling simulation flow, e.g. for mixed
 ```
### runtime:
 ```
    CPU/GPU
	--bufsiz=BUFSIZ     Monitor_nD list/buffer-size (defaults to 10000000)
    --vecsize=VECSIZE   vector length in OpenACC parallel scenarios
    --numgangs=NUMGANGS
                        number of 'gangs' in OpenACC parallel scenarios
    --gpu_innerloop=INNERLOOP
                        Maximum particles in an OpenACC kernel run. (If
                        INNERLOOP is smaller than ncount we repeat)
```
