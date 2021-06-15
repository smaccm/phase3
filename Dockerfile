FROM ubuntu:20.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8

# Formerly  ./travis.sh & system-setup.sh
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:hvr/ghc
RUN apt-get update
RUN apt-get install -y ghc cabal-install alex happy
RUN apt-get install -y default-jre
RUN apt-get -y install \
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
    wget \
    vim \
    u-boot-tools
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C /usr/bin '*/stack'


RUN pip install --user jinja2 ply pyelftools tempita six plyplus orderedset
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod 755 /usr/bin/repo

RUN cabal update
RUN cabal install data-ordlist split mtl base-compat-0.9.0

# Code setup
RUN git clone https://github.com/GaloisInc/smaccmpilot-build.git /smaccmpilot-build -b master
RUN cd /smaccmpilot-build && git submodule update --init
RUN cd /smaccmpilot-build/smaccmpilot-stm32f4 && git checkout master

ENV GIT_SSL_NO_VERIFY 1
RUN git config --global user.email "smaccm@smaccmpilot.com"
RUN git config --global user.name "Smaccmpilot"
RUN mkdir /camkes
WORKDIR /camkes
RUN repo init -u https://github.com/smaccm/phase3.git -m phase3.xml -b 2021-update
RUN repo sync
RUN repo sync -d

# Code build
WORKDIR /smaccmpilot-build/smaccmpilot-stm32f4/src/smaccm-flight
#RUN make flight_echronos

#ENV PATH $PATH:/opt/ghc/bin/:/opt/cabal/1.22/bin/:/opt/alex/3.1.4/bin/:/opt/happy/1.19.5/bin/

#RUN mkdir -p gcc-arm-embedded
#RUN wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q2-update/+download/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 -O- | tar xjf - -C gcc-arm-embedded


#WORKDIR /scripts
#ADD scripts /scripts

#RUN ./code-setup.sh
#RUN ./code-build.sh

