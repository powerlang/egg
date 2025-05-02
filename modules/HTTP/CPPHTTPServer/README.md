# HTTP Server library

This module a very thin layer that works by calling a C++ http server library known as
cpp-httplib. As egg can only call C and not C++, in `lib` there is a plain C wrapper to
the C++ code of the cpp-httplib. To be able to use this module you'll need a compiled
version of that small C library. We might setup a CI to automatically upload a build
artifact in the future, but meanwhile you'll have to compile it by yourself.

# Compiling the C layer

To compile the C wrapper, you'll need to get the single-header httplib.h file into the
lib directory. It's quite easy:

```
egg/modules/HTTP/CPPHTTPServer/lib $
./download-cpp-httplib.sh
```

Once you have the header, build using cmake from `lib` dir with something like this:

```
egg/modules/HTTP/CPPHTTPServer/lib $
cmake -S . -B build && cmake --build build
```

The result should be a file called libhttpserver.so (linux), httpserver.dll (windows),
httpserver.dylib or something similar for your platform. 
This file will go to the build dir, you'll have to copy (or better, link) it to some
place in your egg's FFI path (simplest way: the place from where you run egg).

```
egg/image-segments $
ln -s ../modules/HTTP/CPPHTTPServer/lib/libhttpserver.so .
```

# Usage

You'll find an example of usage in `modules/Examples/HTTPServer`.
