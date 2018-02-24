FROM centos:6
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN yum update -y && \
  yum install -y \
   bzip2-devel \
   curl \
   curl-devel \
   coreutils \
   gettext \
   openssl-devel \
   perl \
   perl-devel \
   unzip \
   wget \
   zlib-devel

WORKDIR /etc/yum.repos.d
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo
RUN yum install -y devtoolset-2-gcc \
  devtoolset-2-binutils \
  devtoolset-2-gcc-gfortran \
  devtoolset-2-gcc-c++
ENV CC /opt/rh/devtoolset-2/root/usr/bin/gcc
ENV CXX /opt/rh/devtoolset-2/root/usr/bin/g++
ENV FC /opt/rh/devtoolset-2/root/usr/bin/gfortran

# Install CMake
WORKDIR /usr/src
RUN wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz && \
  tar -xzvf cmake-3.10.2-Linux-x86_64.tar.gz && \
  cd cmake-3.10.2-Linux-x86_64 && \
  ln -s $(pwd)/bin/cmake /usr/local/bin/cmake && \
  ln -s $(pwd)/bin/ctest /usr/local/bin/ctest && \
  ln -s $(pwd)/bin/cpack /usr/local/bin/cpack && \
  ln -s $(pwd)/bin/ccmake /usr/local/bin/ccmake

# Install ninja
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && \
  unzip ninja-linux.zip && \
  mv ninja /usr/local/bin/ && \
  rm -f ninja-linux.zip

# Add /usr/local/lib to ldconfig
RUN echo '/usr/local/lib' >> /etc/ld.so.conf.d/usr-local.conf && \
    ldconfig

# Build and install git from source.
WORKDIR /usr/src
ENV GIT_VERSION 2.16.2
RUN wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz && \
  tar xvzf git-${GIT_VERSION}.tar.gz && \
  cd git-${GIT_VERSION} && \
  ./configure --prefix=/usr/local && \
  make && \
  make install && \
  cd .. && rm -rf git-${GIT_VERSION}*

WORKDIR /usr/src
CMD /bin/bash
