'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #SUnitNameResolver category: #SUnit!
Object subclass: #SUnitNameResolver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!SUnitNameResolver commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SUnitNameResolver class' category: #SUnit!
SUnitNameResolver class
	instanceVariableNames: ''!

!SUnitNameResolver class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
classNamed: aSymbol
	^Smalltalk
		at: aSymbol
		ifAbsent: [nil]
! !

!SUnitNameResolver class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
defaultLogDevice
	^Transcript
! !

!SUnitNameResolver class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
errorObject
	^Error
! !

!SUnitNameResolver class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
mnuExceptionObject
	^MessageNotUnderstood
! !

!SUnitNameResolver class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
notificationObject
	^Notification
! !


