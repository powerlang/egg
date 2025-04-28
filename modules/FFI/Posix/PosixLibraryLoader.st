"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries in Linux and Mac. For that,
	I call dlopen and dlsym, part of dl library. To bootstrap, the dl library
	object handle and dlsym addresses are initialized through a host VM primitive.
"

Class {
	#name : #PosixLibraryLoader,
	#superclass : #LibraryLoader,
	#instVars : [
		'dl',
		'linux'
	],
	#category : #FFI
}

{ #category : #accessing }
PosixLibraryLoader >> beMac [
	linux := false
]

{ #category : #bootstrap }
PosixLibraryLoader >> bootstrapOpen: anExternalLibrary [
	"
		We do this because externalCopy asParameter requires libc/calloc to be already loaded
	"
	| filename path parameter handle |
	filename := self libraryFilename: anExternalLibrary class.
	path := anExternalLibrary class libpath, filename.
	parameter := Array with: path.
	handle := filename = 'libc.dylib'
		ifTrue: [dl handle asInteger]
		ifFalse: [dl dlopen: parameter flags: 1. "RTLD_LAZY"].
	handle = 0 ifTrue: [dl lastError].
	anExternalLibrary address: handle.
]

{ #category : #accessing }
PosixLibraryLoader >> close: anExternalLibrary [
	dl dlclose: anExternalLibrary asParameter
]

{ #category : #accessing }
PosixLibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^dl dlsym: anExternalLibrary asParameter symbol: aSymbol externalCopy asParameter
]

{ #category : #accessing }
PosixLibraryLoader >> initialize [
	linux := true.
	dl := DLLibrary new.
	Kernel host initializeFFI: dl symbolFinder: DLLibrary >> #dlsym:symbol:.
	self initializeDLErrorDescriptor
]

{ #category : #accessing }
PosixLibraryLoader >> initializeDLErrorDescriptor [
	"
		Sending dlerror for the first time initializes libdl descriptor, through dlsym. This makes
		subsequent sends of dlerror not call dlsym, which would invalidate the last error code
	"
	dl dlerror
]
{ #category : #accessing }
PosixLibraryLoader >> libraryFilename: externalLibrary [
	^linux ifTrue: [ externalLibrary linuxFilename ] ifFalse: [ externalLibrary macFilename ]
]

{ #category : #services }
PosixLibraryLoader >> open: anExternalLibrary [
	| filename path handle |
	filename := self libraryFilename: anExternalLibrary class.
	path := anExternalLibrary class libpath, filename.
	handle := dl dlopen: path externalCopy asParameter flags: 1. "RTLD_LAZY"
	handle = 0 ifTrue: [Error signal: dl lastError].
	anExternalLibrary address: handle
]
