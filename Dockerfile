FROM ubuntu:15.10
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
      uuid-dev \
      && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR swift-development

# Clone & Check Out
RUN git clone https://github.com/apple/swift.git && \
    cd swift && \
      utils/update-checkout --clone && \

# Build With Dispatch
      utils/build-script --libdispatch && \

# Build With SourceKit
      rm /swift-development/build/Ninja-DebugAssert/swift-linux-x86_64/CMakeCache.txt && \
      utils/build-script --libdispatch --extra-cmake-options="-DSWIFT_BUILD_SOURCEKIT:BOOL=TRUE" && \

# Build Toolchain
      utils/build-toolchain local.swift && \

# Clean Up
    cd .. && \
      mv build /tmp && \
      rm -rf * && \
      mv /tmp/build . && \
      cd build/buildbot_linux && \
        mv none-swift_package_sandbox_linux-x86_64 /tmp && \
        rm -rf * && \
        mv /tmp/none-swift_package_sandbox_linux-x86_64 . && \
        rm -rf none-swift_package_sandbox_linux-x86_64/tests && \
    cd /swift-development/build && \
      mkdir -p Ninja-DebugAssert.tmp/libdispatch-linux-x86_64/src/.libs Ninja-DebugAssert.tmp/swift-linux-x86_64/lib && \
      mv Ninja-DebugAssert/libdispatch-linux-x86_64/src/.libs/libdispatch.so Ninja-DebugAssert.tmp/libdispatch-linux-x86_64/src/.libs/libdispatch.so && \
      mv Ninja-DebugAssert/swift-linux-x86_64/lib/libsourcekitdInProc.so Ninja-DebugAssert.tmp/swift-linux-x86_64/lib/libsourcekitdInProc.so && \
      rm -rf Ninja-DebugAssert && \
      mv Ninja-DebugAssert.tmp Ninja-DebugAssert

# Set Environment Variables
ENV PATH="/swift-development/build/buildbot_linux/none-swift_package_sandbox_linux-x86_64/usr/bin:$PATH"
ENV LINUX_SOURCEKIT_LIB_PATH="/swift-development/build/Ninja-DebugAssert/swift-linux-x86_64/lib"
