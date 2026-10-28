# LMR.Nativizer.Assembly.Aarch64

The ARM64 backend of the nativizer: it turns the assembler operations of
`GenericAssembler` into machine code for 64-bit ARM processors (A64 is the name
of their instruction set). This file first explains ARM just enough to read the
code, then how this module encodes instructions.

## ARM64 in a nutshell

### Registers

- `x0` to `x30`: 31 general registers of 64 bits. `w0` to `w30` are the same
  registers seen as 32 bits.
- `sp`: the stack pointer.
- `xzr`: the zero register. It reads as 0 and ignores what is written to it.
- `d0` to `d31`: floating point registers, 64 bits (`s0` to `s31` are their low
  32 bits).
- Four condition flags, N, Z, C and V (negative, zero, carry, overflow). Like
  x86, and unlike RISC designs such as MIPS or RISC-V, which compare and branch
  in a single instruction on registers, ARM64 keeps a flags register: a compare
  sets the flags and a later instruction tests them. Unlike x86, arithmetic only
  sets them when asked to: `add` leaves them alone, `adds` sets them, and `cmp`
  is a `subs` that only keeps the flags. ARM64 also has branches on a register
  (`cbz`, `cbnz`: branch if zero, if not zero) that don't use the flags.

### Instructions

An instruction is written as a mnemonic followed by its operands, destination
first:

```
add x0, x1, x2        x0 := x1 + x2
add x0, x1, #16       x0 := x1 + 16       (# marks an immediate: a constant
                                           written inside the instruction)
sub sp, sp, #32       sp := sp - 32
cmp x0, x1            compare: sets the flags from x0 - x1, keeps no result
b.lt somewhere        branch if the last compare gave "less than"
```

Arithmetic only works on registers and immediates. Memory is only read by loads
and written by stores, with the address in brackets:

```
ldr x0, [x1, #8]      x0 := the 64 bits at address x1 + 8
str x0, [sp, #16]     the 64 bits at address sp + 16 := x0
ldrb w0, [x1]         w0 := the byte at address x1
```

### Encoding

Unlike x86, where instructions take from 1 to 15 bytes, every A64 instruction
is exactly 32 bits. Some of those bits are fixed and tell which instruction it
is; the rest are fields, at fixed positions, that hold the operands. Encoding
`add x0, sp, #16` looks like this, from bit 31 down to bit 0:

| bits  | value         | meaning                                       |
|-------|---------------|-----------------------------------------------|
| 31    | 1             | 64-bit operation (0 would be 32-bit)          |
| 30    | 0             | add (1 is sub)                                |
| 29    | 0             | don't set the flags (1 is `adds`)             |
| 28-23 | 100010        | the add/sub-with-immediate family             |
| 22    | 0             | the immediate isn't shifted left 12 bits      |
| 21-10 | 000000010000  | the immediate, 16                             |
| 9-5   | 11111         | the source register, `sp`, which is number 31 |
| 4-0   | 00000         | the destination register, `x0`                |

The fixed bits alone are `16r91000000`; placing 16 at bit 10, 31 at bit 5 and
0 at bit 0 gives the instruction, `16r910043E0`. That's all encoding is: take
the fixed bits of the right encoding and put each operand in its field.

## The subtleties

What makes it less than trivial is choosing the right encoding and checking
that an operand fits its field.

- **Register 31 is two registers.** A 5-bit register field holds 0 to 31, and
  31 means `sp` in some fields and `xzr` in others. As the destination of an
  add with an immediate, 31 is `sp` for `add` but `xzr` for `adds`: `cmp x1, #1`
  is in fact `subs xzr, x1, #1`, a subtraction whose result is thrown away.
- **Immediates don't always fit.** A field only has so many bits: `add` takes an
  unsigned immediate of 12 bits (0 to 4095). Some are scaled: `ldr x0, [x1, #imm]`
  encodes the offset divided by 8, so it reaches further but only takes
  multiples of 8. An instruction often has several encodings, and when one
  doesn't take an operand another may: `ldr` with a negative or unaligned
  offset uses its unscaled form, a signed offset of 9 bits (-256 to 255).
- **Logical immediates.** `and`, `orr`, `eor` and `tst` can't hold an arbitrary
  64-bit constant. Their 13 bits describe a pattern instead: an element of 2, 4,
  8, 16, 32 or 64 bits holding a single run of ones, rotated, and copied across
  the 64 bits. So `16rFF` fits (8 ones), `16rFFFFFFFF00000000` too (32 ones,
  rotated to the top) and `16r5555555555555555` too (the 2-bit element `01`,
  repeated), but `16r12345` doesn't: its ones aren't a single run. Neither 0 nor
  all ones fit. A constant that doesn't fit has to be loaded into a register
  first (`movz`/`movk`) and the register form used.
