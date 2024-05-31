# Egg/Pharo - An Egg VM that runs on top of Pharo

This folder contains the sources of a VM for Egg that works on top of Pharo. This means,
when loading this code into a Pharo (host) image, you will be able to create a virtual Egg
image (guest) inside Pharo. The objects of this virtual image will be (when seen from Pharo) instances
of EggObject and subclasses. A gateway object will let the host communicate with the guest, 
by sending messages to objects living in the virtual image.

## System overview - A.K.A. how Egg/Pharo works

To run Smalltalk code you need a Smalltalk image and a Smalltalk evaluator (usually an interpreter).
This Egg implementation is all "virtual". The evaluator is coded in Smalltalk, and is just an object
in Pharo. The image is a set of other objects too. All code runs inside Pharo, which is much better
host than the native world when debugging. 

So, instead of starting from an Egg image file, the Pharo image lets you create a virtual Egg image,
which it builds from Egg sources. You can then access well known objects inside this virtual image
through an Egg _gateway_, which also lets you send those objects messages.

To create this Pharo image, just follow the instructions below.

## Building

Running `make` here should build everything needed. The automatic process of building is quite simple:
It generates a pharo image for bootstrapping Egg. This image has the Powerlang-* packages which let
you create virtual Egg images from sources in `modules` dir.

    $ > git clone git@github.com:powerlang/egg.git
    $ > cd egg/runtime/pharo
    $ egg/runtime/pharo > make

You'll get a pharo vm downloaded and an egg.image
built with everything you need to create virtual Egg images. These images will be bootstrapped
dynamically from sources stored in root [modules](../../modules) directory.

## Running the code

After running `make`, you can open the `egg.image` with pharo to play with the little system. 

    $ egg/runtime/pharo > ./pharo-ui egg.image

From there, you can build Egg virtual images with the following code:

    egg := EggRingImage fromSpec
    			            wordSize: 8;
    			            genesis;
    			            bootstrap;
    			            fillClasses;
    			            fillSymbols;
    			            generateMetacircularImage

## Exploring a Smalltalk image that runs in pharo (w.i.p.)

With an image in hand, you can inspect the objects manually _from the outside_, through
Pharo inspectors, but it is usually nicer to access the image from the inside. To allow
for that, we use [webside](https://github.com/guillermoamaral/Webside).

It is possible (modulo w.i.p.) to start a webserver within Pharo that points to a virtual
Egg image and responds Webside requests, so that you can browse and debug it remotely.
This is still heavily work in progress. First you have to
install Webside (ignore the warnings by clicking continue):

    Metacello new
    	baseline: 'Webside';
    	repository: 'github://guillermoamaral/Pharo-Webside:main';
    	load.

Then, manually open egg repo in iceberg and load package EggWebside.

Next, start a Webside backend server pointing to an Egg image:

    runtime := gateway runtime.
    server := WebsideServer new.
    server
        apiClass: EggWebsideAPI;
        baseUri: '/egg';
        port: 9999;
        resourcesAt: #runtime put: runtime;
        start.
    client := ZnClient new accept: ZnMimeType applicationJson

Finally, open a webside client pointing to the backend at `http://localhost:9999/egg`.

