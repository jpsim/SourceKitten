FROM ubuntu:16.04
MAINTAINER JP Simard <jp@jpsim.com>

# Install Dependencies

RUN apt-get update && \
    apt-get install -y \
      autoconf \
      clang \
      cmake \
      git \
      icu-devtools \
      libblocksruntime-dev \
      libbsd-dev \
      libedit-dev \
      libicu-dev \
      libkqueue-dev \
      libncurses5-dev \
      libpython-dev \
      libsqlite3-dev \
      libtool \
      libxml2-dev \
      ninja-build \
      pkg-config \
      python \
      swig \
      uuid-dev

# Clone & Check Out

RUN mkdir swift-development
WORKDIR swift-development
RUN git clone https://github.com/apple/swift.git
WORKDIR swift
RUN utils/update-checkout --clone --branch=swift-3.0-preview-3-branch
RUN cd ../swift-corelibs-libdispatch && \
    git checkout 02da60f && \
    git submodule update --init

# Build Toolchain

RUN utils/build-toolchain local.swift

# Build With Dispatch

RUN utils/build-script
RUN utils/build-script --libdispatch

# Build Swift With SourceKit

RUN rm /swift-development/build/Ninja-DebugAssert/swift-linux-x86_64/CMakeCache.txt
RUN git remote add jpsim https://github.com/jpsim/swift.git && \
    git fetch jpsim && \
    git checkout swift-3.0-preview-3-branch-sourcekit-linux
RUN utils/build-script --libdispatch

# Set Environment Variables

ENV PATH="/swift-development/build/buildbot_linux/none-swift_package_sandbox_linux-x86_64/usr/bin:$PATH"
ENV LINUX_SOURCEKIT_LIB_PATH="/swift-development/build/Ninja-DebugAssert/swift-linux-x86_64/lib"
