'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestCounter category: #SUnit!
Object subclass: #TestCounter
	instanceVariableNames: 'checks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!TestCounter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!TestCounter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addCounter: aTestCounter
	checks addAll: aTestCounter checks
! !

!TestCounter methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
checkDescriptions
	| description stream |
	description := OrderedCollection new.
	checks withOccurrencesDo: [:selector :total | 
		stream := '' writeStream.
		stream
			nextPutAll: '   > ';
			print: selector;
			space;
			print: total.
		description add: stream contents].
	^description
! !

!TestCounter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
checks
	^checks
! !

!TestCounter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
count: aspect
	checks add: aspect
! !

!TestCounter methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	super initialize.
	checks := Bag new
! !

!TestCounter methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:37'!
occurrencesOf: aSymbol
	^checks occurrencesOf: aSymbol
! !

!TestCounter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
reset
	checks removeAll
! !

!TestCounter methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:37'!
totalChecks
	^checks size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestCounter class' category: #SUnit!
TestCounter class
	instanceVariableNames: ''!


TestCounter initialize!

