Class {
	#name : #PacketSocket,
	#superclass : #InternalNetworkDevice,
	#instVars : [
		'adapter',
		'packetClass',
		'filter',
		'promiscuous',
		'snapshot',
		'semaphore',
		'descriptor'
	],
	#category : 'SqueakNOS-Net-Devices'
}

{ #category : #'instance creation' }
PacketSocket class >> new [
	^ super new initialize
]

{ #category : #accessing }
PacketSocket >> adapter [
	^ adapter
]

{ #category : #accessing }
PacketSocket >> adapter: aString [
	self mustBeClosed.
	adapter := aString
]

{ #category : #control }
PacketSocket >> close [
	[self primitiveClose: descriptor] on: Error do: [:ex| Transcript cr; show: 'PacketSocket close failed'].
	Smalltalk unregisterExternalObject: semaphore
]

{ #category : #control }
PacketSocket >> down [
	super down.
	self close
]

{ #category : #accessing }
PacketSocket >> filter [
	^ filter
]

{ #category : #accessing }
PacketSocket >> filter: aString [
	filter := aString.
	descriptor isNil ifFalse: [self primitiveSet: descriptor filter: filter]
]

{ #category : #initialization }
PacketSocket >> initialize [
	super initialize.
	adapter := 'eth0'.
	filter := ''.
	promiscuous := true.
	snapshot := 1500.
	mtu := snapshot.
	packetClass := EthernetPacket.
	semaphore := Semaphore new
]

{ #category : #private }
PacketSocket >> mustBeClosed [
	descriptor isNil ifFalse: [^ self error: 'Socket must be closed']
]

{ #category : #accessing }
PacketSocket >> next [
	| length bytes |
	descriptor isNil ifTrue: [^ self error: 'The socket is closed'].
	semaphore wait.
	bytes := ByteArray new: snapshot+100.
	length := self primitiveRead: descriptor into: bytes startingAt: 1.
	^ packetClass bytes: (bytes copyFrom: 1 to: length)
]

{ #category : #accessing }
PacketSocket >> nextPut: aPacket [
	self primitiveWrite: descriptor from: aPacket bytes startingAt: aPacket offset + 1 count: aPacket size.
	^ aPacket
]

{ #category : #control }
PacketSocket >> open [
	| semaphoreIndex |
	self mustBeClosed.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	descriptor := self primitiveOpen: adapter snapshot: snapshot promiscuous: promiscuous semaphore: semaphoreIndex.
	self primitiveSet: descriptor filter: filter
]

{ #category : #accessing }
PacketSocket >> packetClass [
	^ packetClass
]

{ #category : #accessing }
PacketSocket >> packetClass: aClass [
	packetClass := aClass
]

{ #category : #primitives }
PacketSocket >> primitiveClose: anInteger [
	<primitive: 'PacketSocketClose' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
]

{ #category : #primitives }
PacketSocket >> primitiveOpen: deviceName snapshot: anInteger promiscuous: aBoolean semaphore: aSemaphoreIndex [
	<primitive: 'PacketSocketOpen' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
]

{ #category : #primitives }
PacketSocket >> primitiveRead: anInteger into: aByteArray startingAt: startIndex [
	<primitive: 'PacketSocketRead' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
]

{ #category : #primitives }
PacketSocket >> primitiveSet: anInteger filter: aString [
	<primitive: 'PacketSocketSetFilter' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
]

{ #category : #primitives }
PacketSocket >> primitiveWrite: anInteger from: aByteArray startingAt: start count: length [
	<primitive: 'PacketSocketWrite' module: 'PacketSocketPlugin'>
	^ self primitiveFailed
]

{ #category : #accessing }
PacketSocket >> promiscuous [
	^ promiscuous
]

{ #category : #accessing }
PacketSocket >> promiscuous: aBoolean [
	self mustBeClosed.
	promiscuous := aBoolean
]

{ #category : #accessing }
PacketSocket >> snapshot [
	^ snapshot
]

{ #category : #accessing }
PacketSocket >> snapshot: anInteger [
	self mustBeClosed.
	snapshot := anInteger
]

{ #category : #control }
PacketSocket >> up [
	super up.
	self open
]
