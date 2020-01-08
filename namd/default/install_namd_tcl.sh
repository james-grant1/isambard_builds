#!/bin/bash

module swap PrgEnv-{cray,gnu}
module load cray-fftw

# First unpack tcl
tar -zxvf tcl8.5.9-linux-arm64-threaded.tar.gz
sed 's|$(HOME)|'$PWD'|g' Linux-ARM64.tcl.tmp > Linux-ARM64.tcl


# Unpack
tar xf NAMD_2.13_Source.tar.gz
cd NAMD_2.13_Source

# Build Charm++
tar xf charm-6.8.2.tar
cd charm-6.8.2/
cp -r src/arch/mpi-linux-x86_64 src/arch/mpi-linux-armv8
MPICC=cc MPICXX=CC ./build charm++ mpi-linux-armv8 --with-production -j32
cd ..

cp ../Linux-ARM64* arch


export MPICC=cc
export CC=cc
export MPICXX=CC
export CXX=CC

# Build NAMD
./config Linux-ARM64-g++ --charm-arch mpi-linux-armv8 --with-fftw3 --with-tcl 
make -C Linux-ARM64-g++ -j 32

cd ..

cp -r NAMD_2.13_Source namd-gnu
