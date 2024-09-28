"
    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries in Windows. For that,
	I call LoadLibrary and GetProcAddress, part of kernel32 library. That
	library object is initialized when the windows process is launched.
"

Class {
	#name : #WindowsLibraryLoader,
	#superclass : #LibraryLoader,
	#instVars : [
		'kernel32'
	],
	#category : #FFI
}

{ #category : #accessing }
WindowsLibraryLoader >> open: anExternalLibrary [
	| handle |
	handle := kernel32 LoadLibraryW: anExternalLibrary filename externalCopy.
	anExternalLibrary handle: handle.
]

{ #category : #accessing }
WindowsLibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^kernel32 GetProcAddressW: anExternalLibrary asParameter lpProcName: aSymbol externalCopy asParameter.
]
