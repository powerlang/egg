"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #PosixLibC,
	#superclass : #LibC,
	#category : #FFI
}

{ #category : #memory }
PosixLibC >> mmap: address size: size protection: protection flags: flags fd: fd offset: offset [
	<cdecl: sint64 mmap(pointer, uint64, sint32, sint32, sint32, sint64)>
]

{ #category : #memory }
PosixLibC >> munmap: address size: size [
	<cdecl: sint32 munmap(pointer, uint64)>
]

{ #category : #memory }
PosixLibC >> mprotect: address size: size protection: protection [
	<cdecl: sint32 mprotect(pointer, uint64, sint32)>
]
