#!/bin/bash
tau init --openmp
tau measurement edit profile --callpath 0 --profile merged --throttle F
tau measurement copy profile instructions --metrics PAPI_LD_INS PAPI_LST_INS PAPI_SR_INS PAPI_TOT_INS
