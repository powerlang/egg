# Egg.cpp - An Egg Smalltalk VM that is implemented in C++

In a nutshell, here you get a simple interpreter that is able to load Egg modules and run them.
It starts by bootstrapping the Egg kernel from its sources, then loads the module you specify, and
finally sends it `#main:`

*IMPORTANT NOTE* this is heavily w.i.p. and there are quite a few things that may not work.

# Getting Started

If you want the typical image and VM files, you can just download an egg-cpp release from the appropriate
section in github. Else you can build the whole thing yourself.

# Running the code

Once you have built the VM, run a module by its name from the root repo dir:

```
$> cd $root_dir
$> runtime/cpp/build/<OS>-<arch>-<BuildType>/egg Examples.HelloWorld
Hello, World!
```

`Examples.HelloWorld` is the module in `modules/Examples/HelloWorld`, which shows the bare minimum of
writing a module: a dotted name is a path under `modules`.

No prebuilt files are needed. The VM bootstraps the kernel from `modules/Kernel` (see
[Bootstrap/README.md](Bootstrap/README.md)) and loads every other module from its sources, unless
there is an Egg Module Snapshot for it in `image-segments` (`image-segments/<name>.ems`), which is
loaded instead. The VM looks for `modules` in the current directory and up to four directories above
it, so it can also be run from `image-segments` or from the build directory.

## Building the VM

Dependencies (Ubuntu): `sudo apt install g++ cmake conan`. On macOS use Homebrew.
[Conan](https://conan.io) is a C++ package manager that fetches the few required
C++ dependencies (libffi, Catch2). We try to keep deps as minimal as possible.

The simplest path is the top-level `Makefile`, which picks the right build dir
for your platform (`build/<OS>-<arch>-<BuildType>`):

```
cd runtime/cpp
make                       # Debug build (default)
make BUILD_TYPE=Release    # Release build
```

Or invoke conan + cmake by hand:

```
cd runtime/cpp
BUILD_DIR=build/$(uname -s)-$(uname -m)-Debug.   # i.e. build/Darwin-arm64-Debug
conan install . --output-folder=$BUILD_DIR --build=missing -s build_type=Debug
cmake -B $BUILD_DIR -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=$BUILD_DIR
cmake --build $BUILD_DIR -j
```

The resulting executable is `$BUILD_DIR/egg`.

## Running tests

The C++ tree carries two CTest suites:

- `compiler_tests` — scanner & parser unit tests (`runtime/cpp/Compiler/tests`).
- `bootstrapper_parser_tests` — Tonel parsing and bootstrap integration
  (`runtime/cpp/Bootstrap/tests`).

After building, run them through CTest from the build directory:

```
cd runtime/cpp/build/$(uname -s)-$(uname -m)-Debug
ctest --output-on-failure                       # everything
ctest -R CompilerTests --output-on-failure      # one suite
ctest -R BootstrapperParserTests
```

The individual binaries also accept Catch2 tag filters, e.g.
`./Compiler/tests/compiler_tests "[scanner]"`.

## Building module snapshots

Egg Module Snapshots (ems files) are optional: a module that has one loads faster than from its
sources. They are built with the pharo runtime. Using the pharo runtime in ../pharo, open
egg.image and run:

```
builder := EggBuilder forNativePlatform.
builder generateKernelSegment.
builder generateCompilerSegment.
builder generateMainSegments.
```

This will generate in `$root_dir/image-segments` a bunch of files, including `Kernel.ems`, `Compiler.ems`, etc.
`$root_dir` is the root repo dir.


## Exploring a Smalltalk image

This is the TO-DO plan. To be implemented asap.

The way to browse the image is through [webside](https://github.com/guillermoamaral/Webside).
To allow webside to connect, you have to start a small http server that responds its requests.
From there, you can browse and debug the image locally or remotely.

We are implementing different options for the webside http server, you may use the one that better
suits your needs:

- Egg's Webside module - A module that can be loaded into the image, and replies to requests by
                typical meta-level introspection.
- CPP Webside - An http server running inside the VM in a secondary thread. Allows to look at the
                image without altering its contents and having it not freezed at the same time.
- GDB Webside - An http server running inside GDB. It allows to have a freezed Egg process and look
                through its memory.

Usages:

- Egg's Webside module:
```
   $> egg -m Webside MyModule
```

- CPP Webside:
```
    $> egg --webside MyModule
```

- GDB Webside
```
   $> gdb --args egg MyModule
   (gdb) source $root_dir/runtime/gdb/webside.py
   (gdb) run
```

Then connect from a webside client to address http://localhost:9005/

## Using Egg Smalltalk as an embeddable library

```
#include <Egg.h>
#include <iostream>

int
main(const int argc, const char** argv) {
   std::ifstream kernelFile("kernel.ems", std::ifstream::binary);
    if (!kernelFile) {
        printf("No kernel.ems\n");
        return 1;
    }

    auto kernelSegment = new ImageSegment(&kernelFile);
    auto bootstrapper = new Bootstrapper(kernelSegment);
    auto runtime = bootstrapper->_runtime;
    HeapObject *kernel = bootstrapper->_kernel->_exports["Kernel"];

    HeapObject *name = runtime->sendLocal_to_("name", (Egg::Object*)kernel)->asHeapObject();
    std::cout << "The name of kernel module is " << name->asLocalString() << std::endl;
}
```



