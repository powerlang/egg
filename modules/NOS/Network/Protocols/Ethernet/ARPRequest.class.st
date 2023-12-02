Class {
	#name : #ARPRequest,
	#superclass : #Object,
	#instVars : [
		'arp',
		'protocol',
		'retryTime',
		'pendingPackets',
		'tries'
	],
	#category : 'SqueakNOS-Net-Protocols-Ethernet'
}

{ #category : #'instance creation' }
ARPRequest class >> new [
	^ super new initialize
]

{ #category : #accessing }
ARPRequest >> arp: anARP [
	arp := anARP
]

{ #category : #accessing }
ARPRequest >> delete [
	arp requests remove: self ifAbsent: []
]

{ #category : #accessing }
ARPRequest >> enqueue: aPacket [
	pendingPackets add: aPacket
]

{ #category : #initialization }
ARPRequest >> initialize [
	pendingPackets := OrderedCollection new: 1.
	tries := 0
]

{ #category : #printing }
ARPRequest >> printOn: aStream [
	aStream nextPutAll: 'who-has '; print: protocol; nextPutAll: ' ('; print: tries; nextPutAll: ' tries, '; print: pendingPackets size; nextPutAll: ' packets pending)'
]

{ #category : #accessing }
ARPRequest >> protocol [
	^ protocol
]

{ #category : #accessing }
ARPRequest >> protocol: aNetAddress [
	protocol := aNetAddress
]

{ #category : #accessing }
ARPRequest >> reply: anARPPacket [
	arp cacheAt: anARPPacket senderProtocolAddress put: anARPPacket senderHardwareAddress.
	pendingPackets do: [ :each | arp << each].
	self delete
]

{ #category : #accessing }
ARPRequest >> retryTime [
	^ retryTime
]

{ #category : #accessing }
ARPRequest >> retryTime: time [
	retryTime := time
]

{ #category : #'old api' }
ARPRequest >> send [
	| packet ethernet |
	tries := tries + 1.
	packet := (ARPPacket new: 42)
		opcodeName: #Request;
		senderHardwareAddress: arp hardwareAddress;
		senderProtocolAddress: arp protocolAddress;
		targetProtocolAddress: protocol.
	ethernet := (EthernetPacket with: packet)
		destination: EthernetAddress broadcast.
	arp << ethernet
]

{ #category : #accessing }
ARPRequest >> tries [
	^ tries
]
