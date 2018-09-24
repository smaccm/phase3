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
sudo add-apt-repository -y ppa:george-edison55/precise-backports # cmake
sudo apt-get update


echo "************************************************************"
echo "Install GHC, Cabal, Alex, Happy"
echo "************************************************************"
wget https://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2
tar xvjf ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2
cd ghc-7.8.4 && ./configure && sudo make install

sudo apt-get install zlib1g-dev
sudo apt-get install cabal-install
cabal update
# cabal install cabal-install
# ???

#sudo apt-get install libgmp3-dev
#git clone https://github.com/haskell/cabal.git
#cd cabal && git checkout 1.22 && cd cabal-install && ./bootstrap.sh

sudo apt-get install alex # have alex 3.01 instead of alex-3.1.4
sudo apt-get install happy # gets happy-1.18 instead of happy-1.19.5


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
    python2.7-dev \
    cmake \
    ninja-build \
    libsqlite3-dev \
    libcunit1-dev \
    clang-3.4 \
    expect

# check for ubuntu version before installing uboot tools
string=`lsb_release -c`;

if [[ $string == *"precise"* ]]
then
  echo "Ubuntu 12.04";
  sudo apt-get -y --force-yes install uboot-mkimage
else
  echo "Ubuntu > 12.04"
  sudo apt-get -y --force-yes install u-boot-tools
fi

echo "************************************************************"
echo "Install stack"
echo "************************************************************"
mkdir -p $PWD/.local/bin
sudo apt-get install curl
curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C $PWD/.local/bin '*/stack'

echo "************************************************************"
echo "Install gcc-arm-embedded"
echo "************************************************************"

mkdir -p gcc-arm-embedded
wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q2-update/+download/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 -O- | tar xjf - -C gcc-arm-embedded

echo "$PWD:$PWD/.local/bin:$(echo $PWD/gcc-arm-embedded/*/bin):/opt/ghc/7.8.4/bin:/opt/cabal/1.22/bin:/opt/alex/3.1.4/bin:/opt/happy/1.19.5/bin:$PATH" >PATH
