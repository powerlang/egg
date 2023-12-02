Class {
	#name : #UDP,
	#superclass : #Conduit,
	#category : 'SqueakNOS-Net-Protocols-UDP'
}

{ #category : #flow }
UDP >> accepts: aPacket [
	^ aPacket isKindOf: UDPPacket
]

{ #category : #accessing }
UDP >> handleDestinationUnreachable: anICMPPacket [
	Transcript cr; show: 'destination unreachable: ', anICMPPacket printString
]

{ #category : #flow }
UDP >> input: anUDPPacket [
	anUDPPacket verifiesChecksum ifFalse: [^ self].
	anUDPPacket envelope source isUnicast ifFalse: [^ self].
	super input: anUDPPacket
]

{ #category : #accessing }
UDP >> ip [
	^ self left
]

{ #category : #accessing }
UDP >> left: anIP [
	super left: anIP.
	anIP icmp when: #destinationUnreachable: send: #handleDestinationUnreachable: to: self
]

{ #category : #protocol }
UDP >> socketAt: localPort [
	^ self | (InternalUDPSocket new localPort: localPort)
]

{ #category : #protocol }
UDP >> socketTo: remoteAddress port: remotePort [
	| localPort |
	localPort := (0 to: 65535) atRandom. self flag: #hack.
	^ self | (InternalUDPSocket new localPort: localPort; remoteAddress: remoteAddress; remotePort: remotePort)
]

{ #category : #protocol }
UDP >> socketTo: remoteAddress port: remotePort localPort: localPort [
	^ self | (InternalUDPSocket new localPort: localPort; remoteAddress: remoteAddress; remotePort: remotePort)
]

{ #category : #flow }
UDP >> undeliverable: aPacket [
	| icmp ip |
	icmp := (ICMPPacket quote: aPacket envelope)
		typeName: #DestinationUnreachable;
		codeName: #PortUnreachable.
	ip := (IPPacket with: icmp)
		source: aPacket envelope destination;
		destination: aPacket envelope source.
	self << ip
]
