cmake_minimum_required(VERSION 3.15)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)

project(lmr_launcher VERSION 0.1.0)

include(CTest)
enable_testing()

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
    ${CPP}/${PLATFORM}/Memory.cpp
    ${CPP}/${PLATFORM}/FFIGlue.cpp)
target_link_libraries(lmr_egg PUBLIC ${CMAKE_DL_LIBS})
target_include_directories(lmr_egg PUBLIC ${CPP} ${CPP}/${PLATFORM} ${CMAKE_CURRENT_SOURCE_DIR})
if(UNIX AND NOT APPLE)
    target_compile_options(lmr_egg PUBLIC -ffunction-sections -fdata-sections)
endif()

function(lmr_executable target)
    if(APPLE)
        set_property(TARGET ${target} PROPERTY ENABLE_EXPORTS ON)
        target_link_options(${target} PRIVATE -Wl,-dead_strip)
    elseif(UNIX)
        target_link_options(${target} PRIVATE -Wl,--gc-sections -Wl,--export-dynamic-symbol=egg_flush_icache)
    endif()
endfunction()

add_library(lmr_launcher STATIC Launcher.cpp CodeInstaller.cpp)
target_link_libraries(lmr_launcher PUBLIC lmr_egg)
target_include_directories(lmr_launcher PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

add_executable(lmr Main.cpp)
target_link_libraries(lmr lmr_launcher lmr_egg)
lmr_executable(lmr)

add_test(NAME LmrHelloWorld COMMAND lmr ${CMAKE_CURRENT_SOURCE_DIR}/../../image-segments/lmr Examples.HelloWorld)
set_tests_properties(LmrHelloWorld PROPERTIES PASS_REGULAR_EXPRESSION "Hello, World!")
add_test(NAME LmrUnhandledError COMMAND lmr ${CMAKE_CURRENT_SOURCE_DIR}/../../image-segments/lmr NoSuchModule)
set_tests_properties(LmrUnhandledError PROPERTIES PASS_REGULAR_EXPRESSION "cannot open .*NoSuchModule.ems")

add_subdirectory(tests)
