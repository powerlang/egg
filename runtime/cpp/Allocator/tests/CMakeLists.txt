cmake_minimum_required(VERSION 3.10)

find_package(Catch2 REQUIRED)

add_executable(allocator_tests
    test_main.cpp
    G1GCForwarderTest.cpp
    MarkBitmapTest.cpp
)

set_property(TARGET allocator_tests PROPERTY CXX_STANDARD 20)

target_include_directories(allocator_tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../..
)

target_link_libraries(allocator_tests
    Catch2::Catch2
    egg_runtime
    bootstrapper_lib
    egg_compiler
)

add_test(NAME AllocatorTests COMMAND allocator_tests)
