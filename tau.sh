#!/bin/bash
rm -rf .tau
tau init --openmp --select-file $HOME/devel/miniapp1/select.tau --profile merged
tau measurement edit profile --callpath 0 --openmp opari --throttle F --profile merged
#tau measurement copy profile cycles --metrics PAPI_TOT_CYC PAPI_NATIVE:UNHALTED_CORE_CYCLES
tau measurement copy profile fp_ops --metrics PAPI_NATIVE:UOPS_RETIRED:SCALAR_SIMD PAPI_NATIVE:UOPS_RETIRED:PACKED_SIMD
tau measurement copy profile bandwidth --metrics PAPI_L2_LDM PAPI_SR_INS

#tau measurement copy profile bw1 --metrics PAPI_L2_TCM PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES
#tau measurement copy profile bw2 --metrics PAPI_NATIVE:MEM_UOPS_RETIRED:L2_MISS_LOADS PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES

# DMND_DATA_RD: Counts the number of demand and DCU prefetch data reads of
# full and partial cachelines as well as demand data page table entry
# cacheline reads. Does not count L2 data read prefetches or instruction
# fetches.
# tau measurement copy profile bw3 --metrics PAPI_NATIVE:OFFCORE_RESPONSE_0:DMND_DATA_RD PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES

# ANY_PF_L2: counts any prefetch requests
tau measurement copy profile bw3 --metrics PAPI_NATIVE:OFFCORE_RESPONSE_0:DMND_DATA_RD:ANY_PF_L2 PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES


#https://software.intel.com/en-us/forums/software-tuning-performance-optimization-platform-monitoring/topic/508416
#OFFCORE_RESPONSE.PF_L2_DATA_RD.LLC_MISS.LOCAL_DRAM_N
