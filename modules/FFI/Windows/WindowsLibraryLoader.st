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
	parameter := Array with: path.
	handle := kernel32 LoadLibraryW: parameter.
	anExternalLibrary handle: handle.
]

{ #category : #accessing }
WindowsLibraryLoader >> findSymbol: aSymbol in: anExternalLibrary [
	^kernel32 GetProcAddressW: anExternalLibrary asParameter lpProcName: aSymbol externalCopy asParameter.
]

{ #category : #accessing }
WindowsLibraryLoader >> initialize [
	kernel32 := KernelDLL new.
	Kernel host initializeFFI: kernel32 symbolFinder: KernelDLL >> #GetProcAddressW
]

{ #category : #accessing }
WindowsLibraryLoader >> libraryFilename: externalLibrary [
	^externalLibrary windowsFilename.
]

{ #category : #services }
WindowsLibraryLoader >> open: anExternalLibrary [
	| path handle |
	path := anExternalLibrary class libpath, anExternalLibrary class windowsFilename.
	handle := kernel32 LoadLibraryW: path externalCopy asParameter.
	anExternalLibrary address: handle.
]
