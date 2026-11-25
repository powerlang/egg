'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Segment category: 'SqueakNOS-Storage'!
Interval subclass: #Segment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!Segment methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
intersects: anotherSegment
	start > anotherSegment stop ifTrue: [^false].
	stop < anotherSegment start ifTrue: [^false].
	^true.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Segment class' category: 'SqueakNOS-Storage'!
Segment class
	instanceVariableNames: ''!


