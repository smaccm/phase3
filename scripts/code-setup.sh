#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase3/scripts directory"
    exit 1
fi

cd ..
BASE_DIR=$PWD
set -e

if [[ $TRAVIS != "true" ]] && [ -e "PATH" ];
then
    export PATH=`cat PATH`
fi

# TODO: Find better location for phase3 ramses
echo "************************************************************"
echo "Get phase2 repo for ramses.jar"
echo "************************************************************"

git clone https://github.com/smaccm/phase2


echo "************************************************************"
echo "Get smaccmpilot code"
echo "************************************************************"

git clone https://github.com/GaloisInc/smaccmpilot-build.git
cd smaccmpilot-build


echo "************************************************************"
echo "Configure smaccmpilot code"
echo "************************************************************"

git checkout ${SMACCM_BRANCH:=master}
git submodule update --init
cd smaccmpilot-stm32f4
# TODO: Use official Galois version
git remote add agacek https://github.com/agacek/smaccmpilot-stm32f4
git fetch agacek
git checkout agacek/master


echo "************************************************************"
echo "Get camkes code"
echo "************************************************************"

cd $BASE_DIR
mkdir camkes
cd camkes
repo init -u https://github.com/smaccm/phase3.git || true
repo sync || true
repo sync -d || true
