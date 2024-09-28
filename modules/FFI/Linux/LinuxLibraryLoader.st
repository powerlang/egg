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

{ #category : #accessing }
LinuxLibraryLoader >> close: anExternalLibrary [
	dl dlclose: anExternalLibrary asParameter.
]

{ #category : #accessing }
LinuxLibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^dl dlsym: anExternalLibrary asParameter symbol: aSymbol externalCopy asParameter.
]

{ #category : #accessing }
LinuxLibraryLoader >> open: anExternalLibrary [
	| handle |
	handle := dl dlopen: anExternalLibrary unixFilename.
	anExternalLibrary handle: handle.
]