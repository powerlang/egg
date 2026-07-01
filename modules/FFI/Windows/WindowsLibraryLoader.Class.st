'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #WindowsLibraryLoader category: #FFI!
LibraryLoader subclass: #WindowsLibraryLoader
	instanceVariableNames: 'kernel32'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!WindowsLibraryLoader commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries in Windows. For that,
	I call LoadLibrary and GetProcAddress, part of kernel32 library. That
	library object is initialized when the windows process is launched.
!

!WindowsLibraryLoader methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
bootstrapOpen: anExternalLibrary
	| path parameter handle |
	path := anExternalLibrary class libpath, anExternalLibrary class windowsFilename.
	parameter := Array with: path.
	handle := kernel32 LoadLibraryW: parameter.
	anExternalLibrary handle: handle.
! !

!WindowsLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
findSymbol: aSymbol in: anExternalLibrary
	^kernel32 GetProcAddressW: anExternalLibrary asParameter lpProcName: aSymbol externalCopy asParameter.
! !

!WindowsLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	kernel32 := KernelDLL new.
	Kernel host initializeFFI: kernel32 symbolFinder: KernelDLL >> #GetProcAddressW
! !

!WindowsLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libraryFilename: externalLibrary
	^externalLibrary windowsFilename.
! !

!WindowsLibraryLoader methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
open: anExternalLibrary
	| path handle |
	path := anExternalLibrary class libpath, anExternalLibrary class windowsFilename.
	handle := kernel32 LoadLibraryW: path externalCopy asParameter.
	anExternalLibrary address: handle.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WindowsLibraryLoader class' category: #FFI!
WindowsLibraryLoader class
	instanceVariableNames: ''!


WindowsLibraryLoader initialize!

