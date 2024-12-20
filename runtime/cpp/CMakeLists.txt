cmake_minimum_required(VERSION 3.5.0)

set( CMAKE_VERBOSE_MAKEFILE on )
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
set(BUILD_SHARED_LIBS OFF)

if (CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
    set(CMAKE_BUILD_TYPE Debug)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s EXPORTED_RUNTIME_METHODS='[\"FS_createDataFile\"]'")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s ALLOW_MEMORY_GROWTH=1")

    # libffi requires a special version, clone https://github.com/hoodmane/libffi-emscripten
    set(FFI_INCLUDE_DIR ${EMSDK}/libffi-emscripten/build/include)
    set(FFI_LIBRARY_DIR ${EMSDK}/libffi-emscripten/build/lib)
    include_directories(${FFI_INCLUDE_DIR})
    link_directories(${FFI_LIBRARY_DIR})

endif()

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

# **** instructions for linking against libffi ****
find_package(PkgConfig REQUIRED)
pkg_check_modules(FFI REQUIRED libffi)

include_directories(${FFI_INCLUDE_DIRS})
# *************************************************

file(GLOB ALL_SRC "*.cpp" "Evaluator/*.cpp" "${PLATFORM}/*.cpp")

add_executable(${EXE} ${ALL_SRC})
target_link_libraries(${EXE} ${FFI_LIBRARIES}) # link agains libffi


set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

include_directories(. ${PLATFORM})


include(CPack)
