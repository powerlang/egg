# HTTP Server example

An example of an HTTP server based on cpp-httplib. 
The CPPHTTPServer module contains an FFI interface to plain C wrappers
to cpp-httplib. Here we use those wrappers to create a blocking web
server.

## Building

You need to build the native cpp-httplib in HTTP/CPPHTTPServer/lib (see
its readme), then build this module and FFI

cd image-segments
make FFI.ems FFI.Posix.ems Examples.HTTPServer.ems

