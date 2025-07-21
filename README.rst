dockbuild
=========

Compiling environments in Docker images.

.. image:: https://circleci.com/gh/dockbuild/dockbuild/tree/master.svg?style=svg
  :target: https://circleci.com/gh/dockbuild/dockbuild/tree/master

Features
--------

* Commands in the container are run as the calling user, so that any created files have the expected ownership, (i.e. not root).
* Make variables (`CC`, `CXX` etc) are set to point to the appropriate tools in the container.
* Recent `CMake <https://cmake.org>`_ and ninja are precompiled.
* `Conan.io <https://www.conan.io>`_ can be used as a package manager.
* Current directory is mounted as the container's workdir, ``/work``.
* Works with the `Docker for Mac <https://docs.docker.com/docker-for-mac/>`_ and `Docker for Windows <https://docs.docker.com/docker-for-windows/>`_.
* Support using alternative container executor by setting **OCI_EXE** environment variable. By default, it searches for `docker <https://www.docker.com>`_ and `podman <https://podman.io>`_ executable.


In addition to the devtools, all images include:

* cmake 3.31.8
* curl with TLS 1.2 support
* git >= 2.43 (with ``git config --global advice.detachedHead false``)
* python >= 3.11
* ninja 1.1.11 with `GNU make jobserver client and Fortran support <https://github.com/kitware/ninja>`_


What is the difference between `dockcross` and `dockbuild` ?
------------------------------------------------------------

The key difference is that `dockbuild <https://github.com/dockbuild/dockbuild#readme>`_
images use the same method to conveniently isolate the build environment as
`dockcross <https://github.com/dockcross/dockcross#readme>`_ but they do **NOT** provide
a toolchain file.


Compiling environments
----------------------

.. |ubuntu1804-gcc7-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu1804-gcc7/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu1804-gcc7/tags?page=1&name=latest

dockbuild/ubuntu1804-gcc7:latest, dockbuild/ubuntu1804:latest
  |ubuntu1804-gcc7-latest| Ubuntu 18.04 based image.


.. |ubuntu2004-gcc9-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu2004-gcc9/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu2004-gcc9/tags?page=1&name=latest

dockbuild/ubuntu2004-gcc9:latest, dockbuild/ubuntu2004:latest
  |ubuntu2004-gcc9-latest| Ubuntu 20.04 based image.


.. |almalinux8-devtoolset14-gcc14-latest| image:: https://img.shields.io/docker/image-size/dockbuild/almalinux8-devtoolset14-gcc14/latest
  :target: https://hub.docker.com/r/dockbuild/almalinux8-devtoolset14-gcc14/tags?page=1&name=latest

dockbuild/almalinux8-devtoolset14-gcc14:latest
  |almalinux8-devtoolset14-gcc14-latest| AlmaLinux 8 based image.

Deprecated build environments
-----------------------------

*Deprecated build environments are not built/tested/deployed using continuous integration and corresponding Dockerfile have been removed.*

.. |ubuntu2104-gcc11-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu2104-gcc11/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu2104-gcc11/tags?page=1&name=latest

dockbuild/ubuntu2104-gcc11:latest, dockbuild/ubuntu2104:latest
  |ubuntu2104-gcc11-latest| Ubuntu 21.04 based image.


.. |centos7-devtoolset4-gcc5-latest| image:: https://img.shields.io/docker/image-size/dockbuild/centos7-devtoolset4-gcc5/latest
  :target: https://hub.docker.com/r/dockbuild/centos7-devtoolset4-gcc5/tags?page=1&name=latest

.. _devtools-4: https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/4/html-single/4.1_release_notes/

dockbuild/centos7-devtoolset4-gcc5:latest, dockbuild/centos7:latest
  |centos7-devtoolset4-gcc5-latest| Centos7 based image including the `devtools-4`_.


.. |centos7-devtoolset7-gcc7-latest| image:: https://img.shields.io/docker/image-size/dockbuild/centos7-devtoolset7-gcc7/latest
  :target: https://hub.docker.com/r/dockbuild/centos7-devtoolset7-gcc7/tags?page=1&name=latest

