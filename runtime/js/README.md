# Egg.js - A Smalltalk VM that runs on top of JavaScript

In a nutshell, here you get a bunch of js files that allow how to load an image file in a JSON format and execute Smalltalk code by evaluating Egg code.

# Getting Started

*IMPORTANT NOTE* this doc is a little bit outdated and there are quite a few things that may not work.

Unless you want to build the whole thing, you could just download a release from the appropriate section in github.

## Building

Running `make js` from root egg dir should build everything needed


### Build system

The idea is that you have egg code in root dir, and here in `image-segments` subdir you'll get the binaries for
the parts of the image, like `kernel.json` and `compiler.json`.

A bootstrap process generates those files from bare egg code, using pharo (see `egg/bootstrap/pharo`). The process
of bootstrapping does the following (it's all done automatically through `make`):

1 - generates an bootstrap pharo image with the needed pharo code
2 - loads the Powerlang-* packages using Iceberg
3 - executes `JSTranspiler transpileEggInterpreter` to generate the js files of the interpreter. Those files get
    writen `egg/runtimes/js/interpreter`.
4 - executes `JSTranspiler generateKernelModule` et al

## Evaluating Smalltalk code using nodejs
    $ node sample-server/index.js

## In the future it will be possible the following

    npm install egg-js

    ## Opening a Smalltalk REPL
    $ node repl.js
    Welcome to egg.js!
    [1] > 3 + 4
    7
    [2] > q
    See you soon!
    $

    ## Using Smalltalk as a library from nodejs

    # bench.js
    import egg from 'egg.js';
    import { performance } from "perf_hooks";
    let runtime = egg.launch();
    var startTime = performance.now();
    const result =  runtime.sendLocalTo_("bytecodeIntensiveBenchmark", number);
    var endTime = performance.now();
    console.log(`bytecodeIntensiveBenchmark returned ${result.value()} and took ${endTime - startTime} milliseconds`)

    # run bench.js
    $ node bench.js
    bytecodeIntensiveBenchmark returned 1028 and took 3233.994176030159 milliseconds

    ## Using Smalltalk as a library in a web page

    # bench.html
    <!DOCTYPE html>
    <html>
      <head>
        <script src="https://cdn.jsdelivr.net/npm/powerlang/dist/egg.js">
        <script>
          const runtime = egg.launch();
          const result = egg.evalExpression("(3 + 4) printString");
          document.body.appendChild(result.toLocalString());
        </script>
        <title>egg.js in action</title>
      </head>
      <body>
      </body>
    </html>

# System overview - A.K.A. how egg.js works

To run Smalltalk code you need a Smalltalk image and a Smalltalk evaluator (usually an interpreter).
To run it on top of JavaScript the interpreter needs to be made of JavaScript code.

Instead of writing the evaluator directly in JavaScript, in egg.js we take Egg evaluator, written in Smalltalk, and transpile its sources to JavaScript.

For the Smalltalk image, we use Egg/Pharo to bootstrap a virtual Smalltalk kernel image from sources, and then make that kernel write an image file tailored for the web, in JSON format.

Both the json image and js interpreter are generated using the `Makefile`. The image will be created in `image-segments` folder and the interpreter is written in `interpreter` folder.

Additionally, the repo contains some glue JS code to support the evaluator, debugging and launching the image.



