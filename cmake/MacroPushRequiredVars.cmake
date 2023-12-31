# this module defines two macros:
# MACRO_PUSH_REQUIRED_VARS()
# and
# MACRO_POP_REQUIRED_VARS()
# use these if you call cmake macros which use
# any of the CMAKE_REQUIRED_XXX variables
#
# Usage:
# MACRO_PUSH_REQUIRED_VARS()
# SET(CMAKE_REQUIRED_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS} -DSOME_MORE_DEF)
# CHECK_FUNCTION_EXISTS(...)
# MACRO_POP_REQUIRED_VARS()

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

macro(MACRO_PUSH_REQUIRED_VARS)

   if(NOT DEFINED _PUSH_REQUIRED_VARS_COUNTER)
      set(_PUSH_REQUIRED_VARS_COUNTER 0)
   endif()

   math(EXPR _PUSH_REQUIRED_VARS_COUNTER "${_PUSH_REQUIRED_VARS_COUNTER}+1")

   if(DEFINED CMAKE_REQUIRED_INCLUDES)
      set(_CMAKE_REQUIRED_INCLUDES_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}    ${CMAKE_REQUIRED_INCLUDES})
   endif()
   if(DEFINED CMAKE_REQUIRED_DEFINITIONS)
      set(_CMAKE_REQUIRED_DEFINITIONS_SAVE_${_PUSH_REQUIRED_VARS_COUNTER} ${CMAKE_REQUIRED_DEFINITIONS})
   endif()
   if(DEFINED CMAKE_REQUIRED_LIBRARIES)
      set(_CMAKE_REQUIRED_LIBRARIES_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}   ${CMAKE_REQUIRED_LIBRARIES})
   endif()
   if(DEFINED CMAKE_REQUIRED_FLAGS)
      set(_CMAKE_REQUIRED_FLAGS_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}       ${CMAKE_REQUIRED_FLAGS})
   endif()
endmacro(MACRO_PUSH_REQUIRED_VARS)

macro(MACRO_POP_REQUIRED_VARS)

# don't pop more than we pushed
   if("${_PUSH_REQUIRED_VARS_COUNTER}" GREATER "0")
      if(DEFINED _CMAKE_REQUIRED_INCLUDES_SAVE_${_PUSH_REQUIRED_VARS_COUNTER})
         set(CMAKE_REQUIRED_INCLUDES    ${_CMAKE_REQUIRED_INCLUDES_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}})
      endif()
      if(DEFINED _CMAKE_REQUIRED_DEFINITIONS_SAVE_${_PUSH_REQUIRED_VARS_COUNTER})
         set(CMAKE_REQUIRED_DEFINITIONS ${_CMAKE_REQUIRED_DEFINITIONS_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}})
      endif()
      if(DEFINED _CMAKE_REQUIRED_LIBRARIES_SAVE_${_PUSH_REQUIRED_VARS_COUNTER})
         set(CMAKE_REQUIRED_LIBRARIES   ${_CMAKE_REQUIRED_LIBRARIES_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}})
      endif()
      if(DEFINED _CMAKE_REQUIRED_FLAGS_SAVE_${_PUSH_REQUIRED_VARS_COUNTER})
         set(CMAKE_REQUIRED_FLAGS       ${_CMAKE_REQUIRED_FLAGS_SAVE_${_PUSH_REQUIRED_VARS_COUNTER}})
      endif()

      math(EXPR _PUSH_REQUIRED_VARS_COUNTER "${_PUSH_REQUIRED_VARS_COUNTER}-1")
   endif()

endmacro(MACRO_POP_REQUIRED_VARS)
