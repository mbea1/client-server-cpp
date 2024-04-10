# client-server-cpp

Client and server communicating over a Unix domain socket.

## Building and running the production images

At the root of this project is a [Dockerfile](Dockerfile) used to build the production container images of the client and the server. These production container images aim to be as small as possible using a [distroless image](https://github.com/GoogleContainerTools/distroless) as a base layer.

The [Dockerfile](Dockerfile) is a multi-stage Dockerfile, i.e. it has multiple `FROM` statements. It has two main stages: one stage for preparing the build environment and compiling the applications from source (the `build` stage), and one output stage for copying the compiled binaries into the final distroless container image. This final stage can either prepare the server image (the `server` stage) or prepare the client image (the `client` stage). Choosing which final stage to use (and thus which production image to build) is done with the `--target` argument.

This Dockerfile is also multi-platform aware. It supports building for both the `linux/amd64` (`x86_64`) and `linux/arm64` (`aarch64`) platforms. Building for a specific platform is done through cross-compilation (i.e. no emulation is needed). Depending on the chosen platform, the production images will also be tagged with the right architecture (which can be checked with the `docker inspect` command). Choosing the platform to build for is done with the `--platform` argument.

> Note: The following commands were tested with Docker Engine version 26.0.0. They need to be executed **outside** of the dev environment container. If you are simply looking for coding/testing/compiling as a developer, take a look at [this section about developing inside the dev container environment](#for-developers).

### Build and run for x86_64

```shell
# Build the server image with tag "server" for platform "linux/amd64"
docker build --platform=linux/amd64 --target server -t server .

# Build the client image with tag "client" for platform "linux/amd64"
docker build --platform=linux/amd64 --target client -t client .
```

Once the images are built, the containers can be run in the following way. Note that we create a named volume `tmp` that is mounted inside both containers so that the UNIX socket can be shared between the two.

```shell
# Run the server image in background
docker run -d -v tmp:/tmp server /tmp/server.sock

# Run the client image
docker run -it --rm -v tmp:/tmp client /tmp/server.sock ALLO
docker run -it --rm -v tmp:/tmp client /tmp/server.sock VERSION
```

### Build and run for aarch64

```shell
# Build the server image with tag "server-arm64" for platform "linux/arm64"
docker build --platform=linux/arm64 --target server -t server-arm64 .

# Build the client image with tag "client-arm64" for platform "linux/arm64"
docker build --platform=linux/arm64 --target client -t client-arm64 .
```

```shell
# Run the server image in background
docker run -d -v tmp:/tmp server-arm64 /tmp/server.sock

# Run the client image
docker run -it --rm -v tmp:/tmp client-arm64 /tmp/server.sock ALLO
docker run -it --rm -v tmp:/tmp client-arm64 /tmp/server.sock VERSION
```

## For developers

Development for **client-server-cpp** is simplified by using a containerized development environment. By using the [Visual Studio Code](https://code.visualstudio.com/) editor and the _Remote - Containers_ extension (`ms-vscode-remote.remote-containers`), it is easy to get started with development. Simply open the editor and you should be prompted to open the workspace in a Docker container already set up with all the development and build dependencies. For more information, see the [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) and [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) files. You can also read the Visual Studio Code documentation on [developing inside a container](https://code.visualstudio.com/docs/remote/containers).

The development container comes built-in with two glibc toolchains, one for `x86_64` and one for `aarch64`, both located under `/toolchains`. More toolchains can easily be added if needed. Some CMake presets were created to build the applications using one of the available toolchains.

> Note: Launching the development container for the first time can be a bit long, because it needs to build the image from [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile), which pulls the base layer, installs dependencies, downloads the toolchains, etc. Subsequent launches will be pretty much instantaneous.

Once you are inside the container, you can build and run the application in the following way:

### Build and run for x86_64

```shell
# Build
cmake --preset=x86_64
cmake --build build-x86_64

# Run
build-x86_64/server /tmp/server.sock &
build-x86_64/client /tmp/server.sock VERSION
```

### Build and run for x86_64 in release

```shell
# Build
cmake --preset=x86_64-release
cmake --build build-x86_64-release

# Run
build-x86_64-release/server /tmp/server.sock &
build-x86_64-release/client /tmp/server.sock VERSION
```

### Build and run for aarch64

```shell
# Build
cmake --preset=aarch64
cmake --build build-aarch64

# Run
build-aarch64/server /tmp/server.sock &
build-aarch64/client /tmp/server.sock VERSION
```

### Build and run for aarch64 in release

```shell
# Build
cmake --preset=aarch64-release
cmake --build build-aarch64-release

build-aarch64-release/server /tmp/server.sock &
build-aarch64-release/client /tmp/server.sock VERSION
```
