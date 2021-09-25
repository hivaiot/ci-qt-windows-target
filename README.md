# Supported tags and respective `Dockerfile` links
* [dynamic, latest](https://github.com/hivaiot/ci-qt-windows-target/blob/main/Dockerfile.dynamic): dynamic (shared) link libraries
* [static](https://github.com/hivaiot/ci-qt-windows-target/blob/main/Dockerfile.static): static link libraries
* [all](https://github.com/hivaiot/ci-qt-windows-target/blob/main/Dockerfile): both dynamic & static link libraries

# What is ci-qt-windows-target?
Qt applications couldn't build on linux to run on windows machines easily. because the most of continuous integration services that free like [Gitlab](gitlab.com), [framagit](framagit.org) and many others has much more linux runners than windows runners. Then, it should be easier to use linux runners to build windows applications using `Qt` or `C++`. 

# About this image 
This image has tools to build windows applications. Following tools are included in image:
* [MXE (M cross environment)](https://github.com/mxe/mxe)
* gcc 10 (x86_64-w64-mingw32)
* openssl
* icu4c
* qt5 (v5.15.2)
* jq (json parser)
* [CQtDeployer](https://github.com/QuasarApp/CQtDeployer) (deploy applications written using QML, qt or other С / С++ frameworks)
* pe-util
* python (v2.7.16 & v3.7.3)
* perl (v5.28.1)
* qmake (v3.1)

For dynamic (shared) link libraries use `dynamic` or `latest` tag. For static link use `static` tag and for both dynamic and static build use `all` tag.

When application built you need to deploy it with all `dll` that used in application, so `pe-util` or `cqtdeployer` could help for this purpose.

For creating Installer using `qt installer framework` you might need another [image](https://hub.docker.com/r/hivaiot/ci-qt-installer-framework-windows-target).
