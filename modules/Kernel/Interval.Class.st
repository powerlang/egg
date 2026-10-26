'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Interval category: #Kernel!
ArrayedCollection subclass: #Interval
	instanceVariableNames: 'start end step'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Interval commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Interval methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- delta
	^start - delta to: end - delta by: step
! !

!Interval methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ delta
	^start + delta to: end + delta by: step
! !

!Interval methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asStretch
	^start thru: end
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	| answer |
	anInteger > 0 ifTrue: [
		answer := start + (anInteger - 1 * step).
		(step > 0 and: [answer between: start and: end]) ifTrue: [^answer].
		(step < 0 and: [answer between: end and: start]) ifTrue: [^answer].
		anInteger = self size ifTrue: [^end]].
	^self outOfBoundsIndex: anInteger
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: aNumber
	^self shouldNotImplement
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: anInteger
	| answer |
	answer := start + (anInteger - 1 * step).
	(step > 0 and: [answer between: start and: end]) ifTrue: [^answer].
	(step < 0 and: [answer between: end and: start]) ifTrue: [^answer].
	^end
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
end
	^end
! !

!Interval methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: startInteger to: endInteger step: stepInteger
	start := startInteger.
	end := endInteger.
	step := stepInteger.
	step = 0 ifTrue: [^self error: 'zero size steps not allowed']
! !

!Interval methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
intersection: aCollection
	| s e |
	aCollection class == self class ifFalse: [^super intersection: aCollection].
	step = aCollection step ifFalse: [^super intersection: aCollection].
	self isEmpty ifTrue: [^#()].
	aCollection isEmpty ifTrue: [^#()].
	s := start max: aCollection first.
	e := end min: aCollection last.
	^s <= e ifTrue: [s to: e by: step] ifFalse: [^#()]
! !

!Interval methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPut: $(;
		nextPutAll: start storeString;
		nextPutAll: ' to: ';
		nextPutAll: end storeString.
	step = 1
		ifFalse: [aStream nextPutAll: ' by: '; nextPutAll: step storeString].
	aStream nextPut: $)
! !

!Interval methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
reversed
	^self class from: end to: start by: step negated
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	| size x |
	size := 0 max: end - start // step + 1.
	x := step * size + start.
	((step < 0 and: [end <= x]) or: [step > 0 and: [x <= end]])
		ifTrue: [size := size + 1].
	^size
! !

!Interval methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
species
	^Array
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
start
	^start
! !

!Interval methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
step
	^step
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Interval class' category: #Kernel!
Interval class
	instanceVariableNames: ''!

!Interval class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: beginningInteger to: endInteger
	^self from: beginningInteger to: endInteger by: 1
! !

!Interval class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: beginningInteger to: endInteger by: incrementInteger
	^self basicNew from: beginningInteger to: endInteger step: incrementInteger
! !


