#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
#include "build.gen.hpp"

using namespace boost::asio;
using namespace boost::asio::local;

namespace commands
{
    static const char *VERSION = "VERSION";
}

namespace responses
{
    static const char *VERSION = GIT_COMMIT_HASH;
    static const char *REJECTED = "REJECTED";
}

void receive_commands(char *socket_path)
{
    unlink(socket_path);

    io_context io_context;

    stream_protocol::endpoint endpoint(socket_path);
    stream_protocol::acceptor acceptor(io_context, endpoint);

    for (;;)
    {
        stream_protocol::socket socket(io_context);
        acceptor.accept(socket);

        boost::array<char, 128> command;
        boost::system::error_code error;
        size_t len = socket.read_some(buffer(command), error);

        if (error)
        {
            throw boost::system::system_error(error);
        }

        if (memcmp(command.data(), commands::VERSION, len) == 0)
        {
            write(socket, buffer(responses::VERSION, strlen(responses::VERSION)), error);
        }
        else
        {
            write(socket, buffer(responses::REJECTED, strlen(responses::REJECTED)), error);
        }

        if (error)
        {
            throw boost::system::system_error(error);
        }
    }
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        std::cerr << "Usage: " << argv[0] << " UNIX_SOCKET_PATH" << std::endl;
        return 1;
    }

    auto socket_path = argv[1];

    try
    {
        receive_commands(socket_path);
    }
    catch (std::exception &e)
    {
        std::cerr << e.what() << std::endl;
        return 1;
    }

    return 0;
}
