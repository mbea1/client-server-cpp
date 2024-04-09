#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>

using namespace boost::asio;
using namespace boost::asio::local;

void send_command(char *socket_path, char *command)
{
    io_context io_context;

    stream_protocol::endpoint endpoint(socket_path);
    stream_protocol::socket socket(io_context);
    socket.connect(endpoint);

    boost::system::error_code error;
    write(socket, buffer(command, strlen(command)), error);

    if (error)
    {
        throw boost::system::system_error(error);
    }

    for (;;)
    {
        boost::array<char, 128> response;
        boost::system::error_code error;

        size_t len = socket.read_some(buffer(response), error);

        if (error == error::eof)
        {
            break;
        }
        else if (error)
        {
            throw boost::system::system_error(error);
        }

        std::cout.write(response.data(), len) << std::endl;
    }
}

int main(int argc, char *argv[])
{

    if (argc < 3)
    {
        std::cerr << "Usage: " << argv[0] << " UNIX_SOCKET_PATH COMMAND" << std::endl;
        return 1;
    }

    auto socket_path = argv[1];
    auto command = argv[2];

    try
    {
        send_command(socket_path, command);
    }
    catch (std::exception &e)
    {
        std::cerr << e.what() << std::endl;
        return 1;
    }

    return 0;
}
