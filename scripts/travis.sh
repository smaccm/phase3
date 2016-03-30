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
sudo apt-get -y install python-software-properties software-properties-common
sudo add-apt-repository -y ppa:webupd8team/java # java
sudo add-apt-repository -y ppa:hvr/ghc          # ghc, cabal, happy, alex
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test # gcc-4.8
sudo apt-get update


echo "************************************************************"
echo "Install GHC, Cabal, Alex, Happy"
echo "************************************************************"

sudo apt-get install -y ghc-7.8.4 cabal-install-1.22 alex-3.1.4 happy-1.19.5


echo "************************************************************"
echo "Install Java 8"
echo "************************************************************"

# we have to do this to say yes to the java 8 license agreement
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer


echo "************************************************************"
echo "Install other apt software"
echo "************************************************************"

sudo apt-get -y --force-yes install \
    lib32ncurses5 \
    libev-dev \
    gcc-4.8 \
    git \
    libgmp3-dev \
    zlib1g-dev \
    make \
    libtinfo-dev \
    libncurses5-dev \
    realpath \
    gcc-arm-linux-gnueabi \
    python-pip \
    libxml2-utils \
    uboot-mkimage \
    python2.7-dev

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
