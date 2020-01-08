# Load environment modules for gnu

# module swap PrgEnv-cray PrgEnv-gnu
# module load cray-fftw3

# set environment variables

export CC="cc -static"
export CXX="CC -static"
export FC="ftn -static"
export CFLAGS="-static"
export FFLAGS="-static"
export LIBS=""
export DYNAMIC_LIBS="-lstdc++"
export LDFLAGS="-ldl"
export CPPFLAGS="-D__PLUMED_HAS_DLOPEN"
export LDSO="cc $CFLAGS"
export LD="CC -static"
export LDF90="ftn -static"
export PLUMED_LIBSUFFIX="mpi"

# configure with directory
export PLUMED_DIR=plumed-gnu
mkdir $PLUMED_DIR
export PLUMED_ROOT=$PWD
export PLUMED_HOME=$PLUMED_ROOT/$PLUMED_DIR

# configure plumed
./configure --prefix=$PLUMED_HOME --disable-mpi --enable-shared=no --disable-openmp

# build
source sourceme.sh
make -j4 clean
make -j4
make -j4 install
