FROM centos:5
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

ENV DEFAULT_DOCKCROSS_IMAGE=dockbuild/centos5 \
    CC=/opt/rh/devtoolset-2/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-2/root/usr/bin/g++ \
    FC=/opt/rh/devtoolset-2/root/usr/bin/gfortran \
    PATH=/opt/rh/devtoolset-2/root/usr/bin${PATH:+:${PATH}} \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-2/root/usr/lib64:/opt/rh/devtoolset-2/root/usr/lib:/usr/local/lib64:/usr/local/lib \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    CMAKE_VERSION=3.10.2 \
    NINJA_VERSION=1.8.2

ADD etc/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD etc/CentOS-Vault.repo /etc/yum.repos.d/CentOS-Vault.repo
ADD etc/libselinux.repo /etc/yum.repos.d/libselinux.repo

COPY build_scripts /build_scripts
COPY imagefiles /imagefiles

RUN \
  build_scripts/build.sh && \
  rm -r build_scripts && \
  #
  # Custom install
  #
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-ninja-binary.sh && \
  /imagefiles/install-entrypoint.sh && \
  rm -rf /imagefiles

ENV SSL_CERT_FILE=/opt/_internal/certs.pem

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
