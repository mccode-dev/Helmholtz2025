#!/usr/bin/env bash
# First, check if $1 is a valid instrument file
NUMMPI=72
INSTR=$1
PARMS=${*:2}
IDIR=`dirname $INSTR`
DIR=`basename -s.instr $INSTR`
INSTR=`echo ${IDIR}/${DIR}.instr`

echo $MCSTAS/examples/$INSTR

if [ -f $MCSTAS/examples/$INSTR ];
then
    DIR=`basename -s.instr $INSTR`
    
    echo Found $INSTR in $MCSTAS, copying to $DIR
    mkdir -p $DIR
    
    cp $MCSTAS/examples/$INSTR $DIR
    cd $DIR
      
    EXAMPLE=`grep %Example $MCSTAS/examples/$INSTR | cut -f2 -d: | sed s/Detector//g`
    echo Instrument example lines are $EXAMPLE
    echo
    echo Will be tested with parameters $PARMS
    
    if [ -d one_cpu ];
    then
	rm -rf one_cpu
    fi
    mkdir one_cpu
    cd one_cpu && ln -s ../${DIR}.instr .
    (time mcrun -c ${DIR}.instr -n0 ) &> compile.log
    echo one_cpu compile done
    cd - 
    
    if [ -d mpi_x_${NUMMPI} ];
    then
	rm -rf mpi_x_${NUMMPI}
    fi
    mkdir mpi_x_${NUMMPI}
    cd mpi_x_${NUMMPI} && ln -s ../${DIR}.instr .
    (time mcrun --mpi=1 -c ${DIR}.instr -n0 ) &> compile.log
    echo mpi compile done
    cd -

    cd one_cpu
    for ncount in `echo 1e6 1e7 1e8 1e9`
    do
	(time -p mcrun ${DIR}.instr -n $ncount $PARMS -d $ncount) &>> results.log
	echo $ncount done on one_cpu
	TIME=`tail -3 results.log | grep real | sed s/real//g `
	echo $ncount $TIME >> results.dat
    done
    cd -
    
    cd mpi_x_${NUMMPI}
    for ncount in `echo 1e6 1e7 1e8 1e9 1e10 1e11`
    do
	(time -p mcrun --mpi=$NUMMPI ${DIR}.instr -n $ncount $PARMS -d $ncount) &>> results.log
	echo $ncount done with mpi	
	TIME=`tail -3 results.log | grep real | sed s/real//g `
	echo $ncount $TIME >> results.dat
    done
    cd -
    
else
    echo Instrument $INSTR \(\$1\) was not found!
fi
