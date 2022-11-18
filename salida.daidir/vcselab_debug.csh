#!/bin/csh -f

cd /home/ESTEBAN_CASTRO/VFCI-Esteban_Castro/Proyecto2/Proyecto2_VFCI (copy)

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/mnt/vol_NFS_rh003/tools/vcs/R-2020.12-SP2/linux64/bin/vcselab $* \
    -o \
    salida \
    -nobanner \

cd -

