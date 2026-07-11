cmake_minimum_required(VERSION 3.15)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)

project(lmr_launcher VERSION 0.1.0)

set(CPP ${CMAKE_CURRENT_SOURCE_DIR}/../cpp)

if(WIN32 OR (${CMAKE_C_COMPILER} MATCHES "mingw"))
    set(PLATFORM Windows)
else()
    set(PLATFORM Posix)
endif()

add_library(lmr_egg STATIC
    ${CPP}/Egg.cpp
    ${CPP}/FileImageSegment.cpp
    ${CPP}/ImageSegment.cpp
    ${CPP}/HeapObject.cpp
    ${CPP}/Object.cpp
    ${CPP}/KnownObjects.cpp
    ${CPP}/SmallInteger.cpp
    ${CPP}/${PLATFORM}/Memory.cpp)
target_include_directories(lmr_egg PUBLIC ${CPP} ${CPP}/${PLATFORM} ${CMAKE_CURRENT_SOURCE_DIR})

add_library(lmr_launcher STATIC Launcher.cpp)
target_link_libraries(lmr_launcher PUBLIC lmr_egg)
target_include_directories(lmr_launcher PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
