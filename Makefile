# for fortran need to
# % ulimit -s unlimited
# DDR4 & MCDRAM
# % OMP_NUM_THREADS=68 KMP_AFFINITY=scatter numactl -m 0 ./stream_c/f.exe
# % OMP_NUM_THREADS=68 KMP_AFFINITY=scatter numactl -m 1 ./stream_c/f.exe

CC = icc
#CC := tau $(CC)
# https://software.intel.com/en-us/articles/optimizing-memory-bandwidth-in-knights-landing-on-stream-triad
CFLAGS = -mcmodel medium -shared-intel -g -O3 -xMIC-AVX512 -DSTREAM_ARRAY_SIZE=134217728 -DOFFSET=0 -DNTIMES=10 -qopenmp -qopt-streaming-stores always

#PAPI=/home/users/wohlbier/devel/packages/spack/opt/spack/linux-centos7-x86_64/gcc-6.1.0/papi-5.5.1-x43c4hobnux5eemdjelyw5m3czgigfzs
#CFLAGS += -D__PAPI__ -I$(PAPI)/include
#LDFLAGS += -L$(PAPI)/lib -lpapi

FF = ifort
#FF := tau $(FF)
FFLAGS = -mcmodel medium -shared-intel -g -O3 -xMIC-AVX512 -qopenmp -qopt-streaming-stores always -fpp
#FFLAGS += -DTAU_MANUAL_PROFILE

all: stream_f.exe stream_c.exe

stream_f.exe: stream.f90 mysecond.o
	$(CC) $(CFLAGS) -c mysecond.c $(LDFLAGS)
	$(FF) $(FFLAGS) -c stream.f90
	$(FF) $(FFLAGS) stream.o mysecond.o -o stream_f.exe

stream_c.exe: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_c.exe $(LDFLAGS)

clean:
	rm -f stream_f.exe stream_c.exe *.o

# an example of a more complex build line for the Intel icc compiler
stream.icc: stream.c
	icc -O3 -xCORE-AVX2 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20 stream.c -o stream.omp.AVX2.80M.20x.icc
