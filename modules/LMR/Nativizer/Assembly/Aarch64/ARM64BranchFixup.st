"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	ARM64 branch instructions encode the destination offset INSIDE the
	4-byte instruction word (not as a separately-patchable byte run):
		B    has a 26-bit signed offset at bits [25:0]   (range ±128MB)
		B.cond / CBZ / CBNZ have 19-bit signed offset at bits [23:5] (±1MB)
	Both are word-relative (offset is divided by 4 from the byte delta).

	When the codegen emits a branch it writes a placeholder template (the
	full instruction word with the offset bits zeroed) and registers an
	ARM64BranchFixup. At apply-fixups time we OR the encoded offset into
	the placeholder.
"
Class {
	#name : #ARM64BranchFixup,
	#superclass : #RelocationFixup,
	#instVars : [
		'kind'
	],
	#category : #Aarch64
}

{ #category : #'instance creation' }
ARM64BranchFixup class >> kind: aSymbol from: src to: target [
	^self new beRelative; kind: aSymbol; from: src to: target; size: 4; yourself
]

{ #category : #accessing }
ARM64BranchFixup >> kind [
	^kind
]

{ #category : #accessing }
ARM64BranchFixup >> kind: aSymbol [
	kind := aSymbol
]

{ #category : #services }
ARM64BranchFixup >> patch: buffer with: solver [
	| address byteDelta wordDelta placeholder mask shift encoded half |
	address := solver resolveLabel: target.
	self ASSERT: address notNil.
	byteDelta := address - source.
	(byteDelta bitAnd: 3) = 0
		ifFalse: [self error: 'ARM64 branch target not 4-aligned'].
	wordDelta := byteDelta // 4.
	kind == #b
		ifTrue: [
			mask := 16r03FFFFFF.
			shift := 0]
		ifFalse: [
			mask := 16r0007FFFF.
			shift := 5].
	half := (mask + 1) // 2.
	(wordDelta >= (0 - half) and: [wordDelta < half])
		ifFalse: [self error: 'ARM64 branch offset out of range: ' , wordDelta printString].
	encoded := wordDelta bitAnd: mask.
	placeholder := buffer readLongAt: source.
	buffer writeLong: (placeholder bitOr: (encoded bitShift: shift)) at: source
]
