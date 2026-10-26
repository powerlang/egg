'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PacketSocketPlugin category: 'SqueakNOS-Net-Devices'!
Object subclass: #PacketSocketPlugin
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Devices'!
!PacketSocketPlugin methodsFor:  'primitive' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveClose: descriptor
	self primitive: 'PacketSocketClose' parameters: #(SmallInteger).
	self cCode: 'sqPacketSocketClose(descriptor)'
! !

!PacketSocketPlugin methodsFor:  'primitive' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveOpen: deviceName snapshot: anInteger promiscuous: aBoolean semaphoreIndex: semIndex
	| stringSize descriptor |
	self primitive: 'PacketSocketOpen' parameters: #(String SmallInteger Boolean SmallInteger).
	stringSize _ interpreterProxy slotSizeOf: (deviceName asOop: String).
	descriptor _ self cCode: 'sqPacketSocketOpen(deviceName, stringSize, anInteger, aBoolean, semIndex)'.
	^ descriptor asSmallIntegerObj
! !

!PacketSocketPlugin methodsFor:  'primitive' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveRead: descriptor into: aByteArray startingAt: startIndex
	"Read next packet into aByteArray and answer its length."
	| bufferSize bytesRead |
	self primitive: 'PacketSocketRead' parameters: #(SmallInteger ByteArray SmallInteger).
	bufferSize _ interpreterProxy slotSizeOf: (aByteArray asOop: ByteArray).
	bytesRead _ self cCode: 'sqPacketSocketRead(descriptor, aByteArray, startIndex, bufferSize)'.
	^ bytesRead asSmallIntegerObj
! !

!PacketSocketPlugin methodsFor:  'primitive' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveSet: descriptor filter: aString
	| stringSize |
	self primitive: 'PacketSocketSetFilter' parameters: #(SmallInteger String).
	stringSize _ interpreterProxy slotSizeOf: (aString asOop: String).
	self cCode: 'sqPacketSocketSetFilter(descriptor, aString, stringSize)'
! !

!PacketSocketPlugin methodsFor:  'primitive' stamp: 'KenD 28/Jun/2026 13:32:24'!
primitiveWrite: descriptor from: aByteArray startingAt: startIndex count: count
	self primitive: 'PacketSocketWrite' parameters: #(SmallInteger ByteArray SmallInteger SmallInteger).
	self cCode: 'sqPacketSocketWrite(descriptor, aByteArray, startIndex, count)'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PacketSocketPlugin class' category: 'SqueakNOS-Net-Devices'!
PacketSocketPlugin class
	instanceVariableNames: ''!


