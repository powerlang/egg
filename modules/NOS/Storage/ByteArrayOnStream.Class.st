'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ByteArrayOnStream category: 'SqueakNOS-Storage'!
ArrayedCollection subclass: #ByteArrayOnStream
	instanceVariableNames: 'stream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^ self byteAt: anInteger
! !

!ByteArrayOnStream methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: byte
	^self byteAt: anInteger put: byte
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index
	^stream position: index - 1; next
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteAt: index put: anInteger
	^ stream
		position: index - 1;
		nextPut: anInteger
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesAt: byteIndex count: count
	^ stream
		position: byteIndex - 1;
		next: count
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
segmentFrom: start to: end
	^ByteArraySegment on: self from: start to: end
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ stream size
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
species
	^ByteArray
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
stream: aStream
	stream := aStream
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex
^(self bytesAt: byteIndex count: 4) unsignedLongAt: 1
! !

!ByteArrayOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex
	^(self bytesAt: byteIndex count: 2) unsignedShortAt: 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ByteArrayOnStream class' category: 'SqueakNOS-Storage'!
ByteArrayOnStream class
	instanceVariableNames: ''!

!ByteArrayOnStream class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aStream
	^ self new stream: aStream
! !


