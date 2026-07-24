cmake_minimum_required(VERSION 3.15)

find_package(Catch2 REQUIRED)

add_executable(lmr_tests
    test_main.cpp
    test_01_load.cpp
    test_02_tables.cpp
    test_03_relocate.cpp
    test_04_run.cpp
)

set_property(TARGET lmr_tests PROPERTY CXX_STANDARD 20)

set(LMR_SEG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../image-segments/lmr")
target_compile_definitions(lmr_tests PRIVATE LMR_SEG_DIR="${LMR_SEG_DIR}")

target_link_libraries(lmr_tests
    Catch2::Catch2
    lmr_launcher
    lmr_egg
)
target_include_directories(lmr_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/..)

if(APPLE)
    target_link_options(lmr_tests PRIVATE -Wl,-dead_strip)
endif()

add_test(NAME LmrTests COMMAND lmr_tests)
