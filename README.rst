docker-centos-build
===================

Collection of Docker images to `build C/C++ executables
<https://kitware.com/blog/home/post/986>`_.

.. image:: https://circleci.com/gh/dockcross/centos-build/tree/master.svg?style=svg
  :target: https://circleci.com/gh/dockcross/centos-build/tree/master

In addition to the devtools, all images include:

* cmake 3.10.2
* curl with TLS 1.2 support
* git 2.16.2
* python 3.6.4
* ninja 1.8.2

Maintained images
-----------------

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

