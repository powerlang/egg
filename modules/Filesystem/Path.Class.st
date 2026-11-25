'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Path category: #Filesystem!
ExternalObject subclass: #Path
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Filesystem'!
!Path commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!Path methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
/ aString
	^Path new handle: (Library pathOperatorSlash: self with: aString)
! !

!Path methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
asDirectory
	| handle |
	handle := Library directoryFromPath: self.
	handle = 0 ifTrue: [^self error: 'operation failed'].
	^Directory new handle: handle
! !

!Path methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
createDirectory
	^Library pathCreateDirectory: self
! !

!Path methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
exists
	^Library pathExists: self
! !

!Path methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^Library pathFilename: self
! !

!Path methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
remove
	^Library pathRemove: self
! !

!Path methodsFor:  'releasing' stamp: 'KenD 28/Jun/2026 13:27:39'!
remove
	^Library pathRelease: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Path class' category: #Filesystem!
Path class
	instanceVariableNames: ''!

!Path class methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: aString
	^self handle: (Library newPath: aString)
! !


