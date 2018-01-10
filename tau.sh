#!/bin/bash

# Run this as
# % . ./tau.sh
# the first time to export the papi path.

# Run app as
# % tau numactl -C 0 -- ./stream_c.exe

rm -rf ./.tau

# Configure your project...
APPNAME=stream

# papi built with git checkout of libpfm4
PAPI_ROOT=${HOME}/devel/packages/spack/opt/spack/linux-rhel7-x86_64/gcc-6.1.0/papi-master-ashjfzmpqkbxa6hudklfxji7oybhufb6
export PATH=${PAPI_ROOT}/bin:${PATH}

# initialize tau commander project
tau init --application-name $APPNAME --target-name centennial --mpi F --papi=${PAPI_ROOT} --tau nightly
#--openmp

tau measurement copy profile uncore_imc
tau select uncore_imc
tau measurement delete profile

# debugging
#tau measurement edit uncore_imc --keep-inst-files

tau measurement edit uncore_imc --source-inst manual --compiler-inst never \
--metrics \
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:RD:cpu=1,\
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:WR:cpu=1,\
PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:RD:cpu=1,\
PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:WR:cpu=1,\
PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:RD:cpu=1,\
PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:WR:cpu=1,\
PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:RD:cpu=1,\
PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:WR:cpu=1

# run complains about incompatible papi metrics, but generates results.

# use this in paraprof derived metric for bandwidth
#64*("PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:RD:cpu=0"+"PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:WR:cpu=0"+"PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:RD:cpu=0"+"PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:WR:cpu=0"+"PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:RD:cpu=0"+"PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:WR:cpu=0"+"PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:RD:cpu=0"+"PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:WR:cpu=0")/"TIME"

# NB: Using that formula accounts for the magical million that paraprof
# silently puts into the denominator. They are working on a fix for that, and
# when it is fixed one will need to put their own 1e6.

# Set up measurements of stalls to use formulas from Molka, et al.
tau measurement copy uncore_imc mem_bnd_stall_cycs
tau select mem_bnd_stall_cycs
tau measurement edit mem_bnd_stall_cycs \
--metrics \
PAPI_NATIVE:CPU_CLK_UNHALTED,\
PAPI_NATIVE:CYCLE_ACTIVITY:CYCLES_NO_EXECUTE,\
PAPI_NATIVE:RESOURCE_STALLS:SB,\
PAPI_NATIVE:CYCLE_ACTIVITY:STALLS_L1D_PENDING

tau measurement copy uncore_imc bw_lat_stall_cycs
tau select bw_lat_stall_cycs
tau measurement edit bw_lat_stall_cycs \
--metrics \
PAPI_NATIVE:RESOURCE_STALLS:SB,\
PAPI_NATIVE:CYCLE_ACTIVITY:STALLS_L1D_PENDING,\
PAPI_NATIVE:L1D_PEND_MISS:FB_FULL,\
PAPI_NATIVE:OFFCORE_REQUESTS_BUFFER:SQ_FULL

# From Molka, et al.
# Active cycles: 
#         => CPU_CLK_UNHALTED
#   Productive cycles:
#         => CPU_CLK_UNHALTED - CYCLE_ACTIVITY:CYCLES_NO_EXECUTE
#   Stall cycles:
#         => CYCLE_ACTIVITY:CYCLES_NO_EXECUTE
#     Memory bound stall cycles:
#         => max(RESOURCE_STALLS:SB, CYCLE_ACTIVITY:STALLS_L1D_PENDING)
#       Bandwidth bound stall cycles:
#         => max(RESOURCE_STALLS:SB, L1D_PEND_MISS:FB_FULL
#                + OFFCORE_REQUESTS_BUFFER:SQ_FULL)
#       Latency bound stall cycles:
#         => Memory bound cycles - Bandwidth bound cycles
#     Other stall reason cycles:
#         => Stall cycles - Memory bound stall cycles
# 
# In stream:
# CPU_CLK_UNHALTED: 3.2e10
# CYCLE_ACTIVITY:CYCLES_NO_EXECUTE: 2.0e10
# RESOURCE_STALLS:SB: 3e6
# CYCLE_ACTIVITY:STALLS_L1D_PENDING: 2.0e10
# 
# 61% cycles are stalled (CYCLE_ACTIVITY:CYCLES_NO_EXECUTE/CPU_CLK_UNHALTED)
# and they are all STALLS_L1D_PENDING. So 60% of the time the code is memory
# bound.
# 
# 
# RESOURCE_STALLS:SB: 3e6
# L1D_PEND_MISS:FB_FULL: 1.9e10
# OFFCORE_REQUESTS_BUFFER:SQ_FULL: 2.1e10
# 
# Since counters add up to (>) STALLS_L1D_PENDING from the other trial,
# this indicates that stream is always bandwidth bound.

###############################################################################

# Using OMP_NUM_THREADS=40

# export KMP_AFFINITY=scatter
# OMP_NUM_THREADS=40 tau ./stream_c.exe
# benchmark triad: 131246.3 MB/s
# tau counts (with cpu=0 and cpu=1): 132004 MB/s

# remove :cpu=0 from stall cycle measurements.
# OMP_NUM_THREADS=40 tau ./stream_c.exe

# CPU_CLK_UNHALTED: 3.99e9
# CYCLE_ACTIVITY:CYCLES_NO_EXECUTE: 3.63e9
# RESOURCE_STALLS:SB: 4.11e6
# CYCLE_ACTIVITY:STALLS_L1D_PENDING: 3.55e9
# 
# 91% cycles stalled (CYCLE_ACTIVITY:CYCLES_NO_EXECUTE/CPU_CLK_UNHALTED)
# 89% cycles stalled on L1D_PENDING, i.e., 89% cycles memory bound stalls
# 
# RESOURCE_STALLS:SB: 3.89e6
# L1D_PEND_MISS:FB_FULL: 8.11e8
# OFFCORE_REQUESTS_BUFFER:SQ_FULL: 2.37e9
# L1D_PEND_MISS:FB_FULL + OFFCORE_REQUESTS_BUFFER:SQ_FULL: 3.18e9
# CYCLE_ACTIVITY:STALLS_L1D_PENDING: 3.55e9

# 3.18e9 / 3.55e9 = 90% of cycles stalled on memory are bandwidth bound

# 
# -------------------------------------------------------------
# Function    Best Rate MB/s  Avg time     Min time     Max time
# Copy:          117138.9     0.013691     0.013659     0.013934
# Scale:         117786.5     0.013618     0.013584     0.013871
# Add:           131868.7     0.018245     0.018200     0.018796
# Triad:         131601.5     0.018273     0.018237     0.018887
# -------------------------------------------------------------
