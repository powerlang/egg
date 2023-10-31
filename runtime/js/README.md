# powerlang.js - A Smalltalk VM that runs on top of JavaScript

In a nutshell, with this repo you get a bunch of js files that allow how to load an image file in a JSON format and execute Smalltalk code by evaluating Bee ~~bytecodes~~ treecodes.

# Getting Started

Until we have a CI set in place, you have to clone this repo and build the whole thing.
  
## Building

  

    # fetch the code, generate interpreter and image, fetch js dependencies
    git clone git@github.com:powerlang/powerlang-js.git
    cd powerlang-js
    make all
    npm install

**NOTE:** The makefile is not complete yet, so make step fails. After make ends (with error), you need to do the following manually in Pharo:

1 - open the generated bootstrap image with:
     cd powerlang
     ./pharo-ui bootstrap.image

2 - load the Powerlang-JS package using Iceberg (the repo should already be configured and show up as '.').

3 - execute `JSTranspiler transpilePowerlangInterpreter` to generate the js files of the interpreter
4 - debug the test `PowerlangJSTest>>#test010WriteKernelAsJSON`, and when it halts, manually evaluate in the debugger: `'../kernel.json' asFileReference writeStreamDo: [ :s | s nextPutAll: result asLocalString ]`.

## Evaluating Smalltalk code using nodejs
    $ node cli.js --eval "1 tinyBenchmarks"

## Opening a Smalltalk REPL
    $ node repl.js
    Welcome to powerlang.js!
    [1] > 3 + 4
    7
    [2] > q
    See you soon!
    $

## Using Smalltalk as a library from nodejs

    # bench.js
    import powerlang from 'powerlang.js';
    import { performance } from "perf_hooks";
    let runtime = powerlang.launch();
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
        <script src="https://cdn.jsdelivr.net/npm/powerlang/dist/powerlang.js">
        <script>
          const runtime = powerlang.launch();
          const result = powerlang.evalExpression("(3 + 4) printString");
          document.body.appendChild(result.toLocalString());
        </script>
        <title>powerlang.js in action</title>
      </head>
      <body>
      </body>
    </html>

# System overview - A.K.A. how powerlang.js works

To run Smalltalk code you need a Smalltalk image and a Smalltalk evaluator (usually an interpreter).
To run it on top of JavaScript the interpreter needs to be made of JavaScript code.

Instead of writing the evaluator directly in JavaScript, in powerlang.js we take Powerlang evaluator, written in Smalltalk, and transpile its sources to JavaScript.

For the Smalltalk image, we use Powerlang to bootstrap a virtual Smalltalk kernel image from sources, and then make that kernel write an image file tailored for the web, in JSON format.

Both the json image and js interpreter are generated using the `Makefile`. The image will be created in `image-segments` folder and the interpreter is written in `interpreter` folder.

Additionally, the repo contains some glue JS code to support the evaluator, debugging and launching the image.