.. _devtools-7: https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/7/html-single/7.1_release_notes/

dockbuild/centos7-devtoolset7-gcc7:latest
  |centos7-devtoolset7-gcc7-latest| Centos7 based image including the `devtools-7`_.


.. |centos5-devtoolset2-gcc4-latest| image:: https://img.shields.io/docker/image-size/dockbuild/centos5-devtoolset2-gcc4/latest
  :target: https://hub.docker.com/r/dockbuild/centos5-devtoolset2-gcc4/tags?page=1&name=latest

dockbuild/centos5-devtoolset2-gcc4:latest, dockbuild/centos5:latest
  |centos5-devtoolset2-gcc4-latest| Centos5 based image including the `devtools-2`_.


.. |centos6-devtoolset2-gcc4-latest| image:: https://img.shields.io/docker/image-size/dockbuild/centos6-devtoolset2-gcc4/latest
  :target: https://hub.docker.com/r/dockbuild/centos6-devtoolset2-gcc4/tags?page=1&name=latest

.. _devtools-2: https://people.centos.org/tru/devtools-2/

dockbuild/centos6-devtoolset2-gcc4:latest, dockbuild/centos6:latest
  |centos6-devtoolset2-gcc4-latest| Centos6 based image including the `devtools-2`_.


.. |ubuntu1004-gcc4-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu1004-gcc4/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu1004-gcc4/tags?page=1&name=latest

dockbuild/ubuntu1004-gcc4:latest, dockbuild/ubuntu1004:latest
  |ubuntu1004-gcc4-latest| Ubuntu 10.04 based image.


.. |ubuntu1604-gcc5-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu1604-gcc5/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu1604-gcc5/tags?page=1&name=latest

dockbuild/ubuntu1604-gcc5:latest, dockbuild/ubuntu1604:latest
  |ubuntu1604-gcc5-latest| Ubuntu 16.04 based image.


.. |ubuntu1904-gcc8-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu1904-gcc8/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu1904-gcc8/tags?page=1&name=latest

dockbuild/ubuntu1904-gcc8:latest, dockbuild/ubuntu1904:latest
  |ubuntu1904-gcc8-latest| Ubuntu 19.04 based image.


.. |ubuntu2010-gcc10-latest| image:: https://img.shields.io/docker/image-size/dockbuild/ubuntu2010-gcc10/latest
  :target: https://hub.docker.com/r/dockbuild/ubuntu2010-gcc10/tags?page=1&name=latest

dockbuild/ubuntu2010-gcc10:latest, dockbuild/ubuntu2010:latest
  |ubuntu2010-gcc10-latest| Ubuntu 20.10 based image.


Installation
------------

This image does not need to be run manually. Instead, there is a helper script
to execute build commands on source code existing on the local host filesystem. This
script is bundled with the image.

To install the helper script, run one of the images with no arguments, and
redirect the output to a file::

  docker run --rm IMAGE_NAME > ./dockbuild
  chmod +x ./dockbuild
  mv ./dockbuild ~/bin/

Where `IMAGE_NAME` is the name of the compiling environment
Docker instance, e.g. `dockbuild/centos5-devtoolset2-gcc4`.

Only 64-bit images are provided; a 64-bit host system is required.


Usage
-----

For the impatient, here's how to compile a hello world on centos5-devtoolset2-gcc4::

  cd ~/src/dockbuild
  docker run --rm dockbuild/centos5-devtoolset2-gcc4 > ./dockbuild-centos5-devtoolset2-gcc4
  chmod +x ./dockbuild-centos5-devtoolset2-gcc4
  ./dockbuild-centos5-devtoolset2-gcc4 bash -c '$CC test/C/hello.c -o hello_centos5'

Note how invoking any build command (make, gcc, etc.) is just a matter of prepending the **dockbuild** script on the commandline::

  ./dockbuild-centos5-devtoolset2-gcc4 [command] [args...]

The dockbuild script will execute the given command-line inside the container,
along with all arguments passed after the command. Commands that evaluate
environmental variables in the image, like `$CC` above, should be executed in
`bash -c`. The present working directory is mounted within the image, which
can be used to make source code available in the Docker container.


