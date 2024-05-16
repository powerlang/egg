

# Egg runtimes
==============

Egg code can run on top of different VMs. Some VMs need an already existing image file as a startup
point, while other VMs can just start from scratch (i.e. they can bootstrap an image from the Egg sources).

Currently existing VM projects are:

- pharo: Our first Egg VM, it was implemented in pharo. It is slow, because it works in a similar way in which
         the simulator works in opensmalltalk-vm. 
- js:    A VM for Egg written in JavaScript. Actually, most of the VM code comes from the pharo implementation,
         which is transpiled into JavaScript. It should be a little bit faster than pharo version because JS engines
         are faster than the opensmalltalk-vm. It does not bootstrap.
- lmr:   A VM for Egg written as an Egg module, what we call a Live Metacircular Runtime. Most of the code of this
         VM is actually outside this runtime directory, inside the modules/LMR dir. Here you'll find mostly build
         scripts
- cpp:   A traditional Egg VM written in C++ (for the non-beleivers :=)


For now, the only VM that is able to bootstrap is the one written in pharo. We use it to create image files from
scratch for other VMs. We basically create a virtual kernel image of Egg inside pharo and then tell it to dump an
image file for a particular format. For example, for js-vm we tell the virtual kernel to write an image in json
format.

