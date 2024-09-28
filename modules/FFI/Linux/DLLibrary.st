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
DLLibrary >> dlopen: filename [
	<cdecl: uintptr_t dlopen (uintptr_t)>
]

{ #category : #accessing }
DLLibrary >> dlsym: handle function: functionName [
	<cdecl: uintptr_t dlsym (uintptr_t, uintptr_t)>
]
