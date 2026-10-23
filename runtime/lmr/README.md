# LMR launcher

A minimal C runtime that boots a nativized LMR (Smalltalk-in-Smalltalk)
image segment **without the C++ evaluator**. It loads an `.ems` file, relocates
its in-segment pointers, and jumps into machine code that the LMR nativizer
produced during bootstrap.

The launcher reuses the C++ runtime's `FileImageSegment` for reading and memory
reservation (see `liblmr_egg`), but it never interprets treecodes — once a
segment is relocated it calls the nativized `__start__` entry directly. That
call is a plain C function-pointer call with no per-arch trampoline: the
`<callback>` prologue (below) makes the entry ABI-conformant, so the launcher
stays ISA-agnostic.

```
load(.ems) → relocate() → run("__start__")
```

## The C → LMR callback bridge

A pure-native runtime has a chicken-and-egg problem: when C calls into
nativized code, none of the LMR machine registers are set up yet
(`regG` globals, `regNil/regTrue/regFalse`, `regM` current method,
`regE` environment). A normal nativized method *assumes* those are already
established by a previous LMR call, so C can't just jump into one.

The `<callback>` mechanism solves this. A method marked `<callback: …>` is
compiled to a `CallbackMethod` and nativized with a **callback prologue**
(`TemplateJIT>>emitCallbackPrologue` + the per-arch ABI hooks, e.g.
`AAPCS64ABI>>emitEntrypoint:with:` / `restoreContext:with:`). The prologue
rebuilds the whole LMR context from the code's own address, then falls through
to the method body; the epilogue tears it back down and returns to C.

The self-reference that makes this work is a **per-object `CallbackBehavior`**
installed on the entry's machine-code bytes:

```
[entry-4]            → CallbackBehavior           (the object's behavior header)
  behavior.nativeCode → NativeCode
    nativeCode.compiledCode → CallbackMethod
      callbackMethod.receiver → the callback receiver
```

`BootstrapperModule>>nativizeStartEntry:` builds that `CallbackBehavior` by
**mirroring** the machine-code object's real behavior (its `class`/`methods`/
`next`, so the object stays a valid byte array) and adding the `nativeCode`
back-pointer. Because the behavior is per-object rather than a shared class
behavior, the segment writer would normally treat it as an import boundary —
`CallbackBehavior>>shouldBeStoredIn:` is overridden to `^true` so it travels
inside the segment.

At entry the prologue reads `[entry-4]`, walks `behavior → nativeCode`, loads
`regM`, then loads `regG`/`regNil`/`regTrue`/`regFalse` from the method
literals and `regR` from the receiver.

## The heap block and behavior pointers

All objects live in one block of `HeapBlockSize` (4 GB), aligned to its size,
that `ReserveHeapBlock()` reserves at startup: `HEAP_ADDRESS_BLOCK` (see
`Allocator/Memory.h`, `Posix/Memory.cpp` and `Windows/Memory.cpp`). Its address
varies per run on every platform, e.g. `0x300000000`; the low 4 GB are seldom
free on Linux and never on macOS.

The first `MarkBitmapSize` (64 MB) of the block are the GC mark bitmap, a bit
per 8 bytes of the block, so the marks of an object are found from its address
alone. They take memory only where marks are written: Posix maps them lazily,
Windows commits the slice of each range it commits. The heap starts after
them, at `HEAP_BASE`.

Object headers store the behavior as a **32-bit** field at `oop-4`, not a full
pointer. Behaviors are in the block too, so the full pointer is
`field | BEHAVIOR_ADDRESS_BLOCK` (see `HeapObject::behavior()`), where
`BEHAVIOR_ADDRESS_BLOCK` is `HEAP_ADDRESS_BLOCK`.

Nativized code that dereferences a behavior therefore has to rebuild the high
bits. It can't bake the base in, as it varies per run, but every object
(the running code included) lives in the block, so the base is recoverable as
`PC & ~0xFFFFFFFF`. On aarch64 `loadLongMwithIPoffset:` loads the 32-bit field,
then `ADR`/`LSR #32`/`LSL #32` derives the block base from PC and `ORR`s it in.

## Building and testing

```
cd runtime/lmr
cmake --build build/<OS>-<arch>-<BuildType>
ctest --test-dir build/<OS>-<arch>-<BuildType> --output-on-failure
```

`test_03_relocate` checks in-segment relocation; `test_04_run` runs the
nativized `__start__` (which is `^42`) and asserts the tagged result 85. The
tests read segments from `image-segments/lmr/`, so run `egg LMR.Bootstrapper`
first to (re)generate them.
