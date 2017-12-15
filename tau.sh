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
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc0::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc1::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc4::UNC_M_CAS_COUNT:WR:cpu=0,\
PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:RD:cpu=0,\
PAPI_NATIVE:bdx_unc_imc5::UNC_M_CAS_COUNT:WR:cpu=0

# change the fortran parser
#tau project edit stream --force-tau-options="-optPdtF90Parser=gfparse -optVerbose"
