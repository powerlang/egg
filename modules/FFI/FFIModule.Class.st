'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #FFIModule category: #FFI!
Module subclass: #FFIModule
	instanceVariableNames: 'loader mallocHeap defaultHeap libc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!FFIModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!FFIModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
defaultHeap
	^defaultHeap
! !

!FFIModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(ArrayedCollection Behavior ByteArray ByteArraySegment CharacterArray Float Integer IdentitySet String WordSize)
	}
! !

!FFIModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeFor: moduleName loader: loaderName
	| module loaderType |
	module := Kernel load: moduleName.
	self namespace
		at: #FFI put: self;
		at: #OS put: module.
	loaderType := module namespace at: loaderName.
	loader := loaderType new
! !

!FFIModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeLibC
	libc := LibC new.
	loader bootstrapOpen: libc.
	defaultHeap := mallocHeap := MallocHeap new
! !

!FFIModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeForCurrentPlatform
	| platform |
	platform := Kernel host platformName.
	(platform endsWith: 'linux-gnu') ifTrue: [^self initializeForLinux].
	(platform endsWith: 'darwin') ifTrue: [^self initializeForMac].
	(platform endsWith: 'win32') ifTrue: [^self initializeForWindows].
	self error: platform, ' platform not yet supported by FFI module'
! !

!FFIModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeForLinux
	self
		initializeFor: #'FFI.Posix' loader: #PosixLibraryLoader;
		initializeLibC
! !

!FFIModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeForMac
	self initializeFor: #'FFI.Posix' loader: #PosixLibraryLoader.
	loader beMac.
	self initializeLibC.
! !

!FFIModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeForWindows
	self
		initializeFor: #'FFI.Windows' loader: #WindowsLibraryLoader;
		initializeLibC.
! !

!FFIModule methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	super initialize.
	ExternalMemory initializeConstants.
! !

!FFIModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libc
	^libc
! !

!FFIModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
loader
	^loader
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FFIModule class' category: #FFI!
FFIModule class
	instanceVariableNames: ''!


FFIModule initialize!

