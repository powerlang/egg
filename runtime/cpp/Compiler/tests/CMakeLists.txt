# Compiler Tests CMake Configuration

cmake_minimum_required(VERSION 3.10)
project(CompilerTests CXX)

find_package(Catch2 REQUIRED)

# Compiler test executable
add_executable(compiler_tests
    test_main.cpp
    ScannerTest.cpp
    ParserTest.cpp
    MessageInlinerTest.cpp
    ScriptScopeTest.cpp
    TreecodeEncoderTest.cpp
)

target_link_libraries(compiler_tests PRIVATE
    egg_compiler
    bootstrapper_lib
    egg_runtime
    Catch2::Catch2
)

target_include_directories(compiler_tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}/../..
)

target_link_libraries(compiler_tests PRIVATE Catch2::Catch2)

# Enable testing
enable_testing()
add_test(NAME CompilerTests COMMAND compiler_tests)

# Add individual test tags for selective running
add_test(NAME ScannerTests COMMAND compiler_tests "[scanner]")
add_test(NAME ParserTests COMMAND compiler_tests "[parser]")
