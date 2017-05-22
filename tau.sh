#!/bin/bash

# Configure your project...
APPNAME=stream

# initialize tau commander project
tau init --application-name $APPNAME --target-name haise --mpi F --openmp

# change the fortran parser
#tau project edit stream --force-tau-options="-optPdtF90Parser=gfparse -optVerbose"

# time
MEASNAME=time
tau measurement create $MEASNAME --metrics="TIME" --compiler-inst fallback --sample F --source-inst automatic
tau select $MEASNAME

# load/store instructions
MEASNAME=load_store_ins
tau measurement create $MEASNAME --metrics="TIME,PAPI_LD_INS,PAPI_SR_INS,PAPI_TOT_INS" --compiler-inst fallback --sample F --source-inst automatic
tau select $MEASNAME

# load/store uops retired
MEASNAME=load_store_uops
tau measurement create $MEASNAME --metrics="TIME,PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_LOADS,PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES" --compiler-inst fallback --sample F --source-inst automatic
tau select $MEASNAME

# L2
MEASNAME=L2
tau measurement create $MEASNAME --metrics="TIME,PAPI_L2_TCM,PAPI_L2_TCA" --compiler-inst fallback --sample F --source-inst automatic
tau select $MEASNAME

# L3
MEASNAME=L3
tau measurement create $MEASNAME --metrics="TIME,PAPI_L3_TCM,PAPI_L3_TCA" --compiler-inst fallback --sample F --source-inst automatic
tau select $MEASNAME

# Arithmetic intensity.
# Cannot measure flops plus loads plus stores. Use load_store_ins to get the
# ratio R of loads to stores, and use that in the formula to derive AI.
# PAPI_DP_OPS/(8 * R * SR_INS)
MEASNAME=AI
tau measurement create $MEASNAME --metrics="TIME,PAPI_DP_OPS,PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES" --compiler-inst fallback --sample F --source-inst automatic
tau select $MEASNAME
