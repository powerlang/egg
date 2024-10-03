"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LibC,
	#superclass : #ExternalLibrary,
	#category : #FFI
}

{ #category : #accessing }
LibC class >> libname [
	^'c'
]

{ #category : #accessing }
LibC class >> linuxFilename [
	^'libc.so.6'
]

{ #category : #accessing }
LibC >> calloc: anInteger size: size [
	<cdecl: pointer calloc(pointer, pointer)>
]

{ #category : #accessing }
LibC >> free: address [
	<cdecl: void free(pointer)>
]

{ #category : #accessing }
LibC >> malloc: anInteger [
	<cdecl: pointer malloc(pointer)>
]
