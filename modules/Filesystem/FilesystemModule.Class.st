'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #FilesystemModule category: #Filesystem!
Module subclass: #FilesystemModule
	instanceVariableNames: 'library'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Filesystem'!
!FilesystemModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!FilesystemModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
imports
	^{
		#FFI -> ExternalObject
	}
! !

!FilesystemModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeWith: library
	namespace at: #Library put: library.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FilesystemModule class' category: #Filesystem!
FilesystemModule class
	instanceVariableNames: ''!


