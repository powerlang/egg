'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ByteArraySegment category: 'SqueakNOS-Storage'!
ArrayedCollection subclass: #ByteArraySegment
	instanceVariableNames: 'contents offset size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!ByteArraySegment commentStamp: '<historical>' prior: 0!

I represent a logical segment of bytes inside a byte-array like object.

I remap the logical indexes accessed to indexes in the owner contents.
I can be nested.
!

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asByteArray
	^self copyFrom: 1 to: size
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^self byteAt: anInteger
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: byte
	^self byteAt: anInteger put: byte
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index
	self validateIndex: index.
	^ contents byteAt: offset + index
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index put: byte
	self validateIndex: index.
	^ contents byteAt: offset + index put: byte
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAtOffset: anInteger
	^self byteAt: anInteger + 1
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAtOffset: anInteger put: byte
	^self byteAt: anInteger + 1 put: byte
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesAtOffset: anInteger put: anByteArray
	self
		replaceFrom: anInteger + 1
		to: anInteger + anByteArray sizeInBytes
		with: anByteArray
		startingAt: 1
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
copyFrom: start to: end
	| s |
	self validateIndex: start toIndex: end.
	^contents copyFrom: offset + start to: offset + end
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
endOffset
	^offset + size
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
errorInBounds: anInteger
	self error: 'out of bounds: ', anInteger printString
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
offset
	^offset
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
offset: anInteger
	offset := anInteger
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aByteArray from: start to: stop
	contents := aByteArray.
	offset := start - 1.
	size := stop - start + 1 . size >= 0
		ifFalse: [ self halt ]
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
replaceBytes: count with: aCollection
	count > size ifTrue: [self validateIndex: count].
	self replaceFrom: 1 to: count with: aCollection
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
replaceFrom: start to: end with: another
	^self replaceFrom: start to: end with: another startingAt: 1
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
replaceFrom: start to: end with: another startingAt: index
	self validateIndex: start toIndex: end.
	^contents
		replaceFrom: offset + start
		to: offset + end
		with: another
		startingAt: index
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
segmentFrom: index size: anInteger
	^ByteArraySegment on: self from: index size: anInteger
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
segmentFrom: start to: end
	^ ByteArraySegment on: self from: start to: end
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^size
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
sizeInBytes
	^size
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedByteAt: byteIndex put: value
	contents unsignedByteAt: byteIndex + offset put: value
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex
	(1 <= byteIndex and: [ byteIndex + 3 <= size ])
		ifFalse: [ self errorInBounds: byteIndex ].
	^ contents unsignedLongAt: byteIndex + offset
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex put: value
	contents unsignedLongAt: byteIndex + offset put: value
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAtOffset: byteOffset
	^ self unsignedLongAt: byteOffset + 1
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAtOffset: byteOffset put: value
	^ self unsignedLongAt: byteOffset + 1 put: value
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex
	^ contents unsignedShortAt: byteIndex + offset
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex put: value
	contents unsignedShortAt: byteIndex + offset put: value
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAtOffset: byteOffset
	^self unsignedShortAt: byteOffset + 1
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAtOffset: byteOffset put: value
	^ self unsignedShortAt: byteOffset + 1 put: value
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
validateIndex: index
	(index between: 1 and: size) ifFalse: [self errorInBounds: index]
! !

!ByteArraySegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
validateIndex: start toIndex: end
	1 <= start ifFalse: [self errorInBounds: start].
	end <= size ifFalse: [self errorInBounds: end]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ByteArraySegment class' category: 'SqueakNOS-Storage'!
ByteArraySegment class
	instanceVariableNames: ''!

!ByteArraySegment class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aByteArray from: start size: size
	^self on: aByteArray from: start to: start + size - 1
! !

!ByteArraySegment class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aByteArray from: start to: stop
	^self new on: aByteArray from: start to: stop
! !


