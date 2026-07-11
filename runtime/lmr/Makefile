ifeq ($(OS),Windows_NT)
    PLATFORM ?= Windows
    ARCH ?= x86_64
else
    PLATFORM ?= $(shell uname -s)
    ARCH ?= $(shell uname -m)
endif

BUILD_TYPE ?= Debug
BUILD_DIR := build/$(PLATFORM)-$(ARCH)-$(BUILD_TYPE)

all:
	conan install . --output-folder=$(BUILD_DIR) --build=missing -s build_type=$(BUILD_TYPE)
	cmake -S . -B $(BUILD_DIR) -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DCMAKE_PREFIX_PATH=$(BUILD_DIR)
	cmake --build $(BUILD_DIR)

test: all
	cd $(BUILD_DIR) && ctest --output-on-failure

clean:
	rm -rf build
