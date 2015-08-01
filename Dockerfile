FROM centos:5
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN yum update -y && \
  yum groupinstall -y "Development Tools" && \
  yum install -y curl \
   curl-devel \
   coreutils \
   gcc \
   gcc-c++ \
   gettext \
   perl \
   wget \
   zlib-devel

# Build and install git from source.
WORKDIR /usr/src
ENV GIT_VERSION 2.5.0
RUN wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz && \
  tar xvzf git-${GIT_VERSION}.tar.gz && \
  cd git-${GIT_VERSION} && \
  ./configure --prefix=/usr && \
  make && \
  make install && \
  cd .. && rm -rf git-${GIT_VERSION}

# Build and install CMake from source.
WORKDIR /usr/src
RUN git clone git://cmake.org/cmake.git CMake && \
  cd CMake && \
  git checkout v3.3.0
RUN mkdir CMake-build
WORKDIR /usr/src/CMake-build
RUN /usr/src/CMake/bootstrap \
    --parallel=$(nproc) \
    --prefix=/usr && \
  make && \
  ./bin/cmake -DCMAKE_USE_SYSTEM_CURL:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_USE_OPENSSL:BOOL=ON . && \
  make install && \
  rm -rf *

WORKDIR /usr/src
CMD /bin/bash
