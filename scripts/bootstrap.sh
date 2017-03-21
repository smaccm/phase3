#!/bin/bash
#
# This is the bootstrapping script for the May 15 SMACCM ODROID red team
# drop. Running this script should produce an image for the odroid and an
# image for the pixhawk.
#
# This script should work on freshly installed Ubuntu 12.04 amd64 server
# edition with at least 50gb hard-drive space. If your system already
# has git and the phase2 repository, then you can just run the 'main.sh'
# script from within the phase2 repository instead.
#
# Will display and save output to output.txt
#
###########################################################################

export BUILD_DIR_NAME=smaccmcopter-ph3-build

# Save all output to output.txt
exec > >(tee output.txt)
exec 2>&1

echo "************************************************************"
echo "Get git"
echo "************************************************************"

# Work around Ubuntu APT bug
sudo rm -rf /var/lib/apt/lists/*

sudo apt-get update
sudo apt-get -y install git curl g++ cmake-data

echo "************************************************************"
echo "Get phase3 repository"
echo "************************************************************"

git clone https://github.com/smaccm/phase3.git $BUILD_DIR_NAME
cd $BUILD_DIR_NAME

echo "************************************************************"
echo "Call subscripts"
echo "************************************************************"

cd scripts
(exec "./main.sh")
