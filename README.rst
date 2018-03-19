dockbuild
=========

Compiling environments in Docker images.

.. image:: https://circleci.com/gh/dockbuild/dockbuild/tree/master.svg?style=svg
  :target: https://circleci.com/gh/dockbuild/dockbuild/tree/master

Features
--------

* Commands in the container are run as the calling user, so that any created files have the expected ownership, (i.e. not root).
* Make variables (`CC`, `LD` etc) are set to point to the appropriate tools in the container.
* Recent `CMake <https://cmake.org>`_ and ninja are precompiled.
* `Conan.io <https://www.conan.io>`_ can be used as a package manager.
* Current directory is mounted as the container's workdir, ``/work``.
* Works with the `Docker for Mac <https://docs.docker.com/docker-for-mac/>`_ and `Docker for Windows <https://docs.docker.com/docker-for-windows/>`_.


In addition to the devtools, all images include:

* cmake 3.10.2
* curl with TLS 1.2 support
* git 2.16.2
* python 3.6.4
* ninja 1.8.2


What is the difference between `dockcross` and `dockbuild` ?
------------------------------------------------------------

The key difference is that `dockbuild <https://github.com/dockbuild/dockbuild#readme>`_
images use the same method to conveniently isolate the build environment as
`dockcross <https://github.com/dockcross/dockcross#readme>`_ but they do **NOT** provide
a toolchain file.


Compiling environments
----------------------

.. |centos5-latest| image:: https://images.microbadger.com/badges/image/dockbuild/centos5:latest.svg
  :target: https://microbadger.com/images/dockbuild/centos5:latest

dockbuild/centos5:latest
  |centos5-latest| Centos5 based image including the `devtools-2`_.


.. |centos6-latest| image:: https://images.microbadger.com/badges/image/dockbuild/centos6:latest.svg
  :target: https://microbadger.com/images/dockbuild/centos6:latest

.. _devtools-2: https://people.centos.org/tru/devtools-2/

dockbuild/centos6:latest
  |centos6-latest| Centos6 based image including the `devtools-2`_.


.. |centos7-latest| image:: https://images.microbadger.com/badges/image/dockbuild/centos7:latest.svg
  :target: https://microbadger.com/images/dockbuild/centos7:latest

.. _devtools-4: https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/4/html-single/4.1_release_notes/

dockbuild/centos7:latest
  |centos7-latest| Centos7 based image including the `devtools-4`_.


Articles
--------

- `How to build distributable C++ executables for Linux with Docker
  <https://kitware.com/blog/home/post/986/>`_


---

Credits go to `sdt/docker-raspberry-pi-cross-compiler <https://github.com/sdt/docker-raspberry-pi-cross-compiler>`_, who invented the base of the **dockcross** script.

