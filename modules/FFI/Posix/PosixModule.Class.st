'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #PosixModule category: #FFI!
Module subclass: #PosixModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!PosixModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!PosixModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
externalCopyOfString: aString
	^Kernel utf8 externalCopyOf: aString
! !

!PosixModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{ #FFI -> #(ExternalLibrary ExternalMemory LibraryLoader) }
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PosixModule class' category: #FFI!
PosixModule class
	instanceVariableNames: ''!


