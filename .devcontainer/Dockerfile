FROM debian:12.5

ARG USER=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG CMAKE_VERSION=3.29.1
ARG BOOTLIN_TOOLCHAINS_URL=https://toolchains.bootlin.com/downloads/releases/toolchains
ARG BOOTLIN_TOOLCHAINS_VERSION=2024.02-1

RUN \
  # Add additional packages
  apt-get update && \
  apt-get -y install sudo git socat curl bzip2 make && \
  # Install CMake
  mkdir -p /opt/cmake && \
  curl -L https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh -o /tmp/cmake-install.sh && \
  sh /tmp/cmake-install.sh --prefix=/opt/cmake --skip-license && \
  ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake && \
  ln -s /opt/cmake/bin/ctest /usr/local/bin/ctest && \
  # Install toolchains
  mkdir -p /toolchains && \
  # - x86_64 glibc
  curl -L ${BOOTLIN_TOOLCHAINS_URL}/x86-64/tarballs/x86-64--glibc--stable-${BOOTLIN_TOOLCHAINS_VERSION}.tar.bz2 -o /tmp/toolchain.bz2 && \
  tar -xvjf /tmp/toolchain.bz2 -C /toolchains && \
  mv /toolchains/x86-64--glibc--stable-${BOOTLIN_TOOLCHAINS_VERSION} /toolchains/x86_64-glibc && \
  # - aarch64 glibc
  curl -L ${BOOTLIN_TOOLCHAINS_URL}/aarch64/tarballs/aarch64--glibc--stable-${BOOTLIN_TOOLCHAINS_VERSION}.tar.bz2 -o /tmp/toolchain.bz2 && \
  tar -xvjf /tmp/toolchain.bz2 -C /toolchains && \
  mv /toolchains/aarch64--glibc--stable-${BOOTLIN_TOOLCHAINS_VERSION} /toolchains/aarch64-glibc && \
  # Add non-root user
  groupadd --gid $USER_GID $USER && \
  useradd -s /bin/bash --uid $USER_UID --gid $USER -m $USER --create-home && \
  usermod -a -G sudo $USER && \
  echo "$USER ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  # Clean up
  apt-get clean && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt
