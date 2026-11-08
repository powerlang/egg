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

{ #category : #accessing }
WindowsLibC >> close: anInteger [
	<cdecl: sint32 _close(sint32)>
]

{ #category : #accessing }
WindowsLibC >> lseek: anInteger offset: offset whence: whence [
	<cdecl: sint64 _lseeki64(sint32, sint64, sint32)>
]

{ #category : #services }
WindowsLibC >> openForReading: aString [
	| path fd |
	path := aString externalUTF16Copy.
	fd := self wopen: path flags: 16r8000.
	path free.
	^fd
]

{ #category : #accessing }
WindowsLibC >> read: anInteger address: aByteArray size: anotherInteger [
	<cdecl: sint32 _read(sint32, pointer, uint32)>
]

{ #category : #accessing }
WindowsLibC >> wopen: aByteArray flags: anInteger [
	<cdecl: sint32 _wopen(pointer, sint32)>
]
