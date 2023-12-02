Class {
	#name : #Ethernet,
	#superclass : #Conduit,
	#instVars : [
		'address',
		'arp'
	],
	#category : 'SqueakNOS-Net-Protocols-Ethernet'
}

{ #category : #accessing }
Ethernet >> address [
	^ address
]

{ #category : #accessing }
Ethernet >> address: anEthernetAddress [
	address := anEthernetAddress
]

{ #category : #accessing }
Ethernet >> arp [
	^ arp
]

{ #category : #initialization }
Ethernet >> initialize [
	super initialize.
	self | (arp := ARP new)
]

{ #category : #flow }
Ethernet >> input: packet [
	(packet destination isBroadcast or: [address isNil or: [packet destination = address]]) ifFalse: [^ self].
	super input: packet data
]

{ #category : #accessing }
Ethernet >> mtu [
	^ super mtu - EthernetPacket headerSize
]

{ #category : #flow }
Ethernet >> output: aPacket [
	| destination |
	(aPacket isKindOf: EthernetPacket)
		ifTrue: [address notNil ifTrue: [aPacket source: address].
				^ super output: aPacket].
	(destination := arp at: aPacket destination ifAbsent: []) isNil
		ifFalse: [^ super output: ((EthernetPacket with: aPacket) source: address; destination: destination)].
	arp request: aPacket destination enqueue: aPacket
]
