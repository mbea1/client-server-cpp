cmake_minimum_required(VERSION 3.14.0)
project(client-server-cpp VERSION 0.1.0 LANGUAGES C CXX)

add_executable(client src/client.cpp)
add_executable(server src/server.cpp)
