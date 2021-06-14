#!/bin/bash

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase3/scripts directory"
    exit 1
fi

cd ..

if [[ $TRAVIS != "true" ]] && [ -e "PATH" ];
then
    export PATH=`cat PATH`
fi

echo "************************************************************"
echo "Install remaining cabal packages"
echo "************************************************************"
cabal update
cabal install 'MissingH == 1.3.*'
cabal install data-ordlist
cabal install split
cabal install mtl
cabal install base-compat-0.9.0

echo "************************************************************"
echo "Install pip software"
echo "************************************************************"
# Fix pyhton2 vs python3 mismatch
pip install --user jinja2 ply pyelftools tempita six plyplus orderedset

echo "************************************************************"
echo "Get and install repo"
echo "************************************************************"
# We had to fix an older repo version
cd /tmp
git clone -b branch-v1.12.37 https://github.com/podhrmic/git-repo.git
cp git-repo/repo /usr/bin/repo
chmod 755 /usr/bin/repo
cd -
