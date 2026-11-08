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

{ #category : #services }
WindowsLibraryLoader >> bootstrapOpen: anExternalLibrary [
	| path parameter handle |
	path := anExternalLibrary class libpath, anExternalLibrary class windowsFilename.
	parameter := Kernel utf16 parameterFrom: path.
	handle := kernel32 LoadLibraryW: parameter.
	anExternalLibrary address: handle
]

{ #category : #accessing }
WindowsLibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^kernel32 GetProcAddress: anExternalLibrary lpProcName: aSymbol nullTerminated
]

{ #category : #accessing }
WindowsLibraryLoader >> initialize [
	kernel32 := KernelDLL new.
	Kernel host initializeFFI: kernel32 symbolFinder: KernelDLL >> #GetProcAddress:lpProcName:
]

{ #category : #accessing }
WindowsLibraryLoader >> libraryFilename: externalLibrary [
	^externalLibrary windowsFilename.
]

{ #category : #services }
WindowsLibraryLoader >> open: anExternalLibrary [
	| path parameter handle |
	path := anExternalLibrary class libpath, anExternalLibrary class windowsFilename.
	parameter := path externalUTF16Copy.
	handle := kernel32 LoadLibraryW: parameter.
	anExternalLibrary address: handle.
]

{ #category : #accessing }
WindowsLibraryLoader >> libcClass [
	^WindowsLibC
]
