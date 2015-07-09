#!/bin/bash

# disassemble.sh
#
# Creates DSL files from raw Linux extract
#
# Part of DSDT paching process for Haswell Gigabyte BRIX
#
# Created by RehabMan
#

#set -x

rm -Rf ./tmp && mkdir ./tmp

if [ "`echo native_patchmatic/*`" = "native_patchmatic/readme.txt" ] && [ "`echo native_linux/*`" = "native_linux/readme.txt" ]; then
    cd native_patchmatic
    patchmatic -extract
    cd ..
fi

if [ "`echo native_patchmatic/*`" != "native_patchmatic/readme.txt" ]; then
# in the case of patchmatic extract, some of the files are generated by Clover
    cp ./native_patchmatic/DSDT.aml ./native_patchmatic/SSDT*.aml ./tmp
    cd ./tmp
    iasl -d -dl *
    list=`echo *.dsl`
    mkdir ./non-clover
    cp ${list//.dsl/.aml} ./non-clover
    rm *.aml *.dsl
    mv ./non-clover/* .
    rmdir ./non-clover
    cd ..
else
# all files can be used but iasl chokes on readonly input files...
    cp ./native_linux/DSDT ./native_linux/SSDT* ./native_linux/dynamic/SSDT* ./tmp
    chmod +w ./tmp/*
fi

cd ./tmp
rm ../unpatched/*.dsl
iasl -da -dl -fe ../refs.txt *
mv *.dsl ../unpatched

cd ..
rm -R ./tmp