Built-in update commands
------------------------

A special update command can be executed that will update the
source cross-compiler Docker image or the dockbuild script itself.

- ``dockbuild [--] command [args...]``: Forces a command to run inside the container (in case of a name clash with a built-in command), use ``--`` before the command.
- ``dockbuild update-image``: Fetch the latest version of the docker image.
- ``dockbuild update-script``: Update the installed dockbuild script with the one bundled in the image.
- ``dockbuild update``: Update both the docker image, and the dockbuild script.


Download all images
-------------------

To easily download all images, the convenience target ``display_images`` could be used::

  curl https://raw.githubusercontent.com/dockbuild/dockbuild/master/Makefile -o dockbuild-Makefile
  for image in $(make -f dockbuild-Makefile display_images); do
    echo "Pulling dockbuild/$image"
    docker pull dockbuild/$image
  done


Install all dockbuild scripts
-----------------------------

To automatically install in ``~/bin`` the dockbuild scripts for each images already downloaded, the
convenience target ``display_images`` could be used::

  curl https://raw.githubusercontent.com/dockbuild/dockbuild/master/Makefile -o dockbuild-Makefile
  for image in $(make -f dockbuild-Makefile display_images); do
    if [[ $(docker images -q dockbuild/$image) == "" ]]; then
      echo "~/bin/dockbuild-$image skipping: image not found locally"
      continue
    fi
    echo "~/bin/dockbuild-$image ok"
    docker run dockbuild/$image > ~/bin/dockbuild-$image && \
    chmod u+x  ~/bin/dockbuild-$image
  done


Dockbuild configuration
-----------------------

*TBD*


Per-project dockbuild configuration
-----------------------------------

*TBD*


How to extend Dockbuild images
------------------------------

*TBD*

maintainers
-----------

Updating CMake version
^^^^^^^^^^^^^^^^^^^^^^

1. Set CMake version ``X.Y.Z`` corresponding to an `existing tag <https://github.com/Kitware/CMake/releases>`_.
   For example:

::

    CMAKE_VERSION=3.22.1

2. Update CMake version, and create a Pull Request

::

    # Get current version
    git clone git@github.com:dockbuilb/dockbuild && \
    cd $_ && \
    PREVIOUS_CMAKE_VERSION=$(cat README.rst | grep "^\* cmake" | cut -d" " -f3) && \
    echo "PREVIOUS_CMAKE_VERSION [${PREVIOUS_CMAKE_VERSION}]"

    # Update version
    git checkout -b update-cmake-from-v${PREVIOUS_CMAKE_VERSION}-to-v${CMAKE_VERSION} && \
    \
    for file in $(find . -name Dockerfile) README.rst; do
      sed -i "s/${PREVIOUS_CMAKE_VERSION}/${CMAKE_VERSION}/g" $file
    done && \
    \
    git add $(find . -name Dockerfile) README.rst && \
    \
    git commit -m "Update CMake from v${PREVIOUS_CMAKE_VERSION} to v${CMAKE_VERSION}"

    # Inspect changes
    git diff HEAD^

    # Publish branch
    git push origin update-cmake-from-v${PREVIOUS_CMAKE_VERSION}-to-v${CMAKE_VERSION}
    git pull-request

3. Check `CircleCI <https://circleci.com/gh/dockbuild/dockbuild>`_ and merge `Pull Request <https://github.com/dockbuild/dockbuild/pull>`_ if tests pass.

.. note::

  * Command ``sed -i`` may not be available on all unix systems.

  * Command ``git pull-request`` is available after install `hub <https://hub.github.com>`_

Articles
--------

- `How to build distributable C++ executables for Linux with Docker
  <https://blog.kitware.com/how-to-build-distributable-c-executables-for-linux-with-docker/>`_


---

Credits go to `sdt/docker-raspberry-pi-cross-compiler <https://github.com/sdt/docker-raspberry-pi-cross-compiler>`_, who invented the base of the **dockcross** script.

