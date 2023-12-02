Class {
	#name : #TCP,
	#superclass : #Conduit,
	#category : 'SqueakNOS-Net-Protocols-TCP'
}

{ #category : #flow }
TCP >> accepts: aPacket [
	^ aPacket isKindOf: TCPPacket
]

{ #category : #protocol }
TCP >> connectTo: remoteAddress port: remotePort [
	^ NetStream on: (self socketTo: remoteAddress port: remotePort) connect
]

{ #category : #flow }
TCP >> input: aTCPPacket [
	aTCPPacket verifiesChecksum ifFalse: [^ self].
	aTCPPacket envelope source isUnicast ifFalse: [^ self].
	super input: aTCPPacket
]

{ #category : #accessing }
TCP >> ip [
	^ self left
]

{ #category : #protocol }
TCP >> listenAt: localPort [
	^ NetStream on: (self socketAt: localPort) listen
]

{ #category : #protocol }
TCP >> socketAt: localPort [
	^ self | (InternalTCPSocket new localPort: localPort)
]

{ #category : #protocol }
TCP >> socketTo: remoteAddress port: remotePort [
	| localPort |
	localPort := (0 to: 65535) atRandom. self flag: #hack.
	^ self socketTo: remoteAddress port: remotePort localPort: localPort
]

{ #category : #protocol }
TCP >> socketTo: remoteAddress port: remotePort localPort: localPort [
	^ self | (InternalTCPSocket new localPort: localPort; remoteAddress: remoteAddress; remotePort: remotePort)
]

{ #category : #flow }
TCP >> undeliverable: aPacket [
	| tcp ip |
	aPacket syn ifFalse: [^ self].
	tcp := (TCPPacket new: 0)
		source: aPacket destination;
		destination: aPacket source;
		rst: true;
		ack: true;
		sequence: 0;
		ackSequence: aPacket sequence + 1.
	ip := (IPPacket with: tcp)
		source: aPacket envelope destination;
		destination: aPacket envelope source.
	self << ip
]
