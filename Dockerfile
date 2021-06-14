FROM ubuntu:14.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
ADD scripts /scripts
WORKDIR /scripts
RUN sudo ./travis.sh
ENV PATH /.cabal/bin:$PATH:/opt/ghc/bin
ENV LANG C.UTF-8
RUN ./system-setup.sh
RUN ./code-setup.sh
#RUN ./code-build.sh
