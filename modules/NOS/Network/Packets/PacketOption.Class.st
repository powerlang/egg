'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #PacketOption category: 'SqueakNOS-Net-Packets'!
ArrayedCollection subclass: #PacketOption
	instanceVariableNames: 'bytes offset'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^ bytes at: anInteger + offset
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: anObject
	^ bytes at: anInteger + offset put: anObject
! !

!PacketOption methodsFor:  'accessing-private' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	bytes := aByteArray
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	^ self type > 1 ifTrue: [self at: 2] ifFalse: [1]
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length: anInteger
	self at: 2 put: anInteger
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
longAt: anInteger
	^ (self shortAt: anInteger) * 16r10000 + (self shortAt: anInteger + 2)
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
longAt: anInteger put: aLong
	self shortAt: anInteger put: aLong // 16r10000.
	self shortAt: anInteger+2 put: aLong \\ 16r10000.
	^ aLong
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
name
	^ self type asString
! !

!PacketOption methodsFor:  'accessing-private' stamp: 'KenD 28/Jun/2026 13:32:25'!
offset: anInteger
	offset := anInteger
! !

!PacketOption methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: '{', self name, '}'
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortAt: anInteger
	^ (self at: anInteger) * 256 + (self at: anInteger+1)
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shortAt: anInteger put: aShort
	self at: anInteger put: aShort // 256.
	self at: anInteger+1 put: aShort \\ 256.
	^ aShort
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ self length
! !

!PacketOption methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
species
	^ ByteArray
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ self at: 1
! !

!PacketOption methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type: anInteger
	self at: 1 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PacketOption class' category: 'SqueakNOS-Net-Packets'!
PacketOption class
	instanceVariableNames: ''!

!PacketOption class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	^ self bytes: aByteArray offset: 0
! !

!PacketOption class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray offset: anInteger
	^ self basicNew bytes: aByteArray; offset: anInteger
! !


