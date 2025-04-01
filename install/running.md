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
(You may also use the `-y` input to assume "all simulation parameters default" i.e. `mcrun -c mini.instr --verbose -y -n1e7`)
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
```
DEBUG: CMD: ./mini.out --trace=0 --ncount=10000000.0 --dir=mini_20250326_153956 --format=McCode --bufsiz=10000000 dummy=0
*** TRACE end *** 
Detector: detector_I=345.985 detector_ERR=0.219791 detector_N=2.47797e+06 "PSD.dat"
```

See [this page](mcrun.md) for mcrun/mxrun switches.

# Running on a GPU: add  `--openacc` for compilation with `nvc`
## OS requirement is Linux (x86_64 or arm64)
### Compile and run an instrument:
```bash
mcrun -c mini.instr --openacc dummy=0 -n1e7
INFO: No output directory specified (--dir)
INFO: Using directory: "mini_20250326_165302"
INFO: Regenerating c-file: mini.c

-----------------------------------------------------------

Generating single GPU kernel or single CPU section layout: 

-----------------------------------------------------------

Generating GPU/CPU -DFUNNEL layout:

-----------------------------------------------------------
CFLAGS=
INFO: Recompiling: ./mini.out
"./mini.c", line 4558: warning: variable "num" was declared but never referenced [declared_but_not_referenced]
          int num = 3;
              ^

Remark: individual warnings can be suppressed with "--diag_suppress <warning-name>"

"./mini.c", line 7091: warning: variable "tc2" was set but never used [set_but_not_used]
      Coords tc1, tc2;
                  ^

"./mini.c", line 7088: warning: variable "current_setpos_index" was declared but never referenced [declared_but_not_referenced]
    int current_setpos_index = 1;
        ^

"./mini.c", line 7132: warning: variable "current_setpos_index" was declared but never referenced [declared_but_not_referenced]
    int current_setpos_index = 2;
        ^

"./mini.c", line 7208: warning: variable "current_setpos_index" was declared but never referenced [declared_but_not_referenced]
    int current_setpos_index = 3;
        ^

"./mini.c", line 7273: warning: variable "current_setpos_index" was declared but never referenced [declared_but_not_referenced]
    int current_setpos_index = 4;
        ^

"./mini.c", line 8716: warning: variable "t" was declared but never referenced [declared_but_not_referenced]
    time_t  t;
            ^

"./mini.c", line 8717: warning: variable "ct" was set but never used [set_but_not_used]
    clock_t ct;
            ^

"./mini.c", line 1496: warning: variable "mcstartdate" was set but never used [set_but_not_used]
  static   long mcstartdate            = 0; /* start simulation time */
                ^

"./mini.c", line 2915: warning: function "strcpy_valid" was declared but never referenced [declared_but_not_referenced]
  static char *strcpy_valid(char *valid, char *original)
               ^

mcgenstate:
     88, Generating acc routine seq
         Generating NVIDIA GPU code
particle_getvar:
    102, Generating acc routine seq
         Generating NVIDIA GPU code
particle_getvar_void:
    134, Generating acc routine seq
         Generating NVIDIA GPU code
particle_setvar_void:
    158, Generating acc routine seq
         Generating NVIDIA GPU code
particle_setvar_void_array:
    180, Generating acc routine seq
         Generating NVIDIA GPU code
particle_restore:
    191, Generating acc routine seq
         Generating NVIDIA GPU code
particle_getuservar_byid:
    200, Generating acc routine seq
         Generating NVIDIA GPU code
particle_uservar_init:
    210, Generating acc routine seq
         Generating NVIDIA GPU code
noprintf:
   1543, Generating acc routine seq
         Generating NVIDIA GPU code
str_comp:
   1547, Generating acc routine seq
         Generating NVIDIA GPU code
str_len:
   1556, Generating acc routine seq
         Generating NVIDIA GPU code
mcget_ncount:
   4179, Generating acc routine seq
         Generating NVIDIA GPU code
coords_set:
   4610, Generating acc routine seq
         Generating NVIDIA GPU code
coords_get:
   4621, Generating acc routine seq
         Generating NVIDIA GPU code
coords_add:
   4630, Generating acc routine seq
         Generating NVIDIA GPU code
coords_sub:
   4642, Generating acc routine seq
         Generating NVIDIA GPU code
coords_neg:
   4654, Generating acc routine seq
         Generating NVIDIA GPU code
coords_scale:
   4664, Generating acc routine seq
         Generating NVIDIA GPU code
coords_sp:
   4674, Generating acc routine seq
         Generating NVIDIA GPU code
coords_xp:
   4682, Generating acc routine seq
         Generating NVIDIA GPU code
coords_len:
   4692, Generating acc routine seq
         Generating NVIDIA GPU code
coords_print:
   4714, Generating acc routine seq
         Generating NVIDIA GPU code
coords_norm:
   4721, Generating acc routine seq
         Generating NVIDIA GPU code
rot_set_rotation:
   4767, Generating acc routine seq
         Generating NVIDIA GPU code
rot_test_identity:
   4802, Generating acc routine seq
         Generating NVIDIA GPU code
rot_mul:
   4813, Generating acc routine seq
         Generating NVIDIA GPU code
rot_copy:
   4830, Generating acc routine seq
         Generating NVIDIA GPU code
rot_transpose:
   4841, Generating acc routine seq
         Generating NVIDIA GPU code
rot_apply:
   4857, Generating acc routine seq
         Generating NVIDIA GPU code
vec_prod_func:
   4886, Generating acc routine seq
         Generating NVIDIA GPU code
scalar_prod:
   4897, Generating acc routine seq
         Generating NVIDIA GPU code
norm_func:
   4901, Generating acc routine seq
         Generating NVIDIA GPU code
mccoordschange:
   5078, Generating acc routine seq
         Generating NVIDIA GPU code
mccoordschange_polarisation:
   5109, Generating acc routine seq
         Generating NVIDIA GPU code
normal_vec:
   5126, Generating acc routine seq
         Generating NVIDIA GPU code
solve_2nd_order:
   5225, Generating acc routine seq
         Generating NVIDIA GPU code
_randvec_target_circle:
   5309, Generating acc routine seq
         Generating NVIDIA GPU code
_randvec_target_rect_angular:
   5375, Generating acc routine seq
         Generating NVIDIA GPU code
_randvec_target_rect_real:
   5452, Generating acc routine seq
         Generating NVIDIA GPU code
kiss_srandom:
   5724, Generating acc routine seq
         Generating NVIDIA GPU code
kiss_random:
   5736, Generating acc routine seq
         Generating NVIDIA GPU code
_hash:
   5762, Generating acc routine seq
         Generating NVIDIA GPU code
_randnorm2:
   5803, Generating acc routine seq
         Generating NVIDIA GPU code
_randtriangle:
   5814, Generating acc routine seq
         Generating NVIDIA GPU code
_rand01:
   5819, Generating acc routine seq
         Generating NVIDIA GPU code
_randpm1:
   5827, Generating acc routine seq
         Generating NVIDIA GPU code
_rand0max:
   5835, Generating acc routine seq
         Generating NVIDIA GPU code
_randminmax:
   5842, Generating acc routine seq
         Generating NVIDIA GPU code
mcsetstate:
   6501, Generating acc routine seq
         Generating NVIDIA GPU code
mcgetstate:
   6538, Generating acc routine seq
         Generating NVIDIA GPU code
inside_rectangle:
   6598, Generating acc routine seq
         Generating NVIDIA GPU code
box_intersect:
   6615, Generating acc routine seq
         Generating NVIDIA GPU code
cylinder_intersect:
   6730, Generating acc routine seq
         Generating NVIDIA GPU code
sphere_intersect:
   6785, Generating acc routine seq
         Generating NVIDIA GPU code
init:
   7578, Generating update device(_source_var,_instrument_var,_arm_var,_coll2_var,_detector_var)
class_Source_simple_trace:
   7621, Generating acc routine seq
         Generating NVIDIA GPU code
class_Slit_trace:
   7724, Generating acc routine seq
         Generating NVIDIA GPU code
class_PSD_monitor_trace:
   7768, Generating acc routine seq
         Generating NVIDIA GPU code
raytrace:
   7843, Generating acc routine seq
         Generating NVIDIA GPU code
raytrace_all:
   7966, Generating implicit firstprivate(gpu_innerloop)
         Generating NVIDIA GPU code
       7980, #pragma acc loop gang(numgangs), vector(vecsize) /* blockIdx.x threadIdx.x */
   7966, Local memory used for .inl_particle_7979,particleN,.inl_.inl_mcneutron_0_7994,.inl_.X1781_7996,.inl_.inl_.X1969_15_7995
   7980, Generating implicit firstprivate(seed,_particle)
finally:
   8287, Generating update self(_source_var,_instrument_var,_arm_var,_coll2_var,_detector_var)
mcenabletrace:
   5961, Generating update device(mcdotrace)
INFO: ===
*** TRACE end *** 
Detector: detector_I=345.86 detector_ERR=0.219751 detector_N=2.47708e+06 "PSD.dat"
INFO: Placing instr file copy mini.instr in dataset mini_20250326_165302
INFO: Placing generated c-code copy mini.c in dataset mini_20250326_165302

```

