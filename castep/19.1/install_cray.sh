# CASTEP 19.1 build script for Isambard
# James Grant, University of Bath, rjg20@bath.ac.uk

# Run from directory: castep<-version>

# Load fftw module
module load cray-fftw

# Create backup of Makefile
cp Makefile Makefile.orig

# Modify Makefile as per 
# https://github.com/hpc-uk/build-instructions/blob/master/CASTEP/Isambard_18.1.0_cce8_mpich3.md
sed -i "0,/^COMMS_ARCH\s\{0,\}:=.*/{s//COMMS_ARCH := mpi/}" Makefile
sed -i "0,/^FFT\s\{0,\}:=.*/{s//FFT := fftw3/}" Makefile
sed -i "0,/^BUILD\s\{0,\}:=.*/{s//BUILD := fast/}" Makefile
sed -i "0,/^MATHLIBS\s\{0,\}:=.*/{s//MATHLIBS := scilib/}" Makefile
sed -i "0,/^DL_MG\s\{0,\}:=.*/{s//DL_MG := none/}" Makefile


# Create *platform* file for xc50 arm
cp obj/platforms/linux_x86_64_cray-XT.mk obj/platforms/linux_arm64_cray-XC.mk

# Build CASTEP
unset CPU
export CASTEP_ARCH=linux_arm64_cray-XC
make -j 8 clean
echo -n | make -j 8
mkdir install
export INSTALL_DIR=$PWD/install 
make -j 8 install
