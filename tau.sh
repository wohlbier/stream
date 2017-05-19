#!/bin/bash

# Configure your project...
APPNAME=stream

# initialize tau commander project
tau init --application-name $APPNAME --target-name haise --openmp

# change the fortran parser
#tau project edit stream --force-tau-options="-optPdtF90Parser=gfparse -optVerbose"

# time
MEASNAME=time
tau measurement create $MEASNAME --metrics="TIME" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# load/store instructions
MEASNAME=load_store_ins
tau measurement create $MEASNAME --metrics="TIME,PAPI_LD_INS,PAPI_SR_INS,PAPI_TOT_INS" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# floating point instructions
MEASNAME=floating_pt_ins
tau measurement create $MEASNAME --metrics="TIME,PAPI_FP_INS,PAPI_TOT_INS" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# flops
MEASNAME=flops
tau measurement create $MEASNAME --metrics="TIME,PAPI_FP_OPS" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# L2
MEASNAME=L2
tau measurement create $MEASNAME --metrics="TIME,PAPI_L2_TCM,PAPI_L2_TCA" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# L3
MEASNAME=L3
tau measurement create $MEASNAME --metrics="TIME,PAPI_L3_TCM,PAPI_L3_TCA" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# uops
MEASNAME=uops
tau measurement create $MEASNAME --metrics="TIME,PAPI_NATIVE:UOPS_RETIRED:SCALAR_SIMD,PAPI_NATIVE:UOPS_RETIRED:PACKED_SIMD,PAPI_NATIVE:UOPS_RETIRED:ALL" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# cpi
MEASNAME=cpi
tau measurement create $MEASNAME --metrics="TIME,PAPI_TOT_CYC,PAPI_TOT_INS" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME

# stalls
MEASNAME=stalls
tau measurement create $MEASNAME --metrics="TIME,PAPI_TOT_CYC,PAPI_STL_ICY" --compiler-inst fallback --profile merged --sample F --source-inst automatic
tau select $MEASNAME
