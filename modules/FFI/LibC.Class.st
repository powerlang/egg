'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #LibC category: #FFI!
ExternalLibrary subclass: #LibC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!LibC commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
!

!LibC methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
calloc: anInteger size: size
	<cdecl: pointer calloc(pointer, pointer)>
! !

!LibC methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
free: address
	<cdecl: void free(pointer)>
! !

!LibC methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
malloc: anInteger
	<cdecl: pointer malloc(pointer)>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibC class' category: #FFI!
LibC class
	instanceVariableNames: ''!

!LibC class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libname
	^'c'
! !

!LibC class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
linuxFilename
	^'libc.so.6'
! !


