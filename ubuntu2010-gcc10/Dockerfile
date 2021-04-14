FROM ubuntu:20.10

ARG IMAGE
ENV DEFAULT_DOCKCROSS_IMAGE=${IMAGE} \
    # https://sourceware.org/bugzilla/show_bug.cgi?id=17318#c4
    # > set en_US.UTF-8 instead of C.UTF-8 because the former is not supported on all systems.
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ARG CMAKE_VERSION=3.17.1
ARG GIT_VERSION=2.22.0
ARG NINJA_VERSION=1.9.0.g99df1.kitware.dyndep-1.jobserver-1

# Image build scripts
COPY \
  imagefiles/build-and-install-git.sh \
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
    curl \
    gosu \
    openssh-client \
    pkg-config \
    python3\
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
  #  Python symlinking. Testing procedure expects /usr/bin/python
  #
  update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
  #
  # Custom install
  #
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-gosu-binary-wrapper.sh && \
  /imagefiles/install-ninja-binary.sh && \
  /imagefiles/build-and-install-git.sh && \
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
COPY imagefiles/entrypoint.sh imagefiles/dockcross /dockcross/

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
