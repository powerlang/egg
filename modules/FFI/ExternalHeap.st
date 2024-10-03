"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that represents a dynamic library such as an so, a dll or a dylib
"

Class {
	#name : #ExternalHeap,
	#superclass : #Object,
	#instVars : [
		'clib'
	],
	#category : #FFI
}

{ #category : #accessing }
ExternalHeap >> allocate: anInteger [
	^self subclassResponsibility
]

{ #category : #accessing }
ExternalHeap >> free: anExternalMemory [
	^self subclassResponsibility
]

