'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Directory category: #Filesystem!
FilesystemEntry subclass: #Directory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Filesystem'!
!Directory commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!Directory methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
/ aString
	| handle |
	handle := Library pathOperatorSlash: self path with: aString.
	^Directory new handle: handle
! !

!Directory methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPath
	^Library directoryPath: self
! !

!Directory methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
create
	Library pathCreateDirectory: self path
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Directory class' category: #Filesystem!
Directory class
	instanceVariableNames: ''!


