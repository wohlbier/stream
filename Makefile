# for fortran need to
# % ulimit -s unlimited
# DDR4 & MCDRAM
# % OMP_NUM_THREADS=68 KMP_AFFINITY=scatter numactl -m 0 ./stream_c/f.exe
# % OMP_NUM_THREADS=68 KMP_AFFINITY=scatter numactl -m 1 ./stream_c/f.exe

CC = icc
#CC := tau $(CC)
# https://software.intel.com/en-us/articles/optimizing-memory-bandwidth-in-knights-landing-on-stream-triad
CFLAGS = -mcmodel medium -qopenmp -qopt-report=5 -g -O3 -xMIC-AVX512 -ffreestanding -DSTREAM_ARRAY_SIZE=300000000 -DOFFSET=0 -DNTIMES=100
#CFLAGS+= -qopt-prefetch-distance=64,8 -qopt-streaming-stores=always
#CFLAGS+=-no-vec

#PAPI=/home/users/wohlbier/devel/packages/spack/opt/spack/linux-centos7-x86_64/gcc-6.1.0/papi-5.5.1-x43c4hobnux5eemdjelyw5m3czgigfzs
#CFLAGS += -D__PAPI__ -I$(PAPI)/include
#LDFLAGS += -L$(PAPI)/lib -lpapi

FF = ifort
FFLAGS = -fpp -mcmodel medium -qopenmp -qopt-report=5 -g -O3 -xMIC-AVX512 
#FFLAGS+=-qopt-prefetch-distance=64,8
FFLAGS+=-qopt-streaming-stores=always
#FFLAGS+=-qopt-prefetch=0
#FFLAGS+=-no-vec
#FFLAGS+=-D__PREFETCH__

#FF := tau $(FF)
#FFLAGS += -DTAU_MANUAL_PROFILE

# Intel ITT Notify API
#FFLAGS+=-D__ITT_NOTIFY__ -I/work1/compiler/vtune_amplifier_xe/include/intel64
#LDFLAGS+=-L/work1/compiler/vtune_amplifier_xe/lib64 -littnotify
FFLAGS+=-D__ITT_NOTIFY__ -I/work1/compiler-beta/vtune_amplifier_2018/include/intel64
LDFLAGS+=-L/work1/compiler-beta/vtune_amplifier_2018/lib64 -littnotify

all: stream_f.exe stream_c.exe assembler
#all: stream_f.exe assembler

stream_f.exe: stream.f90 mysecond.o
	$(CC) $(CFLAGS) -c mysecond.c $(LDFLAGS)
	$(FF) $(FFLAGS) -c stream.f90
	$(FF) $(FFLAGS) stream.o mysecond.o -o stream_f.exe $(LDFLAGS)

stream_c.exe: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_c.exe $(LDFLAGS)

assembler: stream.f90
	$(FF) $(FFLAGS) -S stream.f90

clean:
	-$(RM) -f *~ *.continue.* *.inst.* *.o *.pdb stream_f.exe stream_c.exe
	-$(RM) -f *.optrpt *.s

# an example of a more complex build line for the Intel icc compiler
stream.icc: stream.c
	icc -O3 -xCORE-AVX2 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20 stream.c -o stream.omp.AVX2.80M.20x.icc
