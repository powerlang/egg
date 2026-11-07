"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.

`ABI` seems to serve two different purposes:

 i) provide support for calling (native) function with system
	calling convention for given architecture and OS combination

ii) provide fixed mapping from 'IR' registers (such as A, R, M and so on)
	to real machine registers

"
Class {
	#name : #ABI,
	#superclass : #Object,
	#category : #'Nativization-Assembly'
}

{ #category : #unclassified }
ABI >> is32bits [
	^self bits = 32
]

{ #category : #unclassified }
ABI >> is64bits [
	^self bits = 64
]

{ #category : #callouts }
ABI >> bitsOf: type [
	(#(uint8 sint8 uchar schar) includes: type) ifTrue: [^8].
	(#(uint16 sint16 ushort sshort) includes: type) ifTrue: [^16].
	(#(uint32 sint32 uint sint float) includes: type) ifTrue: [^32].
	^64
]

{ #category : #callouts }
ABI >> emitCallout: types with: anAssembler loading: aBlock [
	self subclassResponsibility
]

{ #category : #callouts }
ABI >> ensureSupported: type [
	(#(longdouble complexFloat complexDouble complexLongdouble) includes: type)
		ifTrue: [self error: 'FFI type ' , type , ' not supported natively yet']
]

{ #category : #callouts }
ABI >> extendResult: type with: anAssembler [
	self subclassResponsibility
]

{ #category : #callouts }
ABI >> isFloat: type [
	^#(float double) includes: type
]

{ #category : #callouts }
ABI >> stackAreaOf: places types: types [
	^(self stackEndOf: places types: types) alignedTo: 16
]

{ #category : #callouts }
ABI >> stackBytesOf: type [
	^8
]

{ #category : #callouts }
ABI >> stackEndOf: places types: types [
	| end |
	end := 0.
	places with: types do: [:place :type | | bytes |
		bytes := self stackBytesOf: type.
		place isInteger ifTrue: [end := end max: place + bytes]].
	^end
]

{ #category : #'compile-time constants' }
ABI >> foldableConstants [
	^Dictionary new
		at: #WordSize put: self wordSize;
		at: #WordSizeShift put: self wordSizeShift;
		yourself
]

{ #category : #'registers - IR' }
ABI >> regA [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regE [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regFP [
	^ self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regFalse [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regG [
	^ self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regIP [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regM [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regNil [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regR [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regS [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regSP [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regT [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regTrue [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regV [
	^self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regX0 [
	^ self subclassResponsibility
]

{ #category : #'registers - IR' }
ABI >> regX1 [
	^ self subclassResponsibility
]

