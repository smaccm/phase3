# This Docker image contains all dependencies
# needed to build SMACCMPILOT images
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8

# Formerly  ./travis.sh & system-setup.sh
# "************************************************************"
# "Configure apt"
# "************************************************************"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes apt-utils
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:hvr/ghc
RUN apt-get update

# "************************************************************"
# "Install GHC, Cabal, Alex, Happy"
# "************************************************************"
RUN apt-get install -y ghc cabal-install alex happy

# "************************************************************"
# "Install Java"
# "************************************************************"
RUN apt-get install -y default-jre

# "************************************************************"
# "Install other apt software"
# "************************************************************"
RUN apt-get update
RUN apt-get install -y lib32ncurses5-dev
RUN apt-get install -y libev-dev
RUN apt-get install -y gcc
RUN apt-get install -y git
RUN apt-get install -y libgmp3-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y make
RUN apt-get install -y libtinfo-dev
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y coreutils
RUN apt-get install -y gcc-arm-linux-gnueabi
RUN apt-get install -y python3-pip
RUN apt-get install -y libxml2-utils
RUN apt-get install -y python2.7-dev
RUN apt-get install -y cmake
RUN apt-get install -y ninja-build
RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y libcunit1-dev
RUN apt-get install -y clang
RUN apt-get install -y expect
RUN apt-get install -y wget
RUN apt-get install -y vim
RUN apt-get install -y u-boot-tools
RUN apt-get install -y python2
RUN apt-get install -y libssl-dev

# "************************************************************"
# "Install remaining cabal packages"
# "************************************************************"
RUN cabal update
RUN cabal install data-ordlist split mtl base-compat-0.9.0

# "************************************************************"
# "Install gcc-arm-embedded"
# "************************************************************"
WORKDIR /opt
RUN wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q2-update/+download/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2
RUN tar xjf gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2
ENV PATH /opt/gcc-arm-none-eabi-4_9-2015q2/bin:$PATH
RUN rm gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2

# "************************************************************"
# "Install stack"
# "************************************************************"
RUN wget https://github.com/commercialhaskell/stack/releases/download/v1.6.5/stack-1.6.5-linux-x86_64-static.tar.gz
RUN tar -xf stack-1.6.5-linux-x86_64-static.tar.gz
ENV PATH /opt/stack-1.6.5-linux-x86_64-static:$PATH
RUN rm stack-1.6.5-linux-x86_64-static.tar.gz

# "************************************************************"
# "Get and install repo"
# "************************************************************"
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod 755 /usr/bin/repo

# "************************************************************"
# "Install pip software"
# "************************************************************"
RUN apt-get install -y virtualenv python3.8-venv
ENV VIRTUAL_ENV=/opt/venv
RUN virtualenv --python=python2 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python -m pip install jinja2 ply pyelftools tempita six plyplus orderedset

# "************************************************************"
# "exec "./code-setup.sh"
# "************************************************************"
ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN ./code-setup.sh

# "************************************************************"
# "exec "./code-build.sh"
# "************************************************************"
RUN ./code-build-pixhawk-image.sh
# NOTE: this fails...
#RUN ./code-build-tk1.sh
