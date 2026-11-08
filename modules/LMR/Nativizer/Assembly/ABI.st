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

{ #category : #callbacks }
ABI >> callbackFloatRegisters [
	^self subclassResponsibility
]

{ #category : #callbacks }
ABI >> callbackIntegerRegisters [
	^self subclassResponsibility
]

{ #category : #callbacks }
ABI >> callbackRegisters [
	^self callbackIntegerRegisters , self callbackFloatRegisters
]

{ #category : #callbacks }
ABI >> callbackBufferSizeOf: anFFIDescriptor [
	| stack |
	stack := self callbackStackBytesOf: anFFIDescriptor.
	^self callbackRegisters size * 8 + stack alignedTo: 16
]

{ #category : #callbacks }
ABI >> callbackOffsetOf: place [
	| registers index |
	registers := self callbackRegisters.
	place isInteger ifTrue: [^registers size * 8 + place].
	index := registers indexOf: place.
	^index - 1 * 8
]

{ #category : #callbacks }
ABI >> callbackOffsetsOf: anFFIDescriptor [
	| places |
	places := self placesOf: anFFIDescriptor argumentTypeNames.
	^places collect: [:place | self callbackOffsetOf: place]
]

{ #category : #callbacks }
ABI >> callbackStackBytesOf: anFFIDescriptor [
	| types places |
	types := anFFIDescriptor argumentTypeNames.
	places := self placesOf: types.
	^self stackEndOf: places types: types
]

{ #category : #callbacks }
ABI >> checkCallback: anFFIDescriptor [
	| types |
	types := anFFIDescriptor argumentTypeNames copyWith: anFFIDescriptor returnTypeName.
	(types includes: #float) ifTrue: [^self error: 'float callbacks are not supported']
]

{ #category : #callbacks }
ABI >> loadCallbackResult: anFFIDescriptor with: anAssembler [
	| codegen result size |
	codegen := anAssembler codegen.
	anAssembler callPushesReturnAddress ifTrue: [anAssembler popA].
	anFFIDescriptor argumentCount + 1 timesRepeat: [anAssembler popA].
	result := codegen memRef: self regSP indexImm: 1.
	size := self callbackBufferSizeOf: anFFIDescriptor.
	codegen
		load: self regR fromMem: result;
		moveDouble: self regR into: self callbackFloatRegisters first;
		addImm: size to: self regSP
]

{ #category : #callbacks }
ABI >> spill: register at: anInteger with: aCodegen [
	| slot |
	slot := aCodegen memRef: self regSP indexImm: anInteger.
	aCodegen store: register intoMem: slot
]

{ #category : #callbacks }
ABI >> spillCallbackArguments: anFFIDescriptor with: anAssembler [
	| codegen size |
	self checkCallback: anFFIDescriptor.
	codegen := anAssembler codegen.
	size := self callbackBufferSizeOf: anFFIDescriptor.
	codegen subImm: size from: self regSP.
	self
		spillIntegerRegistersWith: codegen;
		spillFloatRegistersWith: codegen;
		spillStackArguments: anFFIDescriptor with: codegen.
	codegen move: self regSP to: self regR.
	anAssembler setSafeRintegerBit; pushR
]

{ #category : #callbacks }
ABI >> spillFloatRegistersWith: aCodegen [
	| first |
	first := self callbackIntegerRegisters size.
	self callbackFloatRegisters withIndexDo: [:register :i |
		aCodegen moveDouble: register into: self regV.
		self spill: self regV at: first + i with: aCodegen]
]

{ #category : #callbacks }
ABI >> spillIntegerRegistersWith: aCodegen [
	self callbackIntegerRegisters withIndexDo: [:register :i |
		self spill: register at: i with: aCodegen]
]

{ #category : #callbacks }
ABI >> spillStackArguments: anFFIDescriptor with: aCodegen [
	| first count |
	first := self callbackRegisters size.
	count := (self callbackStackBytesOf: anFFIDescriptor) // 8.
	1 to: count do: [:i | | argument |
		argument := aCodegen memRef: self regFP stackIndexImm: 3.
		argument displacement: argument displacement + (i - 1 * 8).
		aCodegen load: self regV fromMem: argument.
		self spill: self regV at: first + i with: aCodegen]
]
