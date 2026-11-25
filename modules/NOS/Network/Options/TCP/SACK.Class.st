'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #SACK category: 'SqueakNOS-Net-Options-TCP'!
TCPOption subclass: #SACK
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Options-TCP'!
!SACK methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockAt: anInteger
	| firstIndex |
	firstIndex := anInteger - 1 * 8 + 2 + 1.
	^ Interval
		from: (TCPSequenceNumber value: (self longAt: firstIndex))
		to: (TCPSequenceNumber value: (self longAt: firstIndex + 4))
! !

!SACK methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blocks
	^ (1 to: self numberOfBlocks) collect: [ :each | self blockAt: each]
! !

!SACK methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfBlocks
	^ self size - 2 // 8
! !

!SACK methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: '{SACK'.
	self numberOfBlocks > 0 ifFalse: [aStream nextPut: $=].
	self blocks do: [ :each | aStream print: each first; nextPut: $-; print: each last] separatedBy: [aStream nextPut: $,].
	aStream nextPut: $}
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SACK class' category: 'SqueakNOS-Net-Options-TCP'!
SACK class
	instanceVariableNames: ''!

!SACK class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	^ self shouldNotImplement
! !

!SACK class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new: anInteger
	| length |
	length := anInteger * 4 * 2 + 2.
	^ self bytes:
		((ByteArray new: length)
				at: 1 put: self type;
				at: 2 put: length;
				yourself)
! !

!SACK class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 5
! !


