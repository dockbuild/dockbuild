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

WORKDIR /etc/yum.repos.d
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo
RUN yum install -y devtoolset-2-gcc \
  devtoolset-2-binutils \
  devtoolset-2-gcc-gfortran \
  devtoolset-2-gcc-c++
ENV CC /opt/rh/devtoolset-2/root/usr/bin/gcc
ENV CXX /opt/rh/devtoolset-2/root/usr/bin/g++
ENV FC /opt/rh/devtoolset-2/root/usr/bin/gfortran

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
  git checkout v3.4.0
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

# Build and install Python from source.
WORKDIR /usr/src
ENV PYTHON_VERSION 2.7.10
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
  tar xvzf Python-${PYTHON_VERSION}.tgz && \
  cd Python-${PYTHON_VERSION} && \
  ./configure && \
  make && \
  make install && \
  cd .. && rm -rf Python-${PYTHON_VERSION}

# Build and install ninja from source.
RUN git clone https://github.com/martine/ninja.git && \
  cd ninja && \
  git checkout v1.6.0 && \
  ./configure.py --bootstrap && \
  mv ninja /usr/bin/ && \
  cd .. && rm -rf ninja

WORKDIR /usr/src
CMD /bin/bash
