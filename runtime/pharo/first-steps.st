"
    Browsing kernel code (load kernel smalltalk from files and browse it).
"

EggBootstrapImage resetSpecs.
EggBootstrapImage kernelSpec browse.

"JS - for this you must have powerlangjs packages installed (make js in root dir)"
JSTranspiler transpileEggInterpreter.

EggBuilder forNativePlatform generateKernelSegment.
EggBuilder forNativePlatform generateCompilerSegment.
EggBuilder forNativePlatform generateMainSegments.

EggBuilder forJSPlatform generateKernelSegment.
EggBuilder forJSPlatform generateCompilerSegment.
EggBuilder forJSPlatform generateMainSegments.


"
    Executing Smalltalk code in a virtual image:
"

image := EggBootstrapImage fromSpec wordSize: 8; genesis.
runtime := image runtime.
three := image newInteger: 3.
four := image newInteger: 4.
result := runtime sendLocal: #+ to: three with: {four}.

"Webside support"

"1 - Installing webside (ignore the warnings)"
Metacello new
	baseline: 'Webside';
	repository: 'github://guillermoamaral/Pharo-Webside:main';
	load

"also, after loading this main webside repo, you can manually load the Powerlang-EggWebside package
for inspecting an Egg/Pharo image from Webside"

"2 - Openning a backend"
WebsideServer new baseUri: '/pharo/v1'; port: 9002; start

"3 - Finally, remember to connect to URL from a webside client: http://localhost:9002/pharo/v1"


