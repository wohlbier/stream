#!/bin/bash
tau init --openmp --compilers Intel
tau measurement edit profile --callpath 0 --profile merged --throttle F
tau measurement copy profile mem_uops_retired --metrics PAPI_NATIVE:MEM_UOPS_RETIRED:L2_MISS_LOADS PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES
