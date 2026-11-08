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
LibC class >> windowsFilename [
	^'ucrtbase.dll'
]

{ #category : #accessing }
LibC >> calloc: anInteger size: size [
	<cdecl: pointer calloc(pointer, pointer)>
]

{ #category : #accessing }
LibC >> exit: anInteger [
	<cdecl: void exit(sint32)>
]

{ #category : #accessing }
LibC >> free: address [
	<cdecl: void free(pointer)>
]

{ #category : #accessing }
LibC >> malloc: anInteger [
	<cdecl: pointer malloc(pointer)>
]

{ #category : #accessing }
LibC >> timespecGet: aByteArray base: anInteger [
	<cdecl: sint32 timespec_get(pointer, sint32)>
]

{ #category : #accessing }
LibC >> write: anInteger address: aByteArray size: anotherInteger [
	<cdecl: sint64 write(sint32, pointer, uint64)>
]

{ #category : #accessing }
LibC >> close: anInteger [
	<cdecl: sint32 close(sint32)>
]

{ #category : #accessing }
LibC >> lseek: anInteger offset: offset whence: whence [
	<cdecl: sint64 lseek(sint32, sint64, sint32)>
]

{ #category : #accessing }
LibC >> open: aString flags: anInteger [
	<cdecl: sint32 open(pointer, sint32)>
]

{ #category : #services }
LibC >> openForReading: aString [
	| path |
	path := aString nullTerminated.
	^self open: path flags: 0
]

{ #category : #accessing }
LibC >> read: anInteger address: aByteArray size: anotherInteger [
	<cdecl: sint64 read(sint32, pointer, uint64)>
]
