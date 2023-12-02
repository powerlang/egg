Class {
	#name : #PacketSocketPlugin,
	#superclass : #Object,
	#category : 'SqueakNOS-Net-Devices'
}

{ #category : #primitive }
PacketSocketPlugin >> primitiveClose: descriptor [
	self primitive: 'PacketSocketClose' parameters: #(SmallInteger).
	self cCode: 'sqPacketSocketClose(descriptor)'
]

{ #category : #primitive }
PacketSocketPlugin >> primitiveOpen: deviceName snapshot: anInteger promiscuous: aBoolean semaphoreIndex: semIndex [
	| stringSize descriptor |
	self primitive: 'PacketSocketOpen' parameters: #(String SmallInteger Boolean SmallInteger).
	stringSize _ interpreterProxy slotSizeOf: (deviceName asOop: String).
	descriptor _ self cCode: 'sqPacketSocketOpen(deviceName, stringSize, anInteger, aBoolean, semIndex)'.
	^ descriptor asSmallIntegerObj
]

{ #category : #primitive }
PacketSocketPlugin >> primitiveRead: descriptor into: aByteArray startingAt: startIndex [
	"Read next packet into aByteArray and answer its length."
	| bufferSize bytesRead |
	self primitive: 'PacketSocketRead' parameters: #(SmallInteger ByteArray SmallInteger).
	bufferSize _ interpreterProxy slotSizeOf: (aByteArray asOop: ByteArray).
	bytesRead _ self cCode: 'sqPacketSocketRead(descriptor, aByteArray, startIndex, bufferSize)'.
	^ bytesRead asSmallIntegerObj
]

{ #category : #primitive }
PacketSocketPlugin >> primitiveSet: descriptor filter: aString [
	| stringSize |
	self primitive: 'PacketSocketSetFilter' parameters: #(SmallInteger String).
	stringSize _ interpreterProxy slotSizeOf: (aString asOop: String).
	self cCode: 'sqPacketSocketSetFilter(descriptor, aString, stringSize)'
]

{ #category : #primitive }
PacketSocketPlugin >> primitiveWrite: descriptor from: aByteArray startingAt: startIndex count: count [
	self primitive: 'PacketSocketWrite' parameters: #(SmallInteger ByteArray SmallInteger SmallInteger).
	self cCode: 'sqPacketSocketWrite(descriptor, aByteArray, startIndex, count)'
]
