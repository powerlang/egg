'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #WindowsModule category: #FFI!
Module subclass: #WindowsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!WindowsModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!WindowsModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
externalCopyOfString: aString
	^Kernel utf16 externalCopyOf: aString
! !

!WindowsModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{ #FFI -> #(ExternalLibrary LibraryLoader) }
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WindowsModule class' category: #FFI!
WindowsModule class
	instanceVariableNames: ''!


