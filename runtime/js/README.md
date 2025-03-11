# Egg.js - A Smalltalk VM that runs on top of JavaScript

In a nutshell, here you get a bunch of js files that allow how to load an image file in a JSON format and execute Smalltalk code by evaluating Egg code.

*IMPORTANT NOTE* this is heavily w.i.p and there are quite a few things that may not work.

# Getting Started


If you want the typical image and VM files, you can just download an eggjs release from the appropriate
section in github. Else you can build the whole thing, y

## Building

Running `make js` from root egg dir should build everything needed


### Build system

The idea is that you have egg code in root dir, and here in `image-segments` subdir you'll get the binaries for
the parts of the image, like `kernel.json` and `compiler.json`.

A bootstrap process generates those files from bare egg code, using pharo (see `egg/bootstrap/pharo`). The process
of bootstrapping does the following (it's all done automatically through `make`):

1 - generates a bootstrap pharo image, with the needed pharo code, where it is possible to create a little virtual egg image from egg sources
2 - loads the Powerlang-* packages using Iceberg
3 - executes `JSTranspiler transpileEggInterpreter` to generate the js files of the interpreter. Those files get
    writen `egg/runtimes/js/interpreter`.
4 - executes `JSTranspiler generateKernelModule` et al

# Running the code

There are different ways in which you could run Egg code in a JS platform. You could
run it on top of node.js or inside a web browser. We started by supporting
running on top of node.js.


## Exploring a Smalltalk image that runs on top of nodejs

This creates a small webserver that loads an egg image and responds [webside](https://github.com/guillermoamaral/Webside)
requests, so that you can browse and debug it remotely:


    ## clone and enter the main dir for js platform
    $ git clone git@github.com:powerlang/egg.git
    $ cd egg/runtime/js/examples/server

    ## fetch dependencies (including built egg-js and webside server)
    $ npm install 

    ## Now run the server
    $ node example-server/index.js

    ## Finally, connect from a webside client to address http://localhost:9005/

## Using Smalltalk as a library from nodejs

For this example, let's look at `runtime/js/examples/bench`.

    // bench.js
    import { performance } from "perf_hooks"; // nodejs built-in for measuring time
    import Egg from '../Egg.js';

    var egg = new Egg();
    egg.loadKernelFile("Kernel.json");

    let n1 = 1, t1;
    do {
        let startTime = performance.now();
        egg.send(egg.runtime.newInteger_(n1), "benchSieve");
        let endTime = performance.now();
        t1 = endTime - startTime;
        if (t1 >= 1000) break;
        n1 = n1 * 2;
    } while (true)

    let n2 = 28, t2, r;
    do {
        let startTime = performance.now();
        r = egg.send(egg.runtime.newInteger_(n2), "benchFibonacci").value();
        let endTime = performance.now();
        t2 = endTime - startTime;
        if (t2 >= 1000) break;
        n2 = n2 + 1;
    } while (true)

    console.log(`${(n1 * 500000.0 * 1000 / t1).toFixed()} bytecodes/sec; ${(r * 1000.0 / t2).toFixed()} sends/sec`)
      

You can run it with the following lines:

    # fetch js dependencies (basically, egg-js)
    $ npm install

    # run
    $ node example-bench/bench.js
    1242848 bytecodes/sec; 95553 sends/sec

## Using egg as a node module (not yet implemented)

    $ npm install egg-js

    ## Opening a Smalltalk REPL
    $ node repl.js
    Welcome to egg.js!
    [1] > 3 + 4
    7
    [2] > q
    See you soon!
    $


## Using Smalltalk as a library in a web page (not yet implemented)

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

Instead of writing the evaluator directly in JavaScript, in egg.js we take Egg/Pharo evaluator, written in Smalltalk, and transpile its sources to JavaScript.

For the Smalltalk image, again we use Egg/Pharo, this time to bootstrap a virtual Smalltalk kernel image from sources, and then to make that kernel write an image file tailored for the web, in JSON format.

Both the JSON image and JS interpreter are generated using the `Makefile`. The image will be created in `image-segments` folder and the interpreter is written in `interpreter` folder.

Additionally, the repo contains some glue JS code in `st-glue.js` to support the evaluator, debugging and launching the image.


