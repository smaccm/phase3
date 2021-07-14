#!/bin/bash

# Here we need to do everything that Travis does based on .travis.yml

if [[ ! -e main.sh ]]
then
    echo "Must be run in phase2/scripts directory"
    exit 1
fi

if [[ $(id -u) -ne 0 ]]
then
    echo "Must be run as root"
    exit 1
fi

cd ..
set -e


echo "************************************************************"
echo "Configure apt"
echo "************************************************************"

# Work around Ubuntu APT bug
rm -rf /var/lib/apt/lists/*

sudo apt-get update
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:hvr/ghc          # ghc, cabal, happy, alex
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test # gcc-4.8
sudo apt-get update


echo "************************************************************"
echo "Install GHC, Cabal, Alex, Happy"
echo "************************************************************"

sudo apt-get install -y ghc cabal-install alex happy

echo "************************************************************"
echo "Install Java"
echo "************************************************************"

sudo apt install -y default-jre


echo "************************************************************"
echo "Install other apt software"
echo "************************************************************"

sudo apt-get -y install \
    lib32ncurses5-dev \
    libev-dev \
    gcc \
    git \
    libgmp3-dev \
    zlib1g-dev \
    make \
    libtinfo-dev \
    libncurses5-dev \
    coreutils \
    gcc-arm-linux-gnueabi \
    python3-pip \
    libxml2-utils \
    python2.7-dev \
    cmake \
    ninja-build \
    libsqlite3-dev \
    libcunit1-dev \
    clang \
    expect \
    wget

sudo apt-get -y install u-boot-tools

echo "************************************************************"
echo "Install stack"
echo "************************************************************"
mkdir -p $PWD/.local/bin
curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C $PWD/.local/bin '*/stack'

echo "************************************************************"
echo "Install gcc-arm-embedded"
echo "************************************************************"

mkdir -p gcc-arm-embedded
wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q2-update/+download/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 -O- | tar xjf - -C gcc-arm-embedded

echo "$PWD:$PWD/.local/bin:$(echo $PWD/gcc-arm-embedded/*/bin):/opt/ghc/7.8.4/bin:/opt/cabal/1.22/bin:/opt/alex/3.1.4/bin:/opt/happy/1.19.5/bin:$PATH" >PATH
