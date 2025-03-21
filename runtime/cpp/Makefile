
ifeq ($(OS),Windows_NT)
    PLATFORM ?= Windows
    #ARCH ?= $(shell powershell -Command "(conan profile show -cx build) -split '`n' | Select-String -Pattern 'arch' | ForEach-Object { ($$_ -split '=')[-1].Trim() }")
    ARCH ?= x86_64
else
    PLATFORM ?= $(shell uname -s)
    ARCH ?= $(shell uname -m)
endif

BUILD_TYPE ?= Debug
BUILD_DIR := build/$(PLATFORM)-$(ARCH)-$(BUILD_TYPE)

all:
	conan install . --output-folder=$(BUILD_DIR) --build=missing -s compiler.cppstd=20 -s build_type=$(BUILD_TYPE)
	cmake -B $(BUILD_DIR) -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DCMAKE_PREFIX_PATH=$(BUILD_DIR)
	cmake -S . -B $(BUILD_DIR) && cmake --build $(BUILD_DIR)

core-segments:
	make -C ../pharo core-native-segments
	
clean:
	rm -rf build
