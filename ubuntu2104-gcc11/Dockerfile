FROM ubuntu:21.04

ARG IMAGE
ENV DEFAULT_DOCKCROSS_IMAGE=${IMAGE} \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    # https://sourceware.org/bugzilla/show_bug.cgi?id=17318#c4
    # > set en_US.UTF-8 instead of C.UTF-8 because the former is not supported on all systems.
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ARG CMAKE_VERSION=3.22.1
ARG GIT_VERSION=2.34.1
ARG NINJA_VERSION=1.10.0.gfb670.kitware.jobserver-1
ARG PYTHON_VERSION=3.9.10

# Image build scripts
COPY \
  imagefiles/build-and-install-git.sh \
  imagefiles/build-and-install-python.sh \
  imagefiles/install-cmake-binary.sh \
  imagefiles/install-gosu-binary-wrapper.sh \
  imagefiles/install-ninja-binary.sh \
  /imagefiles/

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  \
  (LANG=C LANGUAGE=C LC_ALL=C apt-get install -y locales) && \
  locale-gen ${LANG%.*} ${LANG} && \
  \
  apt-get -y upgrade && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    g++-11 \
    curl \
    gosu \
    openssh-client \
    pkg-config \
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
  # Needed to build Python from source
  apt-get install -y \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libreadline-dev \
    libsqlite3-dev \
  && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10 && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 && \
  #
  # Custom install
  #
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-gosu-binary-wrapper.sh && \
  /imagefiles/install-ninja-binary.sh && \
  /imagefiles/build-and-install-git.sh && \
  /imagefiles/build-and-install-python.sh && \
  rm -rf /imagefiles && \
  #
  # cleanup
  #
  rm -rf /var/lib/apt/lists/*

ENV AR=/usr/bin/ar \
    AS=/usr/bin/as \
    CC=/usr/bin/gcc \
    CPP=/usr/bin/cpp \
    CXX=/usr/bin/g++ \
    # Ninja will be installed in /usr/local/bin. This makes it available.
    PATH=/usr/local/bin:${PATH}

WORKDIR /work

ENTRYPOINT ["/dockcross/entrypoint.sh"]

# Runtime scripts
COPY imagefiles/entrypoint.sh imagefiles/dockcross.sh /dockcross/

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0" \
      maintainer="Rafael Palomar <rafael.palomar@rr-research.no>"
