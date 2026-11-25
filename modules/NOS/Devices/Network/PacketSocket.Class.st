'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PacketSocket category: 'SqueakNOS-Net-Devices'!
InternalNetworkDevice subclass: #PacketSocket
	instanceVariableNames: 'adapter packetClass filter promiscuous snapshot semaphore descriptor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Devices'!
!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
adapter
	^ adapter
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
adapter: aString
	self mustBeClosed.
	adapter := aString
! !

!PacketSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
close
	[self primitiveClose: descriptor] on: Error do: [:ex| Transcript cr; show: 'PacketSocket close failed'].
	Smalltalk unregisterExternalObject: semaphore
! !

!PacketSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
down
	super down.
	self close
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
filter
	^ filter
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
filter: aString
	filter := aString.
	descriptor isNil ifFalse: [self primitiveSet: descriptor filter: filter]
! !

!PacketSocket methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	adapter := 'eth0'.
	filter := ''.
	promiscuous := true.
	snapshot := 1500.
	mtu := snapshot.
	packetClass := EthernetPacket.
	semaphore := Semaphore new
! !

!PacketSocket methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
mustBeClosed
	descriptor isNil ifFalse: [^ self error: 'Socket must be closed']
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
next
	| length bytes |
	descriptor isNil ifTrue: [^ self error: 'The socket is closed'].
	semaphore wait.
	bytes := ByteArray new: snapshot+100.
	length := self primitiveRead: descriptor into: bytes startingAt: 1.
	^ packetClass bytes: (bytes copyFrom: 1 to: length)
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextPut: aPacket
	self primitiveWrite: descriptor from: aPacket bytes startingAt: aPacket offset + 1 count: aPacket size.
	^ aPacket
! !

!PacketSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
open
	| semaphoreIndex |
	self mustBeClosed.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	descriptor := self primitiveOpen: adapter snapshot: snapshot promiscuous: promiscuous semaphore: semaphoreIndex.
	self primitiveSet: descriptor filter: filter
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
packetClass
	^ packetClass
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
packetClass: aClass
	packetClass := aClass
! !

!PacketSocket methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveClose: anInteger
	<primitive: 'PacketSocketClose' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
! !

!PacketSocket methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveOpen: deviceName snapshot: anInteger promiscuous: aBoolean semaphore: aSemaphoreIndex
	<primitive: 'PacketSocketOpen' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
! !

!PacketSocket methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveRead: anInteger into: aByteArray startingAt: startIndex
	<primitive: 'PacketSocketRead' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
! !

!PacketSocket methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveSet: anInteger filter: aString
	<primitive: 'PacketSocketSetFilter' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
! !

!PacketSocket methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveWrite: anInteger from: aByteArray startingAt: start count: length
	<primitive: 'PacketSocketWrite' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
promiscuous
	^ promiscuous
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
promiscuous: aBoolean
	self mustBeClosed.
	promiscuous := aBoolean
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
snapshot
	^ snapshot
! !

!PacketSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
snapshot: anInteger
	self mustBeClosed.
	snapshot := anInteger
! !

!PacketSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
up
	super up.
	self open
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PacketSocket class' category: 'SqueakNOS-Net-Devices'!
PacketSocket class
	instanceVariableNames: ''!

!PacketSocket class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
new
	^ super new initialize
! !


PacketSocket initialize!

