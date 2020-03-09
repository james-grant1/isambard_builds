# Swap to Gnu programming environment
module swap PrgEnv-{cray,gnu}

mkdir .local

export BUILD_ROOT=$PWD
export LIBRARY_ROOT=$PWD/.local

mkdir .local/gmp

# Build gmp
wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
tar -xvf gmp-6.1.2.tar.bz2

cd gmp-6.1.2

./configure --prefix=$LIBRARY_ROOT/gmp --enable-cxx CC=cc CXX=CC LDFLAGS=-dynamic
make
make check
make install

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_ROOT/gmp

cd ..

# Build mpfr

mkdir $LIBRARY_ROOT/mpfr

wget https://www.mpfr.org/mpfr-current/mpfr-4.0.2.tar.gz
tar -zxvf mpfr-4.0.2.tar.gz

cd mpfr-4.0.2/

wget https://www.mpfr.org/mpfr-current/allpatches
patch -N -Z -p1 < allpatches


./configure --prefix=$LIBRARY_ROOT/mpfr CC=cc CXX=CC LDFLAGS=-dynamic
make
make check
make install

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_ROOT/mpfr

cd ..

# Install dev version of symengine

mkdir $LIBRARY_ROOT/symengine

git clone https://github.com/symengine/symengine.git
cd symengine/

export CC=cc
export CXX=CC
export FC=ftn
export CXXFLAGS=-dynamic
export CFLAGS=-dynamic

export XTPE_LINK_TYPE=dynamic
export CRAYPE_LINK_TYPE=dynamic

mkdir build && cd build/
cmake ../ -DCMAKE_INSTALL_PREFIX:PATH=$LIBRARY_ROOT/symengine -DWITH_MPFR:BOOL=ON -DMPFR_INCLUDE_DIR=$LIBRARY_ROOT/mpfr/include/ -DMPFR_LIBRARY=$LIBRARY_ROOT/mpfr/lib/libmpfr.so -DGMP_INCLUDE_DIR=$LIBRARY_ROOT/gmp/include/ -DGMP_LIBRARY=$LIBRARY_ROOT/gmp/lib/libgmp.so -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment #-DXTPE_LINK_TYPE=dynamic -DCRAYPE_LINK_TYPE=dynamic

make -j 16
ctest
make install

cd ../..

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_ROOT/symengine

# Install Symengine.py
module load cray-python
pip install cython --user

git clone https://github.com/symengine/symengine.py.git

cd symengine.py

export PATH=$LIBRARY_ROOT/symengine/:$PATH
export CMAKE_PREFIX_PATH=$LIBRARY_ROOT/symengine/:$CMAKE_PREFIX_PATH

python setup.py install --symengine-dir=$LIBRARY_ROOT/symengine/ --user
