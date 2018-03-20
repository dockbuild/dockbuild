FROM centos:7
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

ENV DEFAULT_DOCKCROSS_IMAGE=dockbuild/centos7 \
    CC=/opt/rh/devtoolset-4/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-4/root/usr/bin/g++ \
    FC=/opt/rh/devtoolset-4/root/usr/bin/gfortran \
    PATH=/opt/rh/devtoolset-4/root/usr/bin${PATH:+:${PATH}} \
    CMAKE_VERSION=3.10.2 \
    GIT_VERSION=2.16.2 \
    NINJA_VERSION=1.8.2 \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    LANG=C.UTF-8 \
    PYTHON_VERSION=3.6.4

COPY imagefiles /imagefiles

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
   zlib-devel \
  && \
  #
  # Install devtoolset (See http://linuxpitstop.com/install-and-use-red-hat-developer-toolset-4-1-on-centos-7/)
  #
  yum install -y centos-release-scl && \
  yum install -y \
   devtoolset-4-gcc \
   devtoolset-4-binutils \
   devtoolset-4-gcc-gfortran \
   devtoolset-4-gcc-c++ \
  && \
  #
  # Custom install
  #
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-ninja-binary.sh && \
  /imagefiles/build-and-install-git.sh && \
  /imagefiles/build-and-install-python.sh && \
  /imagefiles/install-entrypoint.sh && \
  rm -rf /imagefiles && \
  #
  # cleanup
  #
  yum -y clean all && rm -rf /var/cache/yum


WORKDIR /work

ENTRYPOINT ["/dockcross/entrypoint.sh"]

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
