#!/bin/bash

#Navigate to namd directory

# Assumes you have previously, successfully install namd with
# ./install_namd_tcl.sh

module swap PrgEnv-{cray,gnu}
module load cray-fftw


tar -zxvf plumed-2.5.1.tgz
cd plumed-2.5.1
../install_plumed_gnu.sh
cd ..

export PLUMED_HOME=$PWD/plumed-2.5.1/plumed-gnu
export PATH=$PATH:$PLUMED_HOME/bin
export LIBRARY_PATH=$LIBRARY_PATH:$PLUMED_HOME/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PLUMED_HOME/lib

# now cd into namd directory, patch with 
# plumed-patch --static -p # choosing namd-2.13 
# and rebuild namdi

cd NAMD_2.13_Source
echo 5 | plumed-patch --static -p 

make -C Linux-ARM64-g++ -j 32

