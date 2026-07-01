'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ExternalLibrary category: #FFI!
Object subclass: #ExternalLibrary
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!ExternalLibrary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that represents a dynamic library such as an so, a dll or a dylib
!

!ExternalLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
address
	^handle pointerAtOffset: 0
! !

!ExternalLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
address: anInteger
	handle pointerAtOffset: 0 put: anInteger
! !

!ExternalLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
handle
	^handle
! !

!ExternalLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
loader
	^ExternalLibrary module loader
! !

!ExternalLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	handle := ExternalHandle new
! !

!ExternalLibrary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
open
	self loader open: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExternalLibrary class' category: #FFI!
ExternalLibrary class
	instanceVariableNames: ''!

!ExternalLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
filename
	^self loader libraryFilename: self
! !

!ExternalLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
libpath
	^''
! !

!ExternalLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
linuxFilename
	^'lib', self libname, '.so'
! !

!ExternalLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
macFilename
	^'lib', self libname, '.dylib'
! !

!ExternalLibrary class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
windowsFilename
	^self libname, '.dll'
! !


ExternalLibrary initialize!

