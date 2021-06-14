FROM ubuntu:14.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
ADD scripts /scripts
WORKDIR /scripts
RUN sudo ./travis.sh
ENV PATH $PATH:/opt/ghc/bin/:/opt/cabal/1.22/bin/:/opt/alex/3.1.4/bin/:/opt/happy/1.19.5/bin/
ENV LANG en_US.UTF-8
RUN ./system-setup.sh
RUN ./code-setup.sh
RUN ./code-build.sh
