cmake_minimum_required(VERSION 3.15)

set( CMAKE_VERBOSE_MAKEFILE on )
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
set(BUILD_SHARED_LIBS OFF)

project(launcher VERSION 0.1.0)

include(CTest)
enable_testing()

set(IMAGE_SEGMENTS ./image-segments)

set(EXE egg)

IF(WIN32 OR (${CMAKE_C_COMPILER} MATCHES "mingw"))
    set(PLATFORM Windows)
ELSE()
    set(PLATFORM Posix)
ENDIF()

# **** instructions for linking dependencies through conan ****
# this automagically sets up include and library directories,
# so that we can easily link to libffi and cxxopts

#include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
#conan_basic_setup()

find_package(libffi REQUIRED)
find_package(cxxopts REQUIRED)

# *************************************************

file(GLOB ALL_SRC "*.cpp" "Evaluator/*.cpp" "${PLATFORM}/*.cpp")

add_executable(${EXE} ${ALL_SRC})
target_link_libraries(${EXE} libffi::libffi cxxopts::cxxopts) # link agains libffi


if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    target_link_libraries(${EXE} dl)
endif()

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include_directories(. ${PLATFORM})


include(CPack)

