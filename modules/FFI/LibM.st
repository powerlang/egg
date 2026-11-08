"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LibM,
	#superclass : #ExternalLibrary,
	#category : #FFI
}

{ #category : #accessing }
LibM class >> libname [
	^'m'
]

{ #category : #accessing }
LibM class >> linuxFilename [
	^'libm.so.6'
]

{ #category : #accessing }
LibM class >> windowsFilename [
	^'ucrtbase.dll'
]

{ #category : #trigonometry }
LibM >> atan: aFloat [
	<cdecl: double atan(double)>
]

{ #category : #trigonometry }
LibM >> cos: aFloat [
	<cdecl: double cos(double)>
]

{ #category : #logarithms }
LibM >> exp: aFloat [
	<cdecl: double exp(double)>
]

{ #category : #logarithms }
LibM >> log: aFloat [
	<cdecl: double log(double)>
]

{ #category : #trigonometry }
LibM >> sin: aFloat [
	<cdecl: double sin(double)>
]

{ #category : #trigonometry }
LibM >> tan: aFloat [
	<cdecl: double tan(double)>
]