## Run a GPU test for a named McStas instrument (use `mxtest` for McXtrace) - test data in json files
```bash 
mctest --testdir $PWD --openacc -n1e7 --instr=PSI_DMC
```
Will find all instruments in `${MCSTAS}/examples` matching the `--instr` (regex) and execute all `%Example` lines present in the headers of those files, e.g.: 
```
find $MCSTAS -name \*PSI_DMC\*instr -exec grep -H %Example \{\} \;
${MCSTAS}/examples/PSI/PSI_DMC/PSI_DMC.instr:* %Example: lambda=2.5666 Detector: Detector_I=7.5965E+02
${MCSTAS}/examples/PSI/PSI_DMC_simple/PSI_DMC_simple.instr:* %Example: lambda=2.5666 Detector: Detector_I=7.5965E+02
```
The `Detector: name_I=value` must be matched within 10% for an "approved/green test".

## Visualise test numerical output by `mcviewtest` (writes an html table based on the json output)
```bash 
mcviewtest $PWD
```
HTML result table of this type [example](https://new-nightly.mcstas.org/2025-03-26_output.html) 

## Configure for "Multicore" OpenACC:
```bash
mcrun --write-user-config
```
and hack your `.mcstas/3.99.999/mccode_config.json` replacing `-acc=gpu -gpu=mem:managed` by `-acc=multicore`
