"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	A logical immediate, the constant of and, orr, eor and tst. Its 13 bits
	can't hold any 64-bit value, so they describe one built in three steps:
	take an element of 2, 4, 8, 16, 32 or 64 bits, fill it with a run of
	ones from its bit 0, rotate it right within the element, and copy it
	until it fills the 64 bits. Changing each step gives different masks:

		64-bit element, 8 ones                       16r00000000000000FF
		64-bit element, 32 ones, rotated by 32       16rFFFFFFFF00000000
		64-bit element, 2 ones, rotated by 1         16r8000000000000001
		16-bit element, 8 ones                       16r00FF00FF00FF00FF
		16-bit element, 4 ones, rotated by 4         16rF000F000F000F000
		8-bit element, 1 one                         16r0101010101010101
		2-bit element, 1 one                         16r5555555555555555

	The run never fills the whole element, so 0 and all ones can't be
	encoded, and neither can a value whose ones don't form such a pattern,
	like 16r12345. imms encodes the element size and the number of ones,
	immr the rotation, and N is set for 64-bit elements.
"

Class {
	#name : #ARM64BitmaskOperand,
	#superclass : #ARM64OperandSpec,
	#instVars : [
		'n',
		'immr',
		'imms'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64BitmaskOperand class >> fields: aDictionary [
	| n immr imms |
	n := aDictionary at: 'N'.
	immr := aDictionary at: 'immr'.
	imms := aDictionary at: 'imms'.
	^self new n: n immr: immr imms: imms
]

{ #category : #accessing }
ARM64BitmaskOperand >> n: nField immr: immrField imms: immsField [
	n := nField.
	immr := immrField.
	imms := immsField
]

{ #category : #encoding }
ARM64BitmaskOperand >> accepts: operand [
	^operand isInteger and: [(self bitsOf: operand) notNil]
]

{ #category : #encoding }
ARM64BitmaskOperand >> encode: operand [
	| bits nBits immrBits immsBits |
	bits := self bitsOf: operand.
	nBits := n place: bits first.
	immrBits := immr place: bits second.
	immsBits := imms place: bits third.
	^(nBits bitOr: immrBits) bitOr: immsBits
]

{ #category : #private }
ARM64BitmaskOperand >> bitsOf: anInteger [
	| value size element rotation run ones |
	value := anInteger < 0 ifTrue: [16r10000000000000000 + anInteger] ifFalse: [anInteger].
	(value = 0 or: [value = 16rFFFFFFFFFFFFFFFF]) ifTrue: [^nil].
	size := self elementSizeOf: value.
	element := value bitAnd: (1 bitShift: size) - 1.
	rotation := self rotationOf: element size: size.
	rotation isNil ifTrue: [^nil].
	run := self rotate: element left: rotation size: size.
	ones := run highBit.
	^{size = 64 ifTrue: [1] ifFalse: [0].
		rotation.
		((0 - size) * 2 bitOr: ones - 1) bitAnd: 16r3F}
]

{ #category : #private }
ARM64BitmaskOperand >> elementSizeOf: value [
	| size half mask |
	size := 64.
	[size > 2 and: [
		half := size // 2.
		mask := (1 bitShift: half) - 1.
		(value bitAnd: mask) = ((value bitShift: half negated) bitAnd: mask)]]
		whileTrue: [size := half].
	^size
]

{ #category : #private }
ARM64BitmaskOperand >> rotationOf: element size: size [
	0 to: size - 1 do: [:r | | rotated |
		rotated := self rotate: element left: r size: size.
		(rotated bitAnd: rotated + 1) = 0 ifTrue: [^r]].
	^nil
]

{ #category : #private }
ARM64BitmaskOperand >> rotate: element left: count size: size [
	| high low |
	high := element bitShift: count.
	low := element bitShift: count - size.
	^(high bitOr: low) bitAnd: (1 bitShift: size) - 1
]
