
Welcome to Egg's documentation!
=====================================

Egg is a an open source, MIT-licensed implementation of a Smalltalk-80 derived
programming language. Egg is not strictly a ST80 though. Some egg characteristics
and intentions are:

- It is module-based, where each module has its own namespace (no Smalltalk globals anymore).
- Modules can be loaded quickly through image segments (without requiring compilation).
- It is minimal, with the capability to grow dynamically: its kernel has much fewer things than ST80 (i.e. no GUI and no compiler), but because of image-segments those modules can be loaded instantly.
- Most identifiers are dynamically bound. This implies that, akin to the `#doesNotUnderstand:` message, you can also get a `#doesNotKnow:` message. The implementation uses a cache and is fast (you don't have to worry about performance there :).
- Module dependencies are stated explicitly, new modules are built through importing components of other modules.
- Designed to support multiple VMs that allow running on multiple platforms.
- This includes native JIT-based VMs for popular OSes and JS-based runtimes.
- For all VMs and OSes, the same Smalltalk code base is used (there might only be small differences if the platform used doesn't support a particular feature).
- Egg is developed in tandem with Webside, which is the GUI used to develop and debug the Smalltalk code on any platform. This allows to keep Egg minimal, even in platforms such as EggNOS (a successor of SqueakNOS!)



Design
******

Below is our humble vision of what a modern Smalltalk design
should look like, the direction in which we want to go.

We want a minimal modular Smalltalk, that starts from a little kernel and that
can load other modules on-the-fly to grow exactly as needed.
The bootstrap process is done mostly from a specification (source code), using
different dialects (Pharo et al). This allows sealed-system development which
is required when doing big or complex changes, specially in design. Of course,
the live environment development will be supported as usual in Smalltalk-80
systems.
Computation is represented using Smalltalk Expressions (or SExpressions), 
a lower-level representation of abstract syntax trees (ASTs) that is
encoded into byte arrays (called treecodes).

Namespaces are supported from the beginning, and form the base of modules.
Modules are automatically written into an image segment cache. Image segments
are stored in a binary format that can be loaded extremely quickly.
A package distribution system computes dependencies and fetches
prebuilt image segments for quick setup, update and deployment.

The base system can be used to allow creation of
different dynamic languages.  In particular, 
we expect Egg Smalltalk to expand on two different axes: on one hand, it can
grow to become a full, tightly integrated Smalltalk; on the other hand,
its kernel can be the base system on top of which we support other
Smalltalks (or other languages). The main candidate for the latter
approach is to make the opensmalltalk-vm run on top of Egg kernel, instead
of translating it to C and compiling. This would make Squeak/Pharo/Cuis
run on top of Egg, which could either run self-hosted (if using the LMR, see next section)
or on top of another VM. Below we present a look of different
possible mixes and matches of language environments and hosting runtimes.

.. image:: figures/runtime-types.png
  :width: 800
  :alt: Runtime types

Implementation
**************

Egg-based systems should work on Windows, Linux, Mac, Android and nopsys,
including embedded platforms.
64 and 32 bit architectures are the starting point, but if possible we may try
even smaller.

Different runtimes are being developed in parallel. The pure LMR (live
metacircular runtime), a VM written in JS (to run Egg in the browser) and
a native VM written in C++.
The LMR is an AOT-based approach, that uses Smalltalk to pre-nativize a Smalltalk
JIT compiler, and then uses that compiler to nativize on the fly other
Smalltalk code.

Smalltalk source code is stored on git, using a tonel-like format. We store 
just code and definitions in the repo, no artifacts.
Build artifacts go through Continuous Integration from the very beginning.
Each OS platform is implemented as a separate module and built into separate
image segments, which are autoloaded at startup according to the
running platform.
The system can be debugged remotely through a Webside, which
allows both local and remote debugging.

Setup
*****

To setup the development repository, see the instructions in 
`Egg repo <github.com/powerlang/egg>`_.

How to improve this documentation
*********************************

This documentation was written in rst format and html output was generated
by sphinx. You will find these same contents
in `/docs` directory. To be able to compile them, you will need to install
sphinx in your system::

    pip3 install sphinx sphinx-autobuild

then just from root egg dir do::

    sphinx-autobuild docs docs/_build/html

which will open a local http server at http://127.0.0.1:8000 that recompiles
automatically when files are changed and that lets you browser the docs as
you change them. When you have any change, just open a PR in
`github.com/powerlang/egg <https://github.com/powerlang/egg>`_

Indices and tables
==================

.. toctree::
   :maxdepth: 2
   :includehidden:
   
   egg/index
   bootstrap/index
   lmr/lmr
..   :caption: Contents:

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

Things to do (PRs are welcome!)
===============================

.. todolist::


