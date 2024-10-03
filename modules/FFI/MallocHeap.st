"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that represents a dynamic library such as an so, a dll or a dylib
"

Class {
	#name : #MallocHeap,
	#superclass : #Object,
	#instVars : [
		'libc'
	],
	#category : #FFI
}

{ #category : #accessing }
MallocHeap >> allocate: anInteger [
	| address |
	address := libc calloc: anInteger size: 1.
	^ExternalMemory at: address heap: self.
]

{ #category : #accessing }
MallocHeap >> free: anExternalMemory [
	libc free: anExternalMemory asParameter.
]

{ #category : #accessing }
MallocHeap >> initialize [
	libc := FFI libc
]
