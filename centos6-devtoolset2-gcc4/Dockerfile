FROM centos:6

ARG IMAGE
ENV DEFAULT_DOCKCROSS_IMAGE=${IMAGE} \
    CC=/opt/rh/devtoolset-2/root/usr/bin/gcc \
    CXX=/opt/rh/devtoolset-2/root/usr/bin/g++ \
    FC=/opt/rh/devtoolset-2/root/usr/bin/gfortran \
    PATH=/opt/rh/devtoolset-2/root/usr/bin${PATH:+:${PATH}} \
    # http://bugs.python.org/issue19846
    # > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
    # https://sourceware.org/bugzilla/show_bug.cgi?id=17318#c4
    # > set en_US.UTF-8 instead of C.UTF-8 because the former is not supported on all systems.
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ARG CMAKE_VERSION=3.13.4
ARG GIT_VERSION=2.16.2
ARG NINJA_VERSION=1.9.0.g99df1.kitware.dyndep-1.jobserver-1
ARG PYTHON_VERSION=3.6.4

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
   bzip2-devel \
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
  #
  # Install devtoolset
  #
  cd /etc/yum.repos.d && \
  wget http://people.centos.org/tru/devtools-2/devtools-2.repo && \
  yum install -y \
   devtoolset-2-gcc \
   devtoolset-2-binutils \
   devtoolset-2-gcc-gfortran \
   devtoolset-2-gcc-c++ \
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
  rm -rf /imagefiles && \
  #
  # cleanup
  #
  yum -y clean all && rm -rf /var/cache/yum

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
