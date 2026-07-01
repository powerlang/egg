'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #StreamOnStream category: 'SqueakNOS-Storage'!
PositionableStream subclass: #StreamOnStream
	instanceVariableNames: 'contentLength offset stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	| contents  pos |
	pos := self position.
	self position: 0.
	contents := self next: self size.
	self position: pos.
	^contents
! !

!StreamOnStream methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^self basicNew
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next
	^stream next
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
next: anInteger
	^stream next: anInteger
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: aCharacter
	self atEnd ifFalse: [
		(stream nextPut: aCharacter) ifNotNil: [:char | 
			position := position + 1.
			^char
		]
	]
! !

!StreamOnStream methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aStream
	^self on: aStream offset: 0.
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aStream from: anIndex to: anOffset
	stream := aStream clone.
	stream setFrom: anIndex to: anOffset.
	self setFrom: 1 to: anOffset - anIndex.
	offset := anIndex.
	self binary
! !

!StreamOnStream methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aStream offset: anOffset
	^self on: aStream offset: anOffset size: aStream size - anOffset.
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
position
	^position
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
position: aNumber
	position := aNumber.
	stream position: offset + aNumber
		
! !

!StreamOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ readLimit
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StreamOnStream class' category: 'SqueakNOS-Storage'!
StreamOnStream class
	instanceVariableNames: ''!