- **Conditions.** Conditional branches and selects test the flags through a
  4-bit condition: `eq`, `ne`, `lt`, `ge`, `vs` (overflow)...
- **Pre- and post-indexing.** `str x0, [sp, #-16]!` subtracts 16 from `sp`
  before storing, and `ldr x0, [sp], #16` adds 16 after loading, which is how
  values are pushed and popped. They are encodings of their own.

## How this module encodes

`ARM64InstructionSpec class >> encodings` holds a table of encodings written as
in the Arm Architecture Reference Manual, one per line: the syntax, a tab, and
the 32 bits from bit 31 down, as fixed 0s and 1s and named fields. The line for
the `add` above is

```
ADD Xd|SP, Xn|SP, #imm12	1 0 0 100010 0 imm12:12 Rn:5 Rd:5
```

`imm12:12` is a field named `imm12` of 12 bits, `Rn:5` a field `Rn` of 5 bits.
The syntax names the field of each operand: `Xd` is a 64-bit register that goes
to `Rd`, `Xn|SP` one that goes to `Rn` and takes `sp` as register 31, `#imm12`
an immediate that goes to `imm12`. Spaces in the bits are only for reading.
Fields are named as in the manual: `Rd` is the destination register, `Rn` and
`Rm` the sources, `Rt` the register a load or store transfers, `cond` a
condition, `hw` which 16-bit half `movz`/`movk` write, and `N`, `immr`, `imms`
the parts of a logical immediate. Pre- and post-indexed forms are named
`str.pre`, `ldr.post`...

When the module loads, each line becomes an `ARM64InstructionSpec`:

- the fixed bits become its `opcode`;
- each named field becomes an `ARM64Field`, its position and width;
- each operand in the syntax becomes an `ARM64OperandSpec` holding the field it
  goes to. The kind of operand picks the subclass:

| syntax                         | class                   |
|--------------------------------|-------------------------|
| `Xd`, `Wt`, `Dn`, `Xn\|SP`     | `ARM64RegisterOperand`  |
| `#imm12`, `#imm12*8`, `#simm9` | `ARM64ImmediateOperand` |
| `#bimm`                        | `ARM64BitmaskOperand`   |
| `cond`                         | `ARM64ConditionOperand` |
| `FPSR`                         | `ARM64FixedOperand`     |

`#imm12*8` is an immediate encoded divided by 8, `#simm9` a signed one.

To encode, `ARM64InstructionSpec encode: 'add' with: {x0. sp. 16}` takes the
first line of that mnemonic whose operands all accept the given ones, and ORs
each operand's bits into the opcode. Operands are registers, integers, condition
names (`#eq`, `#lt`, `#vs`...) and symbols.

## The rest of the backend

The nativizer was written for x86, so `GenericAssembler` asks its code
generator for x86-shaped operations: two-operand `add:to:`, `push:`,
`jumpIfCarryTo:`... `ARM64CodeGenerator` implements each one by assembling
mnemonics through `ARM64InstructionSpec` (`self assemble: 'adds' with: ...`).

- **Scratch registers.** `regV`, which the ABI maps to `x16`, is the
  generator's scratch. `x17` is a second one, used where `regV` may hold an
  operand (`lea:withMem:`, far offsets of loads and stores).
- **Immediates.** `assemble:with:withImm:` uses the immediate form when the
  table can encode the constant, and otherwise loads it into the scratch
  register and uses the register form.
- **Flags as on x86.** `add:to:`, `sub:from:`, `inc:` and `dec:` assemble as
  `adds`/`subs`, which set the flags, except with `sp`, which only plain
  `add`/`sub` can write. Carry jumps test the real carry flag (`cs`/`cc`), so
  the integer tag test and shifts by one set it as x86 does.
- **Registers.** `AAPCS64ABI` picks the registers the nativizer uses (`regR`,
  `regA`...) from the pool `ARM64Register registers` builds, which the module
  binds by name (`x0`, `sp`, `d16`...).
- **Template assembler.** `ARM64TemplateAssembler`, which the ABI hands to the
  nativizer, is generated: for each fixed `GenericAssembler` operation it holds
  the instructions the code generator emits. Regenerate it from the repo root
  after changing the code generator:

```bash
egg LMR.Nativizer.Assembly.Aarch64.TemplateGenerator
```

## Testing

```bash
egg LMR.Nativizer.Assembly.Aarch64.Tests
```

`ARM64CodeGeneratorTest` checks the instructions the code generator emits for
its operations. The expected instructions in the tests come from
`llvm-mc -triple=aarch64 -show-encoding`, LLVM's assembler, which prints the
encoding of each instruction it assembles.
