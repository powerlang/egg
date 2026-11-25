'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #PosixLibraryLoader category: #FFI!
LibraryLoader subclass: #PosixLibraryLoader
	instanceVariableNames: 'dl linux'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!PosixLibraryLoader commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries in Linux and Mac. For that,
	I call dlopen and dlsym, part of dl library. To bootstrap, the dl library
	object handle and dlsym addresses are initialized through a host VM primitive.
!

!PosixLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
beMac
	linux := false
! !

!PosixLibraryLoader methodsFor:  'bootstrap' stamp: 'KenD 28/Jun/2026 13:27:37'!
bootstrapOpen: anExternalLibrary
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
! !

!PosixLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
close: anExternalLibrary
	dl dlclose: anExternalLibrary asParameter
! !

!PosixLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
findSymbol: aSymbol in: anExternalLibrary
	^dl dlsym: anExternalLibrary asParameter symbol: aSymbol externalCopy asParameter
! !

!PosixLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	linux := true.
	dl := DLLibrary new.
	Kernel host initializeFFI: dl symbolFinder: DLLibrary >> #dlsym:symbol:.
	self initializeDLErrorDescriptor
! !

!PosixLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeDLErrorDescriptor
	"
		Sending dlerror for the first time initializes libdl descriptor, through dlsym. This makes
		subsequent sends of dlerror not call dlsym, which would invalidate the last error code
	"
	dl dlerror
! !

!PosixLibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libraryFilename: externalLibrary
	^linux ifTrue: [ externalLibrary linuxFilename ] ifFalse: [ externalLibrary macFilename ]
! !

!PosixLibraryLoader methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
open: anExternalLibrary
	| filename path handle |
	filename := self libraryFilename: anExternalLibrary class.
	path := anExternalLibrary class libpath, filename.
	handle := dl dlopen: path externalCopy asParameter flags: 1. "RTLD_LAZY"
	handle = 0 ifTrue: [Error signal: dl lastError].
	anExternalLibrary address: handle
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PosixLibraryLoader class' category: #FFI!
PosixLibraryLoader class
	instanceVariableNames: ''!


PosixLibraryLoader initialize!

