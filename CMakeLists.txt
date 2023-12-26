cmake_minimum_required(VERSION 3.16)
project(tinywebserver VERSION 0.1.0 LANGUAGES C CXX)
#[[
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_CXX_STANDARD 17)]]#
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
find_package(MariaDBClient REQUIRED)
# message("LOOK HERE " ${CMAKE_MOUDLE_PATH})

# add_subdirectory(CGImysql)
# add_subdirectory(http)
# add_subdirectory(timer)
# add_subdirectory(log)

add_executable(tinywebserver main.cpp webserver.cpp config.cpp ./timer/lst_timer.cpp ./http/http_conn.cpp ./log/log.cpp ./CGImysql/sql_connection_pool.cpp)

# target_link_libraries(tinywebserver lst_timer http_conn log CGImysql)
message("value: ${MariaDBClient_LIBRARY}")
target_include_directories(tinywebserver PUBLIC ${MariaDBClient_INCLUDE_DIRS})
target_link_libraries(tinywebserver PUBLIC ${MariaDBClient_LIBRARY})

#[[if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include(CTest)
endif()

enable_testing()

add_test(NAME tinywebserver COMMAND tinywebserver 172.18.114.127 12345)]]#
