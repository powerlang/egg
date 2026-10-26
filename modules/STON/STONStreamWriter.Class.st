'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONStreamWriter category: #STON!
Object subclass: #STONStreamWriter
	instanceVariableNames: 'writer first'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STONStreamWriter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!STONStreamWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
add: anObject
	first ifTrue: [first := false] ifFalse: [self comma].
	writer nextPut: anObject
! !

!STONStreamWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: key put: value
	first ifTrue: [first := false] ifFalse: [self comma].
	writer encodeKey: key value: value
! !

!STONStreamWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
comma
	writer comma
! !

!STONStreamWriter methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	first := true
! !

!STONStreamWriter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aSTONWriter
	writer := aSTONWriter
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONStreamWriter class' category: #STON!
STONStreamWriter class
	instanceVariableNames: ''!

!STONStreamWriter class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aSTONWriter
	^self new on: aSTONWriter
! !


STONStreamWriter initialize!

