"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRClosure,
	#superclass : #Closure,
	#category : #Kernel
}

{ #category : '*handling' }
LMRClosure >> evaluateAtomically [
	| enabled |
	enabled := Processor enableInterrupts: false.
	^self ensure: [Processor enableInterrupts: enabled]
]

{ #category : '*handling' }
LMRClosure >> evaluateWith: value [
	block argumentCount = 1 ifFalse: [^self arityError: 1].
	self _transferControlTo: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> evaluateWith: anObject with: anotherObject [
	block argumentCount = 2
		ifFalse: [^super evaluateWith: anObject with: anotherObject].
	self _transferControlTo: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> value [
	block argumentCount = 0 ifFalse: [^self arityError: 0].
	self _transferControlTo: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> value: first [
	block argumentCount = 1 ifFalse: [^self arityError: 1].
	self _transferControlTo: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> value: first value: second [
	block argumentCount = 2 ifFalse: [^self arityError: 2].
	self _transferControlTo: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> value: first value: second value: third [
	block argumentCount = 3 ifFalse: [^self arityError: 3].
	self _transferControlTo: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> valueWithArguments: arguments [
	| size |
	size := arguments basicSize.
	block argumentCount = size ifFalse: [^self arityError: size].
	arguments _expandInStackSized: size.
	^self _invoke: block blockNativeCode
]

{ #category : '*handling' }
LMRClosure >> whileFalse: aBlock [
	self value ifTrue: [^nil].
	aBlock value.
	self _restart
]

{ #category : '*handling' }
LMRClosure >> whileTrue: aBlock [
	self value ifFalse: [^nil].
	aBlock value.
	self _restart
]




