#!/bin/bash
#
# This is the main build script for the SMACCM ODROID red team drop.
# Running this script should produce an image for the odroid and an image
# for the pixhawk.
#
# This script should work on Ubuntu 12.04 amd64 server edition with
# at least 50gb hard-drive space
#
###########################################################################

set -e

if [[ $TRAVIS != "true" ]]
then
    (exec sudo "./travis.sh")
fi

(exec "./system-setup.sh")
(exec "./code-setup.sh")
(exec "./code-build.sh")

if [[ ! -e ../pixhawk-image.px4 ]]
then
    echo "Failed to build Pixhawk image"
    exit 1
fi

if [[ ! -e ../tk1-image ]]
then
    echo "Failed to build TK1 image"
    exit 1
fi
