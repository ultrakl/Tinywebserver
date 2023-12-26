# set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
# find_package(MySQL REQUIRED)
# # include(${PROJECT_SOURCE_DIR}/cmake/MacroPushRequiredVars.cmake)
# # include(${PROJECT_SOURCE_DIR}/cmake/FindMySQL.cmake)

# # ...

# add_library(http_conn http_conn.cpp)
# if(MYSQL_FOUND)
#     include_directories(${MYSQL_INCLUDE_DIR})
#     target_link_libraries(http_conn ${MYSQL_LIBRARIES})
# else()
#     message(FATAL_ERROR "MySQL not found. Please install or specify the path.")
# endif()

# # target_link_libraries(http_conn PRIVATE ${MYSQL_LIBRARIES})


include(FindPkgConfig)
pkg_check_modules(LIBMYSQLCLIENT REQUIRED mysqlclient)
 
link_directories(${LIBMYSQLCLIENT_LIBRARY_DIRS})
 
# add_executable(hello hello.c)
add_library(http_conn http_conn.cpp)
target_include_directories(http_conn PRIVATE ${LIBMYSQLCLIENT_INCLUDE_DIRS})
target_link_libraries(http_conn PRIVATE ${LIBMYSQLCLIENT_LIBRARIES})