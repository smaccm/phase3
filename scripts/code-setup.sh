#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

cd ..
BASE_DIR=$PWD
set -e

if [[ $TRAVIS != "true" ]] && [ -e "PATH" ];
then
    export PATH=`cat PATH`
fi

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
cd smaccmpilot-stm32f4/src/smaccm-flight
make
cd $BASE_DIR

echo "************************************************************"
echo "Get camkes code"
echo "************************************************************"

mkdir camkes
cd camkes
repo init -u https://github.com/smaccm/june-drop-odroid-manifest.git -m phase2.xml || true
repo sync || true
repo sync -d || true

cd apps
echo "RAMSES_PATH=$BASE_DIR/phase2/ramses-demo" > RAMSES_PATH.mk

