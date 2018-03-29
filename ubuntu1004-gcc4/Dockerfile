FROM ubuntu:10.04

ARG IMAGE
ENV DEFAULT_DOCKCROSS_IMAGE=${IMAGE} \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    # https://sourceware.org/bugzilla/show_bug.cgi?id=17318#c4
    # > set en_US.UTF-8 instead of C.UTF-8 because the former is not supported on all systems.
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ARG CMAKE_VERSION=3.10.2
ARG GIT_VERSION=2.16.2
ARG NINJA_VERSION=1.8.2
ARG PYTHON_VERSION=3.6.4

COPY \
  imagefiles/build-and-install-curl.sh \
  imagefiles/build-and-install-git.sh \
  imagefiles/install-gosu-binary.sh \
  imagefiles/build-and-install-openssl.sh \
  imagefiles/build-and-install-openssh.sh \
  imagefiles/build-and-install-python.sh \
  imagefiles/install-cmake-binary.sh \
  imagefiles/install-entrypoint.sh \
  imagefiles/install-ninja-binary.sh \
  imagefiles/utils.sh \
  /imagefiles/

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  sed -i "s/archive.ubuntu.com/old-releases.ubuntu.com/" /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get update && \
  apt-get install -y \
    autoconf \
    build-essential \
    curl \
    unzip \
    subversion \
  && \
  # Needed to download package before curl is built
  apt-get install -y wget && \
  # Needed to build Git from source
  apt-get install -y \
    gettext \
    libexpat1-dev \
    zlib1g-dev \
  && \
  #
  # Custom install
  #
  /imagefiles/build-and-install-openssl.sh && \
  /imagefiles/build-and-install-curl.sh && \
  /imagefiles/build-and-install-openssh.sh && \
  /imagefiles/build-and-install-git.sh && \
  /imagefiles/build-and-install-python.sh && \
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-gosu-binary.sh && \
  /imagefiles/install-ninja-binary.sh && \
  /imagefiles/install-entrypoint.sh && \
  rm -rf /imagefiles && \
  #
  # cleanup
  #
  rm -rf /var/lib/apt/lists/* && \
  mkdir /var/lib/apt/lists/partial

ENV AR=/usr/bin/ar \
    AS=/usr/bin/as \
    CC=/usr/bin/gcc \
    CPP=/usr/bin/cpp \
    CXX=/usr/bin/g++

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
      org.label-schema.schema-version="1.0" \
      maintainer="Jean-Christophe Fillion-Robin <jchris.fillionr@kitware.com>"
