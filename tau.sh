#!/bin/bash
tau init --openmp --select-file $HOME/devel/stream/select.tau --profile merged
tau measurement edit profile --callpath 0 --keep-inst-files --throttle F --profile merged
tau measurement copy profile mem_uops_retired --metrics PAPI_NATIVE:MEM_UOPS_RETIRED:L2_MISS_LOADS PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES
