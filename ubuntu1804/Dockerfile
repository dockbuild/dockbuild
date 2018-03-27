FROM ubuntu:18.04

ENV DEFAULT_DOCKCROSS_IMAGE=dockbuild/ubuntu1804 \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    LANG=C.UTF-8

ARG CMAKE_VERSION=3.10.2
ARG GIT_VERSION=2.16.2
ARG NINJA_VERSION=1.8.2
ARG PYTHON_VERSION=3.6.4

COPY \
  imagefiles/install-cmake-binary.sh \
  imagefiles/install-ninja-binary.sh \
  imagefiles/build-and-install-git.sh \
  imagefiles/build-and-install-python.sh \
  imagefiles/install-entrypoint.sh \
  /imagefiles/

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    curl \
    gosu \
    openssh-client \
    unzip \
  && \
  # Needed to build Git from source
  apt-get install -y \
    gettext \
    libssl-dev \
    libcurl4-gnutls-dev \
    libexpat1-dev \
    zlib1g-dev \
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
  rm -rf /var/lib/apt/lists/*

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
