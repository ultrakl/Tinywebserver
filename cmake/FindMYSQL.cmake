# # - Try to find MySQL / MySQL Embedded library
# # Find the MySQL includes and client library
# # This module defines
# #  MYSQL_INCLUDE_DIR, where to find mysql.h
# #  MYSQL_LIBRARIES, the libraries needed to use MySQL.
# #  MYSQL_LIB_DIR, path to the MYSQL_LIBRARIES
# #  MYSQL_EMBEDDED_LIBRARIES, the libraries needed to use MySQL Embedded.
# #  MYSQL_EMBEDDED_LIB_DIR, path to the MYSQL_EMBEDDED_LIBRARIES
# #  MySQL_FOUND, If false, do not try to use MySQL.
# #  MySQL_Embedded_FOUND, If false, do not try to use MySQL Embedded.

# # Copyright (c) 2006-2008, Jarosław Staniek <staniek@kde.org>
# #
# # Redistribution and use is allowed according to the terms of the BSD license.
# # For details see the accompanying COPYING-CMAKE-SCRIPTS file.

# include(CheckCXXSourceCompiles)
# include(MacroPushRequiredVars)
# include(FeatureSummary)
# set_package_properties(MySQL PROPERTIES
#     DESCRIPTION "MySQL Client Library (libmysqlclient)" URL "http://www.mysql.com")

# if(WIN32)
#    find_path(MYSQL_INCLUDE_DIR mysql.h
#       PATHS
#       $ENV{MYSQL_INCLUDE_DIR}
#       $ENV{MYSQL_DIR}/include/mysql
#       $ENV{ProgramW6432}/MySQL/*/include/mysql
#       $ENV{ProgramFiles}/MySQL/*/include/mysql
#       $ENV{SystemDrive}/MySQL/*/include/mysql
#       $ENV{ProgramW6432}/*/include/mysql # MariaDB
#       $ENV{ProgramFiles}/*/include/mysql # MariaDB
#    )
# else()
#    # use pkg-config to get the directories and then use these values
#    # in the FIND_PATH() and FIND_LIBRARY() calls
#    find_package(PkgConfig)
#    pkg_check_modules(PC_MYSQL QUIET mysql mariadb)
#    if(PC_MYSQL_VERSION)
#        set(MySQL_VERSION_STRING ${PC_MYSQL_VERSION})
#    endif()

#    find_path(MYSQL_INCLUDE_DIR mysql.h
#       PATHS
#       $ENV{MYSQL_INCLUDE_DIR}
#       $ENV{MYSQL_DIR}/include
#       ${PC_MYSQL_INCLUDEDIR}
#       ${PC_MYSQL_INCLUDE_DIRS}
#       /usr/local/mysql/include
#       /opt/mysql/mysql/include
#       PATH_SUFFIXES
#       mysql
#    )
# endif()

# if(WIN32)
#    string(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)

#    # path suffix for debug/release mode
#    # binary_dist: mysql binary distribution
#    # build_dist: custom build
#    if(CMAKE_BUILD_TYPE_TOLOWER MATCHES "debug")
#       set(binary_dist debug)
#       set(build_dist Debug)
#    else()
#       add_definitions(-DDBUG_OFF)
#       set(binary_dist opt)
#       set(build_dist Release)
#    endif()

#    set(MYSQL_LIB_PATHS
#       $ENV{MYSQL_DIR}/lib/${binary_dist}
#       $ENV{MYSQL_DIR}/libmysql/${build_dist}
#       $ENV{MYSQL_DIR}/client/${build_dist}
#       $ENV{ProgramW6432}/MySQL/*/lib/${binary_dist}
#       $ENV{ProgramFiles}/MySQL/*/lib/${binary_dist}
#       $ENV{SystemDrive}/MySQL/*/lib/${binary_dist}
#       $ENV{ProgramW6432}/*/lib # MariaDB
#       $ENV{ProgramFiles}/*/lib # MariaDB
#    )
#    find_library(_LIBMYSQL_LIBRARY NAMES libmysql
#       PATHS ${MYSQL_LIB_PATHS}
#    )
#    find_library(_MYSQLCLIENT_LIBRARY NAMES mysqlclient
#       PATHS ${MYSQL_LIB_PATHS}
#    )
#    set(MYSQL_LIBRARIES ${_LIBMYSQL_LIBRARY} ${_MYSQLCLIENT_LIBRARY})
# else()
#    find_library(_MYSQLCLIENT_LIBRARY NAMES mysqlclient
#       PATHS
#       $ENV{MYSQL_DIR}/libmysql_r/.libs
#       $ENV{MYSQL_DIR}/lib
#       $ENV{MYSQL_DIR}/lib/mysql
#       ${PC_MYSQL_LIBDIR}
#       ${PC_MYSQL_LIBRARY_DIRS}
#       PATH_SUFFIXES
#       mysql
#    )
#    set(MYSQL_LIBRARIES ${_MYSQLCLIENT_LIBRARY})
# endif()

# if(_LIBMYSQL_LIBRARY)
#    get_filename_component(MYSQL_LIB_DIR ${_LIBMYSQL_LIBRARY} PATH)
#    unset(_LIBMYSQL_LIBRARY)
# endif()
# if(_MYSQLCLIENT_LIBRARY)
#     if(NOT MYSQL_LIB_DIR)
#         get_filename_component(MYSQL_LIB_DIR ${_MYSQLCLIENT_LIBRARY} PATH)
#     endif()
#     unset(_MYSQLCLIENT_LIBRARY)
# endif()

