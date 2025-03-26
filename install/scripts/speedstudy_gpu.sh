#!/usr/bin/env bash
# First, check if $1 is a valid instrument file
NUMMPI=72
INSTR=$1
PARMS=${*:2}
IDIR=`dirname $INSTR`
DIR=`basename -s.instr $INSTR`
INSTR=`echo ${IDIR}/${DIR}.instr`
GPU=`nvidia-smi -L | head -1 |cut -f2- -d: |cut -f1 -d\(| sed s/\ //g`

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
    
    mkdir openacc_${GPU}

    cd openacc_${GPU} && ln -s ../${DIR}.instr .
    (time mcrun --openacc -c ${DIR}.instr -n0 ) &> compile.log
    echo openacc_${GPU} compile done
    cd -

    cd openacc_${GPU}
    for ncount in `echo 1e6 1e7 1e8 1e9 1e10 1e11 1e12`
    do
	(time -p mcrun ${DIR}.instr -n $ncount $PARMS -d $ncount) &>> results.log
	echo $ncount done using openacc
	TIME=`tail -3 results.log | grep real | sed s/real//g `
	echo $ncount $TIME >> results.dat
    done
    cd -

    
    
else
    echo Instrument $INSTR \(\$1\) was not found!
fi
