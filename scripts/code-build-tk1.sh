#!/bin/bash

cd ..
BASE_DIR=$PWD
set -e

echo "************************************************************"
echo "Build kernel image via camkes"
echo "************************************************************"

cd camkes
make ${DEFCONFIG:-smaccmpilot-tk1_defconfig}
make

cd images
if [[ ! -e capdl-loader-experimental-image-arm-tk1 ]]
then
    echo "Failed to build TK1 image"
    exit 1
fi
mv capdl-loader-experimental-image-arm-tk1 $BASE_DIR/tk1-image

echo "************************************************************"
echo "TK1 image: $BASE_DIR/tk1-image"
echo "************************************************************"
