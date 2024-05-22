"
    Browsing kernel code (load kernel smalltalk from files and browse it).
"

EggRingImage resetSpecs.
EggRingImage kernelSpec browse.

JSTranspiler transpileEggInterpreter.

JSTranspiler generateKernelSegment.
JSTranspiler generateCompilerSegment.
JSTranspiler generateMainSegments.


"
    Executing Smalltalk code in a virtual image:
"

image := EggRingImage fromSpec wordSize: 8; genesis.
runtime := image runtime.
three := image newInteger: 3.
four := image newInteger: 4.
result := runtime sendLocal: #+ to: three with: {four}.
