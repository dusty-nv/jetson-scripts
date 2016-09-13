# Building OpenCV for Tegra with CUDA

* Document author: [Randy J. Ray](mailto:rjray@nvidia.com)
* Last updated: 2016-09-07

## This Document

What this document is: This document is a basic guide to building the OpenCV libraries with CUDA support for use in the Tegra environment. It will cover the basic elements of building the version 3.1.0 libraries from source code for four different platforms:

* Vibrante4Linux Drive PX2 (V4L)
* Linux4Tegra Jetson (L4T)
* Desktop Linux (Ubuntu 14.04LTS and 16.04LTS)
* Microsoft Windows (8)

What this document is not: This document is not an exhaustive guide to all of the options available when building OpenCV. Specifically, it will cover the basic options used when building each platform but will not cover any options that are not needed (or are unchanged from their default values). Additionally, the installation of the CUDA toolkit is not covered here.

This document is focused on building the 3.1.0 version of OpenCV, but the guidelines here should also work for building from the "master" branch of the git repository. There are differences in some of the CMake options for builds of the 2.4.13 version of OpenCV, which are summarized below in the "Building OpenCV 2.4.X" section.

Most of the configuration commands are based on the system having CUDA 8.0 installed. In some cases, an older CUDA is used because 8.0 is not supported for that platform.

## Native Compilation vs. Cross-Compilation

The OpenCV build system supports native compilation for all the supported platforms, as well as cross-compilation for platforms such as ARM and others. The native compilation process is simpler, whereas the cross-compilation is generally faster.

At the present time, this document will focus only on native compilation.

## Getting the Source Code