# find_library(MYSQL_EMBEDDED_LIBRARIES NAMES mysqld
#    PATHS
#    ${MYSQL_LIB_PATHS}
# )

# if(MYSQL_EMBEDDED_LIBRARIES)
#    get_filename_component(MYSQL_EMBEDDED_LIB_DIR ${MYSQL_EMBEDDED_LIBRARIES} PATH)

#     macro_push_required_vars()
#     set( CMAKE_REQUIRED_INCLUDES ${MYSQL_INCLUDE_DIR} )
#     set( CMAKE_REQUIRED_LIBRARIES ${MYSQL_EMBEDDED_LIBRARIES} )
#     check_cxx_source_compiles( "#include <mysql.h>\nint main() { int i = MYSQL_OPT_USE_EMBEDDED_CONNECTION; }" HAVE_MYSQL_OPT_EMBEDDED_CONNECTION )
#     macro_pop_required_vars()
# endif()

# # Did we find anything?
# include(FindPackageHandleStandardArgs)

# find_package_handle_standard_args(MySQL
#                                   REQUIRED_VARS MYSQL_LIBRARIES MYSQL_INCLUDE_DIR MYSQL_LIB_DIR
#                                   VERSION_VAR MySQL_VERSION_STRING)
# if(MYSQL_EMBEDDED_LIBRARIES AND MYSQL_EMBEDDED_LIB_DIR AND HAVE_MYSQL_OPT_EMBEDDED_CONNECTION)
#     find_package_handle_standard_args(MySQL_Embedded
#                                   REQUIRED_VARS MYSQL_EMBEDDED_LIBRARIES MYSQL_INCLUDE_DIR
#                                                 MYSQL_EMBEDDED_LIB_DIR
#                                                 HAVE_MYSQL_OPT_EMBEDDED_CONNECTION)
# endif()

# mark_as_advanced(MYSQL_INCLUDE_DIR MYSQL_LIBRARIES MYSQL_LIB_DIR
#                  MYSQL_EMBEDDED_LIBRARIES MYSQL_EMBEDDED_LIB_DIR HAVE_MYSQL_OPT_EMBEDDED_CONNECTION)

# --------------------------------------------------------------------------------------------------------

# - Try to find MySQL.
# Once done this will define:
# MYSQL_FOUND			- If false, do not try to use MySQL.
# MYSQL_INCLUDE_DIRS	- Where to find mysql.h, etc.
# MYSQL_LIBRARIES		- The libraries to link against.
# MYSQL_VERSION_STRING	- Version in a string of MySQL.
#
# Created by RenatoUtsch based on eAthena implementation.
#
# Please note that this module only supports Windows and Linux officially, but
# should work on all UNIX-like operational systems too.
#

#=============================================================================
# Copyright 2012 RenatoUtsch
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

if( WIN32 )
	find_path( MYSQL_INCLUDE_DIR
		NAMES "mysql.h"
		PATHS "$ENV{PROGRAMFILES}/MySQL/*/include"
			  "$ENV{PROGRAMFILES(x86)}/MySQL/*/include"
			  "$ENV{SYSTEMDRIVE}/MySQL/*/include" )
	
	find_library( MYSQL_LIBRARY
		NAMES "mysqlclient" "mysqlclient_r"
		PATHS "$ENV{PROGRAMFILES}/MySQL/*/lib"
			  "$ENV{PROGRAMFILES(x86)}/MySQL/*/lib"
			  "$ENV{SYSTEMDRIVE}/MySQL/*/lib" )
else()
	find_path( MYSQL_INCLUDE_DIR
		NAMES "mysql.h"
		PATHS "/usr/include/mysql"
			  "/usr/local/include/mysql"
			  "/usr/mysql/include/mysql" )
	
	find_library( MYSQL_LIBRARY
		NAMES "mysqlclient" "mysqlclient_r"
		PATHS "/lib/mysql"
			  "/lib64/mysql"
			  "/usr/lib/mysql"
			  "/usr/lib64/mysql"
			  "/usr/local/lib/mysql"
			  "/usr/local/lib64/mysql"
			  "/usr/mysql/lib/mysql"
			  "/usr/mysql/lib64/mysql" )
endif()



if( MYSQL_INCLUDE_DIR AND EXISTS "${MYSQL_INCLUDE_DIRS}/mysql_version.h" )
	file( STRINGS "${MYSQL_INCLUDE_DIRS}/mysql_version.h"
		MYSQL_VERSION_H REGEX "^#define[ \t]+MYSQL_SERVER_VERSION[ \t]+\"[^\"]+\".*$" )
	string( REGEX REPLACE
		"^.*MYSQL_SERVER_VERSION[ \t]+\"([^\"]+)\".*$" "\\1" MYSQL_VERSION_STRING
		"${MYSQL_VERSION_H}" )
endif()

# handle the QUIETLY and REQUIRED arguments and set MYSQL_FOUND to TRUE if
# all listed variables are TRUE
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( MYSQL DEFAULT_MSG
	REQUIRED_VARS	MYSQL_LIBRARY MYSQL_INCLUDE_DIR
	VERSION_VAR		MYSQL_VERSION_STRING )

set( MYSQL_INCLUDE_DIRS ${MYSQL_INCLUDE_DIR} )
set( MYSQL_LIBRARIES ${MYSQL_LIBRARY} )

mark_as_advanced( MYSQL_INCLUDE_DIR MYSQL_LIBRARY )