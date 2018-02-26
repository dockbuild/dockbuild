docker-centos-build
===================

Collection of Docker images to `build C/C++ executables
<https://kitware.com/blog/home/post/986>`_.

.. image:: https://circleci.com/gh/dockcross/centos-build/tree/master.svg?style=svg
  :target: https://circleci.com/gh/dockcross/centos-build/tree/master

Maintained images
-----------------

.. |centos6-latest| image:: https://images.microbadger.com/badges/image/centosbuild/6:latest.svg
  :target: https://microbadger.com/images/centosbuild/6:latest

.. _devtools-2: https://people.centos.org/tru/devtools-2/

centosbuild/6:latest
  |centos6-latest| Centos6 based image including the `devtools-2`_, git 2.16.2, cmake 3.10.2, python 3.6.4 and ninja 1.8.2.

.. |centos7-latest| image:: https://images.microbadger.com/badges/image/centosbuild/7:latest.svg
  :target: https://microbadger.com/images/centosbuild/7:latest

.. _devtools-4: https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/4/html-single/4.1_release_notes/

centosbuild/7:latest
  |centos7-latest| Centos7 based image including the `devtools-4`_, git 2.16.2, cmake 3.10.2, python 3.6.4 and ninja 1.8.2.


Obsolete images
---------------

.. |centos5-latest| image:: https://images.microbadger.com/badges/image/thewtex/centos-build:latest.svg
  :target: https://microbadger.com/images/thewtex/centos-build:latest

thewtex/centos-build:latest
  |centos5-latest| Centos5 based image including the `devtools-2`_, git 2.5.0, cmake 3.7.2, Python 2.7.12 and ninja 1.7.2.
