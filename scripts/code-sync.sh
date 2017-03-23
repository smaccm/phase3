#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase3/scripts directory"
    exit 1
fi

cd ..

echo "************************************************************"
echo "Syncing smaccmbuild"
echo "************************************************************"

cd smaccmpilot-build
git pull
git submodule update
cd ..

echo "************************************************************"
echo "Syncing camkes"
echo "************************************************************"

cd camkes
export GIT_SSL_NO_VERIFY=1
repo sync
