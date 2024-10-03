"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries in Linux. For that,
	I call dlopen and dlsym, part of dl library. That library is initialized
	when the linux process is launched.
"

Class {
	#name : #LinuxLibraryLoader,
	#superclass : #LibraryLoader,
	#instVars : [
		'dl'
	],
	#category : #FFI
}

{ #category : #bootstrap }
LinuxLibraryLoader >> bootstrapOpen: anExternalLibrary [
	"
		We do this because externalCopy asParameter requires libc/calloc to be already loaded
	"
	| path parameter handle |
	path := anExternalLibrary class libpath, anExternalLibrary class linuxFilename.
	parameter := Array with: path. 
	handle := dl dlopen: parameter flags: 1. "RTLD_LAZY"
	handle = 0 ifTrue: [dl lastError].
	anExternalLibrary address: handle.
]

{ #category : #accessing }
LinuxLibraryLoader >> close: anExternalLibrary [
	dl dlclose: anExternalLibrary asParameter.
]

{ #category : #accessing }
LinuxLibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^dl dlsym: anExternalLibrary asParameter symbol: aSymbol externalCopy asParameter.
]

{ #category : #accessing }
LinuxLibraryLoader >> initialize [
	dl := DLLibrary new.
	Kernel host initializeFFI: dl symbolFinder: DLLibrary >> #dlsym:symbol:.
	self initializeDLErrorDescriptor
]

{ #category : #accessing }
LinuxLibraryLoader >> initializeDLErrorDescriptor [
	"
		Sending dlerror for the first time initializes its descriptor, through dlsym. This makes
		subsequent sends of dlerror not call dlsym, which would invalidate the last error code
	"
	dl dlerror
]
{ #category : #accessing }
LinuxLibraryLoader >> libraryFilename: externalLibrary [
	^externalLibrary linuxFilename
]

{ #category : #services }
LinuxLibraryLoader >> open: anExternalLibrary [
	| path handle |
	path := anExternalLibrary class libpath, anExternalLibrary class linuxFilename.
	handle := dl dlopen: path externalCopy asParameter flags: 1. "RTLD_LAZY"
	handle = 0 ifTrue: [dl lastError].
	anExternalLibrary address: handle.
]
