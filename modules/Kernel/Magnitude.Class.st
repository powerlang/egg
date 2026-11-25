'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Magnitude category: #Kernel!
Object subclass: #Magnitude
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Magnitude commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aMagnitude
	self subclassResponsibility
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aMagnitude
	self subclassResponsibility
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aMagnitude
	self subclassResponsibility
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aMagnitude
	^aMagnitude < self
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aMagnitude
	^aMagnitude <= self
! !

!Magnitude methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
addTo: aMagnitude
	^aMagnitude + self asFloat
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
between: min and: max
	^min <= self and: [self <= max]
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^self subclassResponsibility
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
max: aMagnitude
	^self > aMagnitude ifTrue: [self] ifFalse: [aMagnitude]
! !

!Magnitude methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
min: aMagnitude
	^self < aMagnitude ifTrue: [self] ifFalse: [aMagnitude]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Magnitude class' category: #Kernel!
Magnitude class
	instanceVariableNames: ''!


