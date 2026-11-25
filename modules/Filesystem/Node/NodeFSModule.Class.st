'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NodeFSModule category: #NodeFSModule!
Module subclass: #NodeFSModule
	instanceVariableNames: 'library'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NodeFSModule'!
!NodeFSModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!NodeFSModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{}
! !

!NodeFSModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
newLibrary
	^NodeFilesystemLibrary new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NodeFSModule class' category: #NodeFSModule!
NodeFSModule class
	instanceVariableNames: ''!


