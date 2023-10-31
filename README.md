# to-be-named Smalltalk (a.k.a. egg)

This is an implementation of a Smalltalk-80 derived environment. 
Designed to support multiple VMs that allow running on multiple platforms.
This includes native JIT-based VMs for popular OSes and JS-based runtimes. 


## Contents of this repo

This repository includes the Smalltalk sources (`modules` directory) as
well as the different runtime implementations (`runtimes` directory) and
mechanism to generate images from scratch (`bootstrap` directory).

## Downloading and Building

TODO: If you just want to use egg, download the corresponding build artifact from releases.
Else clone this repo and follow the next steps.


```
git clone git@github.com:powerlang/egg.git
```

Then just do `make <platform>`, where platform can be `js`, `native` or `native-lmr`.

### JavaScript platform

```
make js
```

This will build the ST vm that is written in JS, and small set of core image segments.
You'll find the results in `runtime/js`, continue from there.

### Native and Native-LMR platforms

To be implemented

