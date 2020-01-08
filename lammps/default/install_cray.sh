# Lammps install script for Isambard
# James Grant, University of Bath, rjg20@bath.ac.uk

# Load fftw module
module load cray-fftw

MAKEFILE="MAKE/Makefile.mpi"
MAKEFILEORIG="MAKE/Makefile.mpi.orig"

# Create backup of Makefile if not already present
if [ ! -f $MAKEFILEORIG ]; then
	cp $MAKEFILE $MAKEFILEORIG
fi

# Return original makefile
cp $MAKEFILEORIG $MAKEFILE

# Modify 

sed -i "s|^CC\s\{0,\}=.*|CC = CC|g" $MAKEFILE
sed -i "s|^CCFLAGS.*|CCFLAGS = -g -O2|g" $MAKEFILE
sed -i "s|^LINK\s\{0,\}=.*|LINK = CC|g" $MAKEFILE
sed -i "s|^LINKFLAGS.*|LINKFLAGS = -g -O2|g" $MAKEFILE
sed -i "s|^FFT_INC.*|FFT_INC= -DFFT_FFTW3|g" $MAKEFILE
sed -i "s|^FFT_LIB.*|FFT_LIB= -lfftw3|g" $MAKEFILE

# Install packages

make yes-kspace yes-manybody yes-molecule \
yes-asphere yes-body yes-class2 \
yes-colloid yes-compress yes-coreshell \
yes-dipole yes-granular yes-mc yes-misc \
yes-mpiio yes-opt yes-peri yes-qeq \
yes-shock yes-snap yes-srd \
yes-user-reaxc yes-misc yes-rigid \
yes-replica

# Build lammps

make -j8 mpi
