#!/bin/bash

# Run this as
# % . ./tau.sh
# the first time to export the papi path.

rm -rf ./.tau

# Configure your project...
APPNAME=stream

# papi built with git checkout of libpfm4
PAPI_ROOT=${HOME}/devel/packages/spack/opt/spack/linux-rhel7-x86_64/gcc-6.1.0/papi-master-ashjfzmpqkbxa6hudklfxji7oybhufb6
export PATH=${PAPI_ROOT}/bin:${PATH}

# initialize tau commander project
tau init --application-name $APPNAME --target-name centennial --mpi F --papi=${PAPI_ROOT}
#--openmp

tau select profile

tau measurement edit profile --source-inst manual --compiler-inst never \
--metrics \
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:RD:cpu=0

#PAPI_NATIVE:OFFCORE_RESPONSE_0:DMND_DATA_RD:DMND_RFO:DMND_IFETCH:PF_DATA_RD:PF_RFO:PF_LLC_DATA_RD:PF_LLC_RFO:L3_MISS:NO_SUPP:SNP_NONE:SNP_NOT_NEEDED:SNP_MISS:SNP_NO_FWD

#PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_LOADS:cpu=0

#,PAPI_NATIVE:MEM_UOPS_RETIRED:ALL_STORES

#PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:RD:cpu=0
#,\
#PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:WR:cpu=0,\
#PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:RD:cpu=0,\
#PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:WR:cpu=0,\
#PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:RD:cpu=0,\
#PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:WR:cpu=0,\
#PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:RD:cpu=0,\
#PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:WR:cpu=0

# change the fortran parser
#tau project edit stream --force-tau-options="-optPdtF90Parser=gfparse -optVerbose"
