"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I represent dl, the library used in linux to dynamically load other libraries.
"

Class {
	#name : #DLLibrary,
	#superclass : #ExternalLibrary,
	#category : #FFI
}

{ #category : #accessing }
DLLibrary >> dlerror [
	<cdecl: pointer dlerror ()>
]

{ #category : #accessing }
DLLibrary >> dlopen: filename flags: flags [
	<cdecl: pointer dlopen (pointer, sint)>
]

{ #category : #accessing }
DLLibrary >> dlsym: handle symbol: functionName [
	<cdecl: pointer dlsym (pointer, pointer)>
]

{ #category : #accessing }
DLLibrary >> lastError [
	| address cstring |
	address := self dlerror.
	address = 0 ifTrue: [self error: 'no error message when a dlerror was expected'].
	cstring := ExternalMemory at: address.
	String fromMemory: cstring
]