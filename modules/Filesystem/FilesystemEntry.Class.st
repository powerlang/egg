'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #FilesystemEntry category: #Filesystem!
ExternalObject subclass: #FilesystemEntry
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Filesystem'!
!FilesystemEntry commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.
!

!FilesystemEntry methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPath
	^self subclassResponsibility
! !

!FilesystemEntry methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
directory
	^self parent asDirectory
! !

!File methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
exists
	^self path exists
! !

!FilesystemEntry methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
path
	^Path new handle: self basicPath
! !

!FilesystemEntry methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parent
	^Path new handle: (Library pathParent: self)
! !

!FilesystemEntry methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:39'!
remove
	^self path remove
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FilesystemEntry class' category: #Filesystem!
FilesystemEntry class
	instanceVariableNames: ''!

!FilesystemEntry class methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: aString
	^self new handle: (Library pathNew: aString)
! !


