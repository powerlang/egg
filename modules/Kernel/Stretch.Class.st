'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Stretch category: #Kernel!
Object subclass: #Stretch
	instanceVariableNames: 'start end'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Stretch commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- delta
	^self + delta negated
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// anInteger
	^start // anInteger thru: end // anInteger
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ delta
	delta isInteger ifTrue: [^start + delta thru: end + delta].
	delta isPoint ifTrue: [^start + delta x thru: end + delta y].
	^start + delta start thru: end + delta end
! !

!Stretch methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aStretch
	self class == aStretch class ifFalse: [^false].
	^start = aStretch start and: [end = aStretch end]
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
center
	^start + end // 2
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
down: anInteger
	^start thru: end + anInteger
! !

!Stretch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
end
	^end
! !

!Stretch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
end: anInteger
	end := anInteger
! !

!Stretch methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^start hashWith: end
! !

!Stretch methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: anInteger
	^anInteger between: start and: end
! !

!Stretch methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
intersects: aStretch
	self isEmpty ifTrue: [^false].
	(aStretch includes: start) ifTrue: [^true].
	^aStretch includes: end
! !

!Stretch methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmpty
	^end < start
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
length
	^end - start + 1
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
max
	^start max: end
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
min
	^start min: end
! !

!Stretch methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	^start negated thru: end negated
! !

!Stretch methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
notEmpty
	^start <= end
! !

!Stretch methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPutAll: start asString;
		nextPutAll: ' thru: ';
		nextPutAll: end asString
! !

!Stretch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
start
	^start
! !

!Stretch methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
start: anInteger
	start := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Stretch class' category: #Kernel!
Stretch class
	instanceVariableNames: ''!

!Stretch class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: start thru: end
	^self new start: start; end: end
! !


