# for fortran need to
# % ulimit -s unlimited
# DDR4 & MCDRAM
# % OMP_NUM_THREADS=68 KMP_AFFINITY=scatter numactl -m 0 ./stream_c/f.exe
# % OMP_NUM_THREADS=68 KMP_AFFINITY=scatter numactl -m 1 ./stream_c/f.exe

#CC = gcc
CC = armclang
#CC = icc
#CC = cc
#CC := tau $(CC)
# https://software.intel.com/en-us/forums/software-tuning-performance-optimization-platform-monitoring/topic/593585
# Shown value of 30000000000 (30e9) is too large for my node.
# Dr. Bandwidth says use >= 40000000 (40e6).
CFLAGS=-O3 -DSTREAM_TYPE=double -DSTREAM_ARRAY_SIZE=40000000 -DOFFSET=0 -DNTIMES=100 -DTUNED
CFLAGS += -std=gnu99
#CFLAGS += -D__TAU_MANUAL_INST__
#icc
#CFLAGS += -mcmodel medium
#CFLAGS += -ffreestanding
#CFLAGS += -qopenmp
#CFLAGS += -qopt-report=5
#CFLAGS += -xMIC-AVX512
#CFLAGS += -xAVX
#CFLAGS += -qopt-prefetch-distance=64,8 -qopt-streaming-stores=always
#CFLAGS+=-no-vec
# gcc
CFLAGS += -fopenmp
CFLAGS += -mcmodel=large
#CFLAGS += -march=native
#CFLAGS += -homp
#CFLAGS += -hdisplay_opt

#PAPI=/home/users/wohlbier/devel/packages/spack/opt/spack/linux-rhel7-x86_64/gcc-6.1.0/papi-master-ashjfzmpqkbxa6hudklfxji7oybhufb6
#CFLAGS += -D__PAPI__ -I$(PAPI)/include
#LDFLAGS += -L$(PAPI)/lib -lpapi

#FF = gfortran
FF = armflang
#FF = ifort
#FF = ftn
FFLAGS = -g -O3
#FFLAGS += -fpp
FFLAGS += -cpp
#FFLAGS += -mcmodel medium
#FFLAGS += -qopenmp
FFLAGS += -fopenmp
#FFLAGS += -qopt-report=5
#FFLAGS += -xMIC-AVX512
#FFLAGS+=-qopt-prefetch-distance=64,8
#FFLAGS+=-qopt-streaming-stores=always
#FFLAGS+=-qopt-prefetch=0
#FFLAGS+=-no-vec
#FFLAGS+=-D__PREFETCH__
#FFLAGS+=-D__INCREASE_AI__
#FFLAGS += -eF
#FFLAGS += -homp
#FFLAGS += -hpic

#FF := tau $(FF)
#FFLAGS += -D__TAU_MANUAL_INST__

# Intel ITT Notify API
#FFLAGS+=-D__ITT_NOTIFY__ -I/work1/compiler/vtune_amplifier_xe/include/intel64
#LDFLAGS+=-L/work1/compiler/vtune_amplifier_xe/lib64 -littnotify
#FFLAGS+=-D__ITT_NOTIFY__ -I/work1/compiler-beta/vtune_amplifier_2018/include/intel64
#LDFLAGS+=-L/work1/compiler-beta/vtune_amplifier_2018/lib64 -littnotify

all: stream_f.exe stream_c.exe assembler
#all: stream_f.exe stream_c.exe
#all: stream_f.exe assembler
#all: stream_f.exe

stream_f.exe: stream.f90 mysecond.o
	$(FF) $(FFLAGS) -c stream.f90
	$(FF) $(FFLAGS) stream.o mysecond.o -o stream_f.exe $(LDFLAGS)

%.o : %.c
	$(CC) $(CFLAGS) -c $<

stream_c.exe: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_c.exe $(LDFLAGS)

assembler: stream.f90 stream.c
	$(CC) $(CFLAGS) -S stream.c -o stream_c.s
	$(FF) $(FFLAGS) -S stream.f90

clean:
	-$(RM) -f *~ *.continue.* *.inst.* *.o *.pdb stream_f.exe stream_c.exe
	-$(RM) -f *.optrpt *.s

# an example of a more complex build line for the Intel icc compiler
stream.icc: stream.c
	icc -O3 -xCORE-AVX2 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20 stream.c -o stream.omp.AVX2.80M.20x.icc
