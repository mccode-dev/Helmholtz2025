## mcplot / mxplot switches:
```
mcplot --help
loading system configuration
usage: mcplot.py [-h] [-t] [--invcanvas] [simulation ...]

pyqtgraph mcplot frontend, which uses the mcplot graph-based data loader.

positional arguments:
  simulation   file or directory to plot

options:
  -h, --help   show this help message and exit
  -t, --test   mccode data loader test run
  --invcanvas  invert canvas background from black to white

```
Takes an output folder from McStas or McXtrace and plots the monitor
output (1D/2D histograms etc.) requires 'bells/whistles' dependencies,
X11 forwarded or own machine.
