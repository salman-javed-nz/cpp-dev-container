# C++ Development Tools (Docker)

A Docker image containing tools for C++ development, for my personal use.

Refer to the
[Releases](https://github.com/salman-javed-nz/cpp-dev-docker/releases/latest)
page for pre-built images.

## Contents

Operating System

* Fedora 40

Toolchains

* GCC toolchain
* Clang toolchain
* MinGW toolchain

Build Systems

* CMake
* Meson

Package Managers

* Conan
* Vcpkg

Code Quality and Analysis Tools

* Clang-Tidy
* Cppcheck
* Include What You Use
* Sanitizers
* Valgrind

## Building

Building this Docker image from scratch requires
[Docker](https://www.docker.com) or an equivalent, e.g.,
[Podman](https://podman.io).

Enter the following command in the root folder of this repo:

```bash
docker build . --tag cpp-dev-docker
```

Refer to Docker's [reference documentation](https://docs.docker.com/reference)
to learn more.
