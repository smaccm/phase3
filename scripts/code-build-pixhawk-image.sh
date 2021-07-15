#!/bin/bash

cd ..
BASE_DIR=$PWD
set -e

echo "************************************************************"
echo "Build smaccmpilot"
echo "************************************************************"

cd smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-flight

make flight_echronos
cd platform-fmu24/standalone_flight_echronos
if [[ ! -e image.px4 ]]
then
    echo "Failed to build Pixhawk image"
    exit 1
fi
mv image.px4 $BASE_DIR/pixhawk-image.px4
cd ../..

make smaccmpilot-odroid-mini
cp -r smaccmpilot-mini/* $BASE_DIR/camkes/apps/smaccmpilot-tk1/components
cd $BASE_DIR

echo "************************************************************"
echo "Pixhawk image: $BASE_DIR/pixhawk-image.px4"
echo "************************************************************"
