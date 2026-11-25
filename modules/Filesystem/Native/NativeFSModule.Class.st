'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NativeFSModule category: #NativeFSModule!
Module subclass: #NativeFSModule
	instanceVariableNames: 'library'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NativeFSModule'!
!NativeFSModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!NativeFSModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#FFI -> ExternalLibrary
	}
! !

!NativeFSModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
newLibrary
	^CPPFilesystemLibrary new open
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativeFSModule class' category: #NativeFSModule!
NativeFSModule class
	instanceVariableNames: ''!


