#!/bin/bash
rm -rf .tau
tau init --openmp --select-file $HOME/devel/miniapp1/select.tau --profile merged
tau measurement edit sample --callpath 0 --profile merged
tau measurement edit profile --callpath 0 --openmp opari --throttle F --profile merged
tau measurement copy profile cache --metrics PAPI_L2_TCA PAPI_L2_TCH PAPI_L2_TCM
tau measurement copy profile cycles --metrics PAPI_TOT_CYC PAPI_TOT_INS
tau measurement copy profile instructions --metrics PAPI_LD_INS PAPI_LST_INS PAPI_SR_INS PAPI_TOT_INS
tau measurement copy profile mem_uops_retired --metrics PAPI_NATIVE:MEM_UOPS_RETIRED:L2_MISS_LOADS PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES
tau measurement copy profile fp_ops --metrics PAPI_NATIVE:UOPS_RETIRED:SCALAR_SIMD PAPI_NATIVE:UOPS_RETIRED:PACKED_SIMD
