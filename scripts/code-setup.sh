#!/bin/bash

cd ..
BASE_DIR=$PWD
set -e

# TODO: Find better location for phase3 ramses
echo "************************************************************"
echo "Get phase2 repo for ramses.jar"
echo "************************************************************"

git clone https://github.com/smaccm/phase2
ln -s phase2/ramses-demo ramses-demo


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
git checkout master


echo "************************************************************"
echo "Get camkes code"
echo "************************************************************"

cd $BASE_DIR
mkdir camkes
cd camkes
export GIT_SSL_NO_VERIFY=1
repo init -u https://github.com/smaccm/phase3.git -m phase3.xml -b master
repo sync
repo sync -d
