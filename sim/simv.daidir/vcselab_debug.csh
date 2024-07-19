#!/bin/csh -f

cd /Business/EDA_wx_company/xingchangwen/RISC-V/7_19_cheat_version/RISCV_project/RISCV_verification_cheat_version/sim

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/Business/EDA_wx_company/public/tools/vcs_R-2020.12-SP2/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

