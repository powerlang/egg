# Egg.cpp - An Egg Smalltalk VM that is implemented in C++

In a nutshell, here you get a simple interpreter that is able to load Egg modules and run them.
It starts by loading an Egg kernel snapshot, then the module you specify, and finally sending it `#main:`

*IMPORTANT NOTE* this is heavily w.i.p. and there are quite a few things that may not work.

# Getting Started

If you want the typical image and VM files, you can just download an egg-cpp release from the appropriate
section in github. Else you can build the whole thing yourself.

# Running the code

Once you have a VM and some .ems binaries, you can run them:

```
$> cd $root_dir/image-segments
$> ../runtime/cpp/build/egg HelloWorld.ems
Hello, world!
```

`HelloWorld` is a module in `modules/Examples/HelloWorld` that shows the bare minimum of writing a module.

## Building the VM

To compile the VM, be sure to install dependencies listed in next section and then just run from cli:

```
conan install . --output-folder=build --build=missing -s compiler.cppstd=gnu20 -s build_type=Debug
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_PREFIX_PATH=build
cmake --build build
```

This will build you an executable, you still need to run modules. 

### Dependencies

We aim for minimality everywhere, however you'll need some tools to be
able to compile egg. In ubuntu, this should be all:

```
sudo apt install g++ cmake conan
```

That should be all for compiling the VM.

## Building module snapshots

As this cpp VM isn't yet capable of starting from just sources (i.e. to bootstrap itself), you
have to build Egg Module Snapshots (ems files). For that we currently use the pharo runtime.

Using the pharo runtime in ../pharo, open egg.image and run:

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



