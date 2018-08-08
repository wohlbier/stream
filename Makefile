# for fortran need to
# % ulimit -s unlimited

CC = icc
#CC = gcc
#CC := tau $(CC)

# Dr. Bandwidth says use >= 40000000 (40e6).
CFLAGS = -g -O3 -DSTREAM_TYPE=double -DSTREAM_ARRAY_SIZE=100000000 -DOFFSET=0 -DNTIMES=100 
CFLAGS += -std=gnu99
#icc
CFLAGS += -mcmodel medium
CFLAGS += -ffreestanding
CFLAGS += -qopenmp

# gcc
#CFLAGS += -fopenmp
#CFLAGS += -mcmodel=large

#CFLAGS += -D__TAU_MANUAL_INST__

FF = ifort
#FF = gfortran

FFLAGS = -g -O3
FFLAGS += -fpp
FFLAGS += -mcmodel medium
FFLAGS += -qopenmp

#FFLAGS += -cpp
#FFLAGS += -fopenmp

FF := tau $(FF)
FFLAGS += -D__TAU_MANUAL_INST__

# Intel ITT Notify API
#INTEL_PATH=/usr/local/install/intel-2018-update1/vtune_amplifier
#FFLAGS+=-D__ITT_NOTIFY__ -I$(INTEL_PATH)/include/intel64
#LDFLAGS+=-L$(INTEL_PATH)/lib64 -littnotify


#all: stream_f.exe stream_c.exe assembler
all: stream_f.exe stream_c.exe
#all: stream_f.exe assembler
#all: stream_f.exe

stream_f.exe: stream.f90 mysecond.o
	$(FF) $(FFLAGS) -c stream.f90
	$(FF) $(FFLAGS) stream.o mysecond.o -o stream_f.exe $(LDFLAGS)

%.o : %.c
	$(CC) $(CFLAGS) -c $<

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
