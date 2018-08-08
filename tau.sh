#!/bin/bash

rm -rf .tau

tau init --mpi F --tau nightly

tau meas create stalls_1 --profile --mpi F --metrics PAPI_NATIVE:CPU_CLK_UNHALTED PAPI_NATIVE:CYCLE_ACTIVITY:CYCLES_NO_EXECUTE PAPI_NATIVE:RESOURCE_STALLS:SB PAPI_NATIVE:CYCLE_ACTIVITY:STALLS_L1D_PENDING --sample F --source-inst automatic --select-file `pwd`/select.tau
tau select stalls_1

tau meas copy stalls_1 stalls_2
tau meas edit stalls_2 --metrics PAPI_NATIVE:CYCLE_ACTIVITY:CYCLES_NO_EXECUTE PAPI_NATIVE:RESOURCE_STALLS:SB PAPI_NATIVE:L1D_PEND_MISS:FB_FULL PAPI_NATIVE:OFFCORE_REQUESTS_BUFFER:SQ_FULL
tau select stalls_2
