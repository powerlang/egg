

all:
	conan install . --output-folder=build --build=missing -s compiler.cppstd=gnu20 -s build_type=Debug
	cmake -B build -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=build
	cmake -S . -B build && cmake --build build

core-segments:
	make -C ../pharo core-native-segments
	
clean:
	rm -rf build
