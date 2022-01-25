FROM centos:7

ARG IMAGE
ENV DEFAULT_DOCKCROSS_IMAGE=${IMAGE} \
    CC=/opt/rh/devtoolset-7/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-7/root/usr/bin/g++ \
    FC=/opt/rh/devtoolset-7/root/usr/bin/gfortran \
    PATH=/opt/rh/devtoolset-7/root/usr/bin${PATH:+:${PATH}} \
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
  imagefiles/install-gosu-binary.sh \
  imagefiles/install-gosu-binary-wrapper.sh \
  imagefiles/install-ninja-binary.sh \
  /imagefiles/

RUN yum update -y && \
  yum install -y \
   automake \
   bison \
   curl \
   curl-devel \
   coreutils \
   file \
   gettext \
   make \
   openssh-clients \
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
  # Needed to build Python from source
  yum install -y \
   bzip2-devel \
   libffi-devel \
   readline-devel \
   sqlite-devel \
   xz-devel \
  && \
  #
  # Install devtoolset (See http://linuxpitstop.com/install-and-use-red-hat-developer-toolset-4-1-on-centos-7/)
  #
  yum install -y centos-release-scl && \
  sed \
    -e "s/^mirrorlist/#mirrorlist/" -e "s/^#\s*baseurl/baseurl/" \
    -e "s/mirror.centos.org\/centos\/7/vault.centos.org\/7.6.1810/" \
    -i /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo && \
  sed \
    -e "s/^mirrorlist/#mirrorlist/" -e "s/^#\s*baseurl/baseurl/" \
    -e "s/mirror.centos.org\/centos\/7/vault.centos.org\/7.6.1810/" \
    -i /etc/yum.repos.d/CentOS-SCLo-scl.repo && \
  yum clean all && \
  yum update && \
  yum install -y \
   devtoolset-7-gcc \
   devtoolset-7-binutils \
   devtoolset-7-gcc-gfortran \
   devtoolset-7-gcc-c++ \
  && \
  #
  # Custom install
  #
  /imagefiles/install-cmake-binary.sh && \
  /imagefiles/install-gosu-binary.sh && \
  /imagefiles/install-gosu-binary-wrapper.sh && \
  /imagefiles/install-ninja-binary.sh && \
  /imagefiles/build-and-install-git.sh && \
  /imagefiles/build-and-install-python.sh && \
  # Remove sudo provided by "devtoolset-7" since it doesn't work with
  # our sudo wrapper calling gosu.
  rm -f /opt/rh/devtoolset-7/root/usr/bin/sudo && \
  rm -rf /imagefiles && \
  #
  # cleanup
  #
  yum -y clean all && rm -rf /var/cache/yum


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
      maintainer="Matt McCormick <matt.mccormick@kitware.com>"
