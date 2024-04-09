cmake_minimum_required(VERSION 3.14.0)
project(client-server-cpp VERSION 0.1.0 LANGUAGES C CXX)

execute_process(
  COMMAND git rev-parse HEAD
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_COMMIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

file(WRITE ${CMAKE_SOURCE_DIR}/src/build.gen.hpp "#pragma once\n\nstatic const char *GIT_COMMIT_HASH = \"${GIT_COMMIT_HASH}\";")

add_executable(client src/client.cpp)
add_executable(server src/server.cpp)

include(cmake/CPM.cmake)

CPMAddPackage(
  NAME Boost
  VERSION 1.84.0
  URL https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.xz
  URL_HASH SHA256=2e64e5d79a738d0fa6fb546c6e5c2bd28f88d268a2a080546f74e5ff98f29d0e
  OPTIONS "BOOST_ENABLE_CMAKE ON" "BOOST_INCLUDE_LIBRARIES asio"
)

target_link_libraries(client PRIVATE Boost::asio)
target_link_libraries(server PRIVATE Boost::asio)
