# Load fftw module
module load cray-fftw

# Create backup of Makefile
cp Makefile Makefile.orig

# Modify Makefile as per 
# https://github.com/hpc-uk/build-instructions/blob/master/CASTEP/Isambard_18.1.0_cce8_mpich3.md
sed -i "s|^COMMS_ARCH.*|COMMS_ARCH := mpi|g" Makefile
sed -i "s|^FFT.*|FFT := fftw3|g" Makefile
sed -i "s|^BUILD.*|BUILD := fast|g" Makefile
sed -i "s|^MATHLIBS.*|MATHLIBS := scilib|g" Makefile

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
