Build of Builds
===============

This is the repository for the phase 3 demo software and build support. The scripts directory contains everything needed to compile the demo.

Build the docker image with:
```
$ docker build -t smaccm-build .
```

Alternatively, pull the image from dockerhub with:
```
$ docker pull podhrmic/smaccmpilot-build
```

Run with:
```
$ docker run -v $PWD:/workdir -it smaccmpilot-build
```