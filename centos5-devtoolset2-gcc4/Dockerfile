FROM centos:5

ARG IMAGE
ENV DEFAULT_DOCKCROSS_IMAGE=${IMAGE} \
    CC=/opt/rh/devtoolset-2/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-2/root/usr/bin/g++ \
    FC=/opt/rh/devtoolset-2/root/usr/bin/gfortran \
    PATH=/opt/rh/devtoolset-2/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-2/root/usr/lib64:/opt/rh/devtoolset-2/root/usr/lib:/usr/local/lib64:/usr/local/lib \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    # https://sourceware.org/bugzilla/show_bug.cgi?id=17318#c4
    # > set en_US.UTF-8 instead of C.UTF-8 because the former is not supported on all systems.
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ARG CMAKE_VERSION=3.13.4
ARG NINJA_VERSION=1.9.0.g99df1.kitware.dyndep-1.jobserver-1

ADD etc/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD etc/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo
ADD etc/libselinux.repo /etc/yum.repos.d/libselinux.repo

# Image build scripts
COPY build_scripts /build_scripts
COPY \
  imagefiles/build-and-install-openssh.sh \
  imagefiles/install-cmake-binary.sh \
  imagefiles/install-gosu-binary.sh \
  imagefiles/install-gosu-binary-wrapper.sh \
  imagefiles/install-ninja-binary.sh \
  imagefiles/entrypoint.sh \
  /imagefiles/

RUN \
  build_scripts/build.sh && \
  rm -r build_scripts && \
  #
  # Custom install
  #
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-gosu-binary.sh && \
  /imagefiles/install-gosu-binary-wrapper.sh && \
  /imagefiles/install-ninja-binary.sh && \
  # Remove sudo provided by "devtoolset-2" since it doesn't work with
  # our sudo wrapper calling gosu.
  rm -f /opt/rh/devtoolset-2/root/usr/bin/sudo && \
  rm -rf /imagefiles

ENV SSL_CERT_FILE=/opt/_internal/certs.pem

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
      maintainer="Matt McCormick <matt.mccormick@kitware.com>"
