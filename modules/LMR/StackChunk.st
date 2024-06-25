"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #StackChunk,
	#superclass : #Object,
	#instVars : [
		'sp',
		'bp',
		'base',
		'prev'
	],
	#category : #Kernel
}

{ #category : #queries }
StackChunk class >> after: aCallbackStackLink [
	^self new prev: aCallbackStackLink
]

{ #category : #accessing }
StackChunk >> base [
	^base
]

{ #category : #accessing }
StackChunk >> base: anInteger [
	base := anInteger
]

{ #category : #accessing }
StackChunk >> bp [
	^bp
]

{ #category : #accessing }
StackChunk >> bp: anInteger [
	bp := anInteger
]

{ #category : #initialization }
StackChunk >> callbacksDo: aBlock [
	| chunk |
	chunk := self.
	[chunk isForCallback] whileTrue: [
		aBlock value: chunk.
		chunk := chunk prev]
]

{ #category : #testing }
StackChunk >> isForCallback [
	^prev notNil
]

{ #category : #accessing }
StackChunk >> prev [
	^prev
]

{ #category : #accessing }
StackChunk >> prev: aCallbackStackLink [
	prev := aCallbackStackLink
]

{ #category : #initialization }
StackChunk >> recordStackPointers [
	| frame dropped |
	frame := StackFrameCursor top.
	dropped := 4.
	dropped timesRepeat: [frame moveNext].
	bp := frame current.
	sp := frame previous + 8 _asPointer
		- 8 _asPointer "is going to push 2 arguments for ffiCall:withArguments"
]

{ #category : #accessing }
StackChunk >> sp [
	^sp
]

{ #category : #accessing }
StackChunk >> sp: anInteger [
	sp := anInteger
]

