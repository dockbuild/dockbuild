FROM centos:6
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

ENV CC=/opt/rh/devtoolset-2/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-2/root/usr/bin/g++ \
    FC=/opt/rh/devtoolset-2/root/usr/bin/gfortran \
    PATH=/opt/rh/devtoolset-2/root/usr/bin${PATH:+:${PATH}} \
    CMAKE_VERSION=3.10.2 \
    GIT_VERSION=2.16.2 \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    LANG=C.UTF-8 \
    PYTHON_VERSION=3.6.4

RUN yum update -y && \
  yum install -y \
   automake \
   bison \
   bzip2-devel \
   curl \
   curl-devel \
   coreutils \
   file \
   gettext \
   make \
   openssl-devel \
   patch \
   perl \
   perl-devel \
   unzip \
   wget \
   which \
   yasm \
   zlib-devel && \
  #
  # Install devtoolset
  #
  cd /etc/yum.repos.d && \
  wget http://people.centos.org/tru/devtools-2/devtools-2.repo && \
  yum install -y \
   devtoolset-2-gcc \
   devtoolset-2-binutils \
   devtoolset-2-gcc-gfortran \
   devtoolset-2-gcc-c++ && \
  #
  # Install CMake
  #
  cd /usr/src && \
  CMAKE_VERSION_XY=$(echo $CMAKE_VERSION | sed -r 's/\.[0-9]+$//') && \
  wget https://cmake.org/files/v${CMAKE_VERSION_XY}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
  tar -xzvf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
  rm -f cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
  cd cmake-${CMAKE_VERSION}-Linux-x86_64 && \
  rm -rf doc man && \
  rm -rf bin/cmake-gui && \
  ln -s $(pwd)/bin/cmake /usr/local/bin/cmake && \
  ln -s $(pwd)/bin/ctest /usr/local/bin/ctest && \
  ln -s $(pwd)/bin/cpack /usr/local/bin/cpack && \
  ln -s $(pwd)/bin/ccmake /usr/local/bin/ccmake && \
  #
  # Install ninja
  #
  cd /usr/src && \
  wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip && \
    unzip ninja-linux.zip && \
    mv ninja /usr/local/bin/ && \
    rm -f ninja-linux.zip && \
  #
  # Add /usr/local/lib to ldconfig
  #
  echo '/usr/local/lib' >> /etc/ld.so.conf.d/usr-local.conf && \
  ldconfig && \
  #
  # Build and install git from source.
  #
  cd /usr/src && \
  wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz && \
    tar xvzf git-${GIT_VERSION}.tar.gz && \
    cd git-${GIT_VERSION} && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd .. && rm -rf git-${GIT_VERSION}* && \
  #
  # Build and install Python from source.
  #
  cd /usr/src && \
  wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
  tar xvzf Python-${PYTHON_VERSION}.tgz && \
  cd Python-${PYTHON_VERSION} && \
  ./configure --enable-shared && \
  make -j$(grep -c processor /proc/cpuinfo) && \
  make install && \
  ldconfig && \
  cd .. && rm -rf Python-${PYTHON_VERSION}* && \
  cd /usr/local/bin && \
	ln -s pip3 pip && \
	ln -s idle3 idle && \
	ln -s pydoc3 pydoc && \
	ln -s python3 python && \
  ln -s python3-config python-config && \
  # Copied from https://github.com/docker-library/python/blob/master/3.6/stretch/slim/Dockerfile
  (find /usr/local/lib -depth \
      \( -type d -a -name test -o -name tests \) \
   -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
   -exec rm -rf '{}' +;) && \
  #
  # cleanup
  #
  yum -y clean all && rm -rf /var/cache/yum

WORKDIR /usr/src
CMD /bin/bash

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
org.label-schema.schema-version="1.0"
