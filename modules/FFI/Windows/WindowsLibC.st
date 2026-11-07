"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #WindowsLibC,
	#superclass : #LibC,
	#category : #FFI
}

{ #category : #accessing }
WindowsLibC >> timespecGet: aByteArray base: anInteger [
	<cdecl: sint32 _timespec64_get(pointer, sint32)>
]

{ #category : #accessing }
WindowsLibC >> write: anInteger address: aByteArray size: anotherInteger [
	<cdecl: sint32 _write(sint32, pointer, uint32)>
]
