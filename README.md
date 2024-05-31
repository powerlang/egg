# Egg Smalltalk

Egg is a MIT-licensed implementation of a Smalltalk-80 derived environment.
Egg is not strictly a ST80 though. Some egg characteristics
and intentions are:
 - It is _module-based_, where each module has its own namespace (no Smalltalk globals anymore).
 - Modules can be loaded quickly through _image segments_ (without requiring a compiler).
 - It is _minimal_, with the capability to grow dynamically: its kernel has much fewer
   things than ST80 (i.e. no GUI and no compiler), but because of image-segments those
   modules can be loaded instantly.
 - Most identifiers are _dynamically bound_. This means that like #doesNotUnderstand:
   message, you can also get a #doesNotKnow: message. The implementation uses a cache and
   is fast (you don't have to worry about performance there :).
 - Module dependencies are stated explicitly, new modules are built through _importing_
   components of other modules.
 - Designed to support _multiple VMs_ that allow running on _multiple platforms_.
 - This includes native JIT-based VMs for popular OSes and JS-based runtimes.
 - For all VMs and OSes, the same Smalltalk code base is used (there might only be small
   differences if the platform used doesn't support a particular feature).
 - Egg is developed in tandem with [Webside](https://github.com/guillermoamaral/Webside),
   which is the GUI used to develop and debug the Smalltalk code on any platform.
   This allows to keep Egg minimal, even in platforms such as _EggNOS_ (a successor of
   SqueakNOS!)


## Contents of this repo

This repository includes the Smalltalk sources of Egg (in `modules` directory) as
well as the different runtime implementations (`runtimes` directory) and the
mechanisms to generate images from scratch (`bootstrap` directory).

## Using

If you just want to use egg, download the corresponding build artifact from releases.
Currently, our only working platforms are Pharo and JS, native ones will come soon™. You'll find
supported platforms in /runtime subdirectories. Look for individual README.md on each
of them to find specific help about using that platform.

Each subdir of runtime implements a VM that can run Egg code in a different platform. All
platforms use the same Egg code, which is stored in [modules](modules) directory. For
now we have the following runtimes:

[Egg/Pharo](runtime/pharo) - Our main platform for bootstrapping and modifying Egg kernel.
[Egg/JS](runtime/js) - An implementation a VM for Egg that can run in node.js or a web browser.

## Building

If you want to build things from scratch clone this repo and follow the next steps.

```
git clone git@github.com:powerlang/egg.git
```

Then just do `make <platform>`, where platform can be `js`, `native` or `native-lmr` (remember,
only `js` works right now).

### JavaScript platform

```
make js
```

This will build the ST vm that is written in JS, and small set of core image segments (kernel and compiler).
You'll find the results in `runtime/js`, continue from there.

### Native and Native-LMR platforms

To be implemented

## Project status

There are (at least) two mostly orthogonal sides in this project: runtimes and Egg Smalltalk modules.
In the Egg Smalltalk axis, we already have: kernel, compiler, modules and image-segment builder, among others.
In runtime axis, we started with JS platform as it is the easiest to get working (JS
already includes a GC and JIT).
We are also developing other VMs: a traditional C++-based VM with interpreter and JIT and an LMR (Live Metacircular Runtime, a.k.a. Smalltalk-in-Smalltalk VM)

