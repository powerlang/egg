'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #LibraryLoader category: #FFI!
Object subclass: #LibraryLoader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!LibraryLoader commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that allows loading dynamic libraries. My subclasses know
	how to do it in each platform.
!

!LibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
open: anExternalLibrary
	self subclassResponsibility
! !

!LibraryLoader methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
findSymbol: aSymbol in: anExternalLibrary
	^self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LibraryLoader class' category: #FFI!
LibraryLoader class
	instanceVariableNames: ''!


