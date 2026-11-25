'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestFailure category: #SUnit!
Exception subclass: #TestFailure
	instanceVariableNames: 'resumable'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!TestFailure commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!TestFailure methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isResumable
	^resumable notNil and: [resumable]
! !

!TestFailure methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
resumable: aBoolean
	resumable := aBoolean
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestFailure class' category: #SUnit!
TestFailure class
	instanceVariableNames: ''!

!TestFailure class methodsFor:  'sunit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitSignalWith: aString resumable: aBoolean
	^self new description: aString; resumable: aBoolean; signal
! !


