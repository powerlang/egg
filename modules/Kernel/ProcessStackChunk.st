"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessStackChunk,
	#superclass : #Object,
	#instVars : [
		'sp',
		'bp',
		'base',
		'prev',
		'defaultReturn'
	],
	#category : #Kernel
}

{ #category : #instance-creation }
ProcessStackChunk class >> after: aProcessStackChunk [
	^self new prev: aProcessStackChunk
]

{ #category : #accessing }
ProcessStackChunk >> base [
	^base
]

{ #category : #accessing }
ProcessStackChunk >> base: anInteger [
	base := anInteger
]

{ #category : #accessing }
ProcessStackChunk >> bp [
	^bp
]

{ #category : #accessing }
ProcessStackChunk >> bp: anInteger [
	bp := anInteger
]

{ #category : #accessing }
ProcessStackChunk >> defaultReturn [
	^defaultReturn
]

{ #category : #accessing }
ProcessStackChunk >> defaultReturn: anInteger [
	defaultReturn := anInteger
]

ProcessStackChunk >> initialize [
	defaultReturn := 0
]

ProcessStackChunk >> invalidate [
	sp := bp := nil
]

ProcessStackChunk >> isForCallback [
	^prev notNil
]

{ #category : #accessing }
ProcessStackChunk >> prev [
	^prev
]

{ #category : #accessing }
ProcessStackChunk >> prev: aProcessStackChunk [
	prev := aProcessStackChunk
]

{ #category : #accessing }
ProcessStackChunk >> relocate: anInteger [
	sp ifNotNil: [
		sp := sp + anInteger.
		bp := bp + anInteger].
	base := base + anInteger
]

{ #category : #accessing }
ProcessStackChunk >> sp [
	^sp
]

{ #category : #accessing }
ProcessStackChunk >> sp: anInteger [
	sp := anInteger
]
