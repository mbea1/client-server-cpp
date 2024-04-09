# client-server-cpp

Client and server implementations communicating over a Unix domain socket.

## Building and running the production image

> TODO

## For developers

### Dev environment

Development for **client-server-cpp** is simplified by using a containerized development environment. By using the [Visual Studio Code](https://code.visualstudio.com/) editor and the _Remote - Containers_ extension (`ms-vscode-remote.remote-containers`), it is easy to get started with development. Simply open the editor and you should be prompted to open the workspace in a Docker container already set up with all the development and build dependencies. For more information, see the `Dockerfile` and `devcontainer.json` files under `/.devcontainer`. You can also read the Visual Studio Code documentation on [developing inside a container](https://code.visualstudio.com/docs/remote/containers).

Once you are within the container, you can build the application in the following way:

### Build for x86_64

```shell
cmake --preset=x86_64
cmake --build build-x86_64
```

### Build for aarch64

```shell
cmake --preset=aarch64
cmake --build build-aarch64
```
