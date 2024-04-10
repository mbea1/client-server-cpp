FROM --platform=$BUILDPLATFORM debian:12.5 as build

ARG TARGETARCH
ARG BUILDARCH
ARG USER=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG CMAKE_VERSION=3.29.1
ARG BOOTLIN_TOOLCHAINS_URL=https://toolchains.bootlin.com/downloads/releases/toolchains
ARG BOOTLIN_TOOLCHAINS_VERSION=2024.02-1

RUN \
  # Handle target architecture mappings
  case "$TARGETARCH" in \
  arm64) export ARCH="aarch64"; export BOOTLIN_ARCH="aarch64" ;; \
  amd64) export ARCH="x86_64"; export BOOTLIN_ARCH="x86-64" ;; \
  *) echo "Unsupported architecture!"; exit 1 ;; \
  esac && \
  echo $ARCH > /ARCH && \
  # Handle build architecture mappings
  case "$BUILDARCH" in \
  arm64) export CMAKE_ARCH="aarch64" ;; \
  *) export CMAKE_ARCH="x86_64" ;; \
  esac && \
  # Add additional packages
  apt-get update && \
  apt-get -y install sudo git socat curl bzip2 make && \
  # Install CMake
  mkdir -p /opt/cmake && \
  curl -L https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${CMAKE_ARCH}.sh -o /tmp/cmake-install.sh && \
  sh /tmp/cmake-install.sh --prefix=/opt/cmake --skip-license && \
  ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake && \
  ln -s /opt/cmake/bin/ctest /usr/local/bin/ctest && \
  # Install toolchains
  mkdir -p /toolchains && \
  curl -L ${BOOTLIN_TOOLCHAINS_URL}/${BOOTLIN_ARCH}/tarballs/${BOOTLIN_ARCH}--glibc--stable-${BOOTLIN_TOOLCHAINS_VERSION}.tar.bz2 -o /tmp/toolchain.bz2 && \
  tar -xvjf /tmp/toolchain.bz2 -C /toolchains && \
  mv /toolchains/${BOOTLIN_ARCH}--glibc--stable-${BOOTLIN_TOOLCHAINS_VERSION} /toolchains/${ARCH}-glibc && \
  # Add non-root user
  groupadd --gid $USER_GID $USER && \
  useradd -s /bin/bash --uid $USER_UID --gid $USER -m $USER --create-home && \
  usermod -a -G sudo $USER && \
  echo "$USER ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USER
COPY --chown=$USER:$USER . /build
WORKDIR /build

RUN \
  ARCH=$(cat /ARCH) && \
  cmake --preset=${ARCH}-release && \
  cmake --build build-${ARCH}-release && \
  cp build-${ARCH}-release/client build-${ARCH}-release/server .

FROM gcr.io/distroless/cc-debian12:nonroot-${TARGETARCH} AS client
ENV PATH=/app:$PATH
WORKDIR /app
COPY --from=build /build/client ./
ENTRYPOINT [ "client" ]

FROM gcr.io/distroless/cc-debian12:nonroot-${TARGETARCH} AS server
ENV PATH=/app:$PATH
WORKDIR /app
COPY --from=build /build/server ./
ENTRYPOINT [ "server" ]
