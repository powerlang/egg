"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #Process,
	#superclass : #Object,
	#instVars : [
		'stack',
		'name',
		'protectedFrames'
		'hopping'
	],
	#category : #Kernel
}

{ #category : #evaluation }
Process >> evaluate: aBlock ensuring: ensuredBlock  [
	| result |
	result := aBlock value.
	ensuredBlock value.
	^result
]

{ #category : #private }
Process >> initialize [
	hopping := false.
	name := 'nameless process'.
	stack := ProcessVirtualStack on: self.
	self vmSpecificInitialize
]

{ #category : #private }
Process >> evaluate: aClosure ensuring: ensuredClosure [
	"
	Ensure is easy here: the closure is evaluated, and the only way to skip
	the ensuredBlock would be from a non-local return, so we assume non-local
	returns check for protected frames, evaluates all between return source and
	home frames, and then does the unwinding.
	The local `cursor` is needed-by and special-to the debugger, because it might
	have to update the frame indices if the stack frames are changed.
	"
	| cursor result prev |
	cursor := self frameIndex.
	protectedFrames push: cursor.
	result := aBlock value.
	prev := protectedFrames pop.
	prev == cursor
		ifFalse: [self
			_error: 'popped protected frame is not the same that was pushed'].
	ensuredBlock value.
	^result
]

Process >> frameIndex [
	self errorVMSpecific
]

Process >> vmSpecificInitialize [
	self errorVMSpecific
]

{ #category : #private }
Process >> wantsToStepInto [
	| answer |
	answer := hopping.
	answer ifTrue: [hopping := false].
	^answer
]

