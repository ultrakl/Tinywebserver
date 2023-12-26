# set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
# find_package(MySQL REQUIRED)

# # add_library(CGImysql SHARED sql_connection_pool.cpp)
# # target_link_libraries(CGImysql PRIVATE ${MYSQL_LIBRARIES})

# # include(${PROJECT_SOURCE_DIR}/cmake/MacroPushRequiredVars.cmake)
# # include(${PROJECT_SOURCE_DIR}/cmake/FindMySQL.cmake)

# # ...

# add_library(CGImysql sql_connection_pool.cpp)
# if(MYSQL_FOUND)
#     include_directories(${MYSQL_INCLUDE_DIR})
#     target_link_libraries(CGImysql ${MYSQL_LIBRARIES})
# else()
#     message(FATAL_ERROR "MySQL not found. Please install or specify the path.")
# endif()


include(FindPkgConfig)
pkg_check_modules(LIBMYSQLCLIENT REQUIRED mysqlclient)
 
link_directories(${LIBMYSQLCLIENT_LIBRARY_DIRS})
 
# add_executable(hello hello.c)
add_library(CGImysql sql_connection_pool.cpp)
target_include_directories(CGImysql PRIVATE ${LIBMYSQLCLIENT_INCLUDE_DIRS})
target_link_libraries(CGImysql PRIVATE ${LIBMYSQLCLIENT_LIBRARIES})