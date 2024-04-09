# client-server-cpp

Client and server communicating over a Unix domain socket.

## Building and running the production image

> TODO

## For developers

Development for **client-server-cpp** is simplified by using a containerized development environment. By using the [Visual Studio Code](https://code.visualstudio.com/) editor and the _Remote - Containers_ extension (`ms-vscode-remote.remote-containers`), it is easy to get started with development. Simply open the editor and you should be prompted to open the workspace in a Docker container already set up with all the development and build dependencies. For more information, see the [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) and [`.devcontainer/devcontainer.json`](.devcontainer/devcontainer.json) files. You can also read the Visual Studio Code documentation on [developing inside a container](https://code.visualstudio.com/docs/remote/containers).

The development container comes built-in with two glibc toolchains, one for x86_64 and one for aarch64, both located under `/toolchains`. More toolchains can easily be added if needed. Some CMake presets were created to build the applications using one of the available toolchains.

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