There are two ways to get the OpenCV source code: direct download from the [OpenCV downloads](http://opencv.org/downloads.html) page, or by cloning the git repositories hosted on [GitHub](https://github.com/opencv).

For this guide, the focus will be on using the git repositories. This is because the 3.1.0 version of OpenCV will not build with CUDA 8.0 without applying a small upstream change from the repository.

### OpenCV

Start with the `opencv` repository:

    # Clone the opencv repository locally:
    $ git clone https://github.com/opencv/opencv.git

To build the 3.1.0 version (as opposed to building the most-recent source), you will need to check out a branch based on the `3.1.0` tag:

    $ cd opencv
    $ git checkout -b v3.1.0 3.1.0

Note that this operation will create a new local branch in your clone's repository.

If you will be building OpenCV with CUDA 8.0, you will need to execute one additional git command. This is to apply a fix for building specifically with the 8.0 version of CUDA that was not part of the 3.1.0 release. To do this, you will use the "git cherry-pick" command:

    # While still in the opencv directory:
    $ git cherry-pick 10896

You should see the following output from the command:

    [v3.1.0 d6d69a7] GraphCut deprecated in CUDA 7.5 and removed in 8.0
     Author: Vladislav Vinogradov <vlad.vinogradov@itseez.com>
     1 file changed, 2 insertions(+), 1 deletion(-)

This step is not needed if you are building with CUDA 7.0 or 7.5.

### OpenCV Extra

The `opencv_extra` repository contains extra data for the OpenCV library, including the data files used by the tests and demos. It must be cloned separately:

    # In the same base directory from which you cloned opencv:
    $ git clone https://github.com/opencv/opencv_extra.git

As with the OpenCV source you will need to use the same method as above to set the source tree to the 3.1.0 version. When you are building from a specific tag, both repositories should be checked out at that tag.

    $ cd opencv_extra
    $ git checkout -b v3.1.0 3.1.0

You may opt to not fetch this repository if you do not plan on running the tests or installing the test-data along with the samples and example programs. If it is not referenced in the invocation of CMake or the running of tests, it will not be used. Note that some tests expect the data to be present, and will fail without it.

### Building on Microsoft Windows

If you are building 3.1.0 on a Microsoft Windows platform, there is one additional step needed. The Windows build includes the `opencv_world` module, which fails to build at the 3.1.0 tag. Run the following command in the directory of the `opencv` repository:

    C:\opencv-build\opencv>git cherry-pick c8ff7

You should see output like this from the command:

    [v3.1.0 fdf6d4b] build: fix opencv_world with CUDA
     Author: Alexander Alekhin <alexander.alekhin@itseez.com>
     4 files changed, 9 insertions(+), 19 deletions(-)

This is not necessary for any of the other platforms, as they do not use the `opencv_world` module.

## Preparation and Prerequisites

To build OpenCV, you will need a directory in which to create the configuration and build the libraries. You will also need a number of 3rd-party libraries upon which OpenCV depends.

### Prerequisites for Ubuntu Linux

These are the basic requirements for building OpenCV for Tegra on Linux:

* CMake 2.8.10 or newer
* CUDA toolkit 7.0 or newer
* Build tools (make, gcc, g++)
* Python 2.6 or greater

These are the same regardless of the platform (Drive PX2, Desktop, etc.).

A number of development packages are required for building on Linux:

* libglew-dev
* libtiff5-dev
* zlib1g-dev
* libjpeg-dev
* libpng12-dev
* libjasper-dev
* libavcodec-dev
* libavformat-dev
* libavutil-dev
* libpostproc-dev
* libswscale-dev
* libeigen3-dev
* libtbb-dev
* libgtk2.0-dev
* pkg-config

Some of the packages above are in the `universe` repository for Ubuntu Linux systems. If you have not already enabled that repository, you will need to do the following before trying to install all of the packages listed above:

    sudo apt-add-repository universe
    sudo apt-get update

If you want the Python bindings to be built, you will also need the appropriate packages for either or both of Python 2 and Python 3:

* python-dev / python3-dev
* python-numpy / python3-numpy
* python-py / python3-py
* python-pytest / python3-pytest

Once all the necessary packages have been installed, you can configure the build.

### Prerequisites for Microsoft Windows

### Preparing the build area

For configuring and building OpenCV, create a directory called "build" in the same base directory into which you cloned the git repositories:

    $ mkdir build
    $ cd build

You are now ready to configure and build OpenCV.

## Vibrante V4L Compilation

> Supported platform: Drive PX2

The configuration options given to `cmake` below are targeted towards the functionality needed for Tegra. They are based on the original configuration options used for building OpenCV 2.4.13.

### Configuring

The build of OpenCV is configured with CMake. If run with no parameters, it will detect most of what it needs to know about your system. However, it may have difficulty finding the CUDA files if they are not in a standard location, and it may try to build some options that you might otherwise not want included. So the following invocation of CMake is recommended:

    $ cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python2=ON \
        -DBUILD_opencv_python3=OFF \
        -DENABLE_NEON=ON \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
        -DCUDA_ARCH_BIN=6.2 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

(Line-breaks and continuation characters added for readability.)

For a detailed explanation of the parameters passed to `cmake`, see the "CMake Parameter Reference" section, below.

The configuration given above will build the Python bindings for Python 2 (but not Python 3) as part of the build process. If you want the Python 3 bindings (or do not want the Python 2 bindings), change the values of `BUILD_opencv_python2` and/or `BUILD_opencv_python3` as needed. To enable bindings, set the value to `ON`, to disable them set it to `OFF`:

    -DBUILD_opencv_python2=OFF

The last parameter, `OPENCV_TEST_DATA_PATH`, tells the build system where to find the test-data that is provided by the `opencv_extra` repository. When this is included, a `make install` will install this test-data along with the test programs and example code. If you did not clone the `opencv_extra` repository, you should not include this parameter.

### Building

Once the `cmake` command has completed, your `build` directory should be ready to go. You build OpenCV with the standard `make` utility:

    $ make

Depending on the architecture of your desktop, you may wish to allow make to use parallel processing:

    # Execute with as many as 6 jobs in parallel:
    $ make -j6

At the end of the build process, you should have new files in the `lib` and `bin` sub-directories within `build`.

### Testing

The OpenCV package comes with an extensive set of tests. To run the tests, you need only execute:

    $ make test

If you fetched the `opencv_extra` repository for the test data, it will be necessary to specify the path to that test data:

    # For bash:
    $ OPENCV_TEST_DATA_PATH=../opencv_extra/testdata make test

    # For csh/tcsh:
    $ setenv OPENCV_TEST_DATA_PATH ../opencv_extra/testdata
    $ make test

Note that some of the tests are dependent on the test data from `opencv_extra`, and will fail without it.

### Installing

Installing OpenCV requires only the following command:

    # From within the "build" directory:
    $ make install

(It may be necessary to use "sudo" for root privileges, depending on the location being installed to.)

This will install the OpenCV libraries and header files, as well as the tests and samples.

## Jetson L4T Compilation

> Supported platforms: Jetson TK-1, Jetson TX-1

As with V4L, the configuration options given to `cmake` below are targeted towards the functionality needed for Tegra. They are based on the original configuration options used for building OpenCV 2.4.13 on Jetson.

### Configuring

Configuration is slightly different for the Jetson TK-1 and the Jetson TX-1 systems.

#### Jetson TK-1 Configuration

For Jetson TK-1, the following invocation of CMake is recommended:

    $ cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python2=ON \
        -DBUILD_opencv_python3=OFF \
        -DENABLE_NEON=ON \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-6.5 \
        -DCUDA_ARCH_BIN=3.2 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

Note that this uses CUDA 6.5, not 8.0.

#### Jetson TX-1 Configuration

For Jetson TX-1, the following invocation of CMake is recommended:

    $ cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python2=ON \
        -DBUILD_opencv_python3=OFF \
        -DENABLE_PRECOMPILED_HEADERS=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
        -DCUDA_ARCH_BIN=5.3 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

Note that this configuration does not include the `ENABLE_NEON` parameter.

### Building

Once the `cmake` command has completed, your `build` directory should be ready to go:

    $ make -j6

### Testing

The OpenCV package comes with an extensive set of tests. To run the tests, you need only execute:

    $ make test

If you fetched the `opencv_extra` repository for the test data, it will be necessary to specify the path to that test data:

    # For bash:
    $ OPENCV_TEST_DATA_PATH=../opencv_extra/testdata make test

    # For csh/tcsh:
    $ setenv OPENCV_TEST_DATA_PATH ../opencv_extra/testdata
    $ make test

Note that some of the tests are dependent on the test data from `opencv_extra`, and will fail without it.

### Installing

Installing OpenCV requires only:

    # From within the "build" directory:
    $ make install

(It may be necessary to use "sudo" for root privileges, depending on the location being installed to.)

This will install the OpenCV libraries and header files, as well as the tests and samples.

## Ubuntu Desktop Linux Compilation

> Supported platforms: Ubuntu Desktop Linux 14.04LTS, Ubuntu Desktop Linux 16.04LTS

The configuration options given to `cmake` below are targeted towards the functionality needed for Tegra. For a desktop system, you may wish to adjust some options to enable (or disable) certain features. The features enabled below are based on the building of OpenCV 2.4.13.

### Configuring

For Desktop Ubuntu, the recommended invocation of CMake is:

    $ cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python2=ON \
        -DBUILD_opencv_python3=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

This configuration is basically identical to that for V4L and L4T, except that it does not pass the `ENABLE_NEON` or `CUDA_ARCH_BIN` parameters. The `ENABLE_NEON` parameter controls the the use of NEON SIMD extensions. The `CUDA_ARCH_BIN` parameter specifies the CUDA architectures that the installed NVIDIA board supports. For a desktop this is dependent on the card you have installed, so CMake will instead run a small test program that probes for the supported architectures.

As with previous examples, the configuration given above will build the Python bindings for Python 2 (but not Python 3) as part of the build process.

### Building

Building is the same as for the previous examples:

    $ make

As before, you may wish to allow make to use parallel processing:

    # Execute with as many as 7 jobs in parallel:
    $ make -j7

### Testing

Run the tests as in the previous examples:

    $ make test

Or (if you have the test data):

    # For bash:
    $ OPENCV_TEST_DATA_PATH=../opencv_extra/testdata make test

    # For csh/tcsh:
    $ setenv OPENCV_TEST_DATA_PATH ../opencv_extra/testdata
    $ make test

Again, note that some tests are dependent on data from the `opencv_extra` repository.

### Installing

Install as with other examples:

    # From within the "build" directory:
    $ make install

## Microsoft Windows Desktop Compilation

(this section still in development)

### Tools

To build OpenCV with CUDA support, you will need the Microsoft Visual Studio C/C++ compilers. While you can build most of OpenCV with other compilers, code that links with the CUDA libraries must be built with MSVC.

Additionally, building OpenCV on Microsoft Windows uses the [Ninja build tool](https://ninja-build.org/) in conjunction with CMake. You can find a Windows version on their [releases](https://github.com/ninja-build/ninja/releases) page, in the form of a ZIP archive file.

### Configuring

    C:\opencv-build\build>cmake \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DINSTALL_TESTS=ON \
        -DWITH_OPENCL=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_TESTS=ON \
        -DBUILD_opencv_python2=OFF \
        -DBUILD_opencv_python3=OFF \
        -DBUILD_PERF_TESTS=ON \
        -DWITH_FFMPEG=ON \
        -DINSTALL_CREATE_DISTRIB=ON \
        -DENABLE_SSE=ON \
        -DENABLE_SSE2=ON \
        -DWITH_CUDA=ON \
        "-DCUDA_TOOLKIT_ROOT_DIR=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0" \
        -DBUILD_opencv_java=OFF \
        -DWITH_MSMF=OFF \
        -DWITH_TBB=OFF \
        -DWITH_1394=OFF \
        -DWITH_VFW=OFF \
        -DBUILD_DOCS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DWITH_VTK=OFF \
        -DOPENCV_TEST_DATA_PATH=..\opencv_extra\testdata \
        ..\opencv

## Building OpenCV 2.4.X

If you wish to build your own version of the 2.4 version of OpenCV, there are only a few adjustments that need to be made. At the time of writing this, the latest version on the 2.4 tree is 2.4.13. These instructions should work for later versions of 2.4 (though they have not been tested for any earlier versions).

### Selecting the 2.4 source

First you will need to select the correct source branch or tag. If you want a specific version such as 2.4.13, you will want to make a local branch based on the tag, as was done with the 3.1.0 tag above:

    # Within the opencv directory:
    $ git checkout -b v2.4.13 2.4.13

    # Within the opencv_extra directory:
    $ git checkout -b v2.4.13 2.4.13

If you simply want the newest code from the 2.4 line of OpenCV, there is a `2.4` branch already in the repository. You can check that out instead of a specific tag:

    $ git checkout 2.4

### Configuring

Configuring is done with CMake as before. The primary difference is that OpenCV 2.4 only provides Python bindings for Python 2, and thus does not distinguish between Python 2 and Python 3 in the CMake parameters. There is just the one parameter, `BUILD_opencv_python`. In addition, there is a build-related parameter that controls features in 2.4 that are not in 3.1.0. This parameter is `BUILD_opencv_nonfree`.

Configuration still takes place in a separate directory that should be a sibling to the `opencv` and `opencv_extra` directories.

#### Configuring Vibrante V4L

For Drive PX2:

    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_nonfree=OFF \
        -DBUILD_opencv_python=ON \
        -DENABLE_NEON=ON \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
        -DCUDA_ARCH_BIN=6.2 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

#### Configuring Jetson L4T

For Jetson TK-1:

    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_nonfree=OFF \
        -DBUILD_opencv_python=ON \
        -DENABLE_NEON=ON \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-6.5 \
        -DCUDA_ARCH_BIN=3.2 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

For Jetson TX-1:

    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_nonfree=OFF \
        -DBUILD_opencv_python=ON \
        -DENABLE_PRECOMPILED_HEADERS=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
        -DCUDA_ARCH_BIN=5.3 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

#### Configuring Desktop Ubuntu Linux

For both of 14.04LTS and 16.04LTS:

    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_nonfree=OFF \
        -DBUILD_opencv_python=ON \
        -DWITH_OPENCL=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=ON \
        -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
        ../opencv

#### Configuring Microsoft Windows

For Windows:

    cmake \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DINSTALL_TESTS=ON \
        -DWITH_OPENCL=OFF \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_TESTS=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_nonfree=OFF \
        -DBUILD_opencv_python=OFF \
        -DBUILD_PERF_TESTS=ON \
        -DWITH_FFMPEG=ON \
        -DINSTALL_CREATE_DISTRIB=ON \
        -DENABLE_SSE=ON \
        -DENABLE_SSE2=ON \
        -DWITH_CUDA=ON \
        "-DCUDA_TOOLKIT_ROOT_DIR=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0" \
        -DWITH_MSMF=OFF \
        -DWITH_TBB=OFF \
        -DWITH_1394=OFF \
        -DWITH_VFW=OFF \
        -DBUILD_DOCS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DWITH_VTK=OFF \
        -DOPENCV_TEST_DATA_PATH=..\opencv_extra\testdata \
        ..\opencv

### Building, Testing and Installing

Once configured, the steps of building, testing and installing should be the same as above for the 3.1.0 source.

## CMake Parameter Reference

Below is a table of all the parameters passed to CMake in the recommended invocations above. Some of these are parameters from CMake itself, while most are specific to OpenCV.

|Parameter|Our default value|What it does|Notes|
|---------|-----------------|------------|-----|
|BUILD_EXAMPLES|ON|Governs whether the C/C++ examples are built||
|BUILD_JASPER|OFF|Governs whether the Jasper library (`libjasper`) is built from source in the `3rdparty` directory||
|BUILD_JPEG|OFF|As above, for `libjpeg`||
|BUILD_PNG|OFF|As above, for `libpng`||
|BUILD_TBB|OFF|As above, for `tbb`||
|BUILD_TIFF|OFF|As above, for `libtiff`||
|BUILD_ZLIB|OFF|As above, for `zlib`||
|BUILD_opencv_java|OFF|Controls the building of the Java bindings for OpenCV|Building the Java bindings requires OpenCV libraries be built for static linking only|
|BUILD_opencv_nonfree|OFF|Controls the building of non-free (non-open-source) elements|Used only for building 2.4.X|
|BUILD_opencv_python|ON|Controls the building of the Python 2 bindings in OpenCV 2.4.X|Used only for building 2.4.X|
|BUILD_opencv_python2|ON|Controls the building of the Python 2 bindings in OpenCV 3.1.0|Not used in 2.4.X|
|BUILD_opencv_python3|OFF|Controls the building of the Python 3 bindings in OpenCV 3.1.0|Not used in 2.4.X|
|CMAKE_BUILD_TYPE|Release|Selects the type of build (release vs. development)|Is generally either `Release` or `Debug`|
|CMAKE_INSTALL_PREFIX|/usr|Sets the root for installation of the libraries and header files||
|CUDA_ARCH_BIN|(varies)|Sets the CUDA architecture(s) for which code is compiled|Only passed for platforms with known specific cards|
|CUDA_ARCH_PTX|""|Specify virtual PTX architectures to build PTX intermediate code for|Here, used only for Microsoft Windows|
|CUDA_TOOLKIT_ROOT_DIR|/usr/local/cuda-8.0 (for Linux)|Specifies the location of the CUDA include files and libraries||
|ENABLE_NEON|ON|Enables the use of NEON SIMD extentions for ARM chips|Only passed for builds on ARM platforms|
|ENABLE_PRECOMPILED_HEADERS|OFF|Enable/disable support for pre-compiled headers|Only specified on some of the ARM platforms|
|INSTALL_C_EXAMPLES|ON|Enables the installation of the C example files as part of `make install`||
|INSTALL_TESTS|ON|Enables the installation of the tests as part of `make install`||
|OPENCV_TEST_DATA_PATH|../opencv_extra/testdata|Path to the `testdata` directory in the `opencv_extra` repository clone||
|WITH_1394|OFF|Whether to include IEEE-1394 support||
|WITH_CUDA|ON|Whether to include CUDA support||
|WITH_FFMPEG|ON|Whether to include FFMPEG support||
|WITH_GSTREAMER|OFF|Whether to include GStreamer 1.0 support||
|WITH_GSTREAMER_0_10|OFF|Whether to include GStreamer 0.10 support||
|WITH_GTK|ON|Whether to include GTK 2.0 support|Only given on Linux platforms, not Microsoft Windows|
|WITH_OPENCL|OFF|Whether to include OpenCL Runtime support||
|WITH_OPENEXR|OFF|Whether to include ILM support via OpenEXR||
|WITH_TBB|ON|Whether to include Intel TBB support||
|WITH_VTK|OFF|Whether to include VTK support||
