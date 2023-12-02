Class {
	#name : #InternalUDPSocket,
	#superclass : #InternalRawSocket,
	#instVars : [
		'localPort',
		'remotePort',
		'remoteAddress'
	],
	#category : 'SqueakNOS-Net-Protocols-UDP'
}

{ #category : #flow }
InternalUDPSocket >> accepts: aPacket [
	^ (localPort isNil or: [aPacket destination = localPort])
		and: [(remotePort isNil or: [aPacket source = remotePort])
			and: [remoteAddress isNil or: [aPacket envelope source = remoteAddress]]]
]

{ #category : #control }
InternalUDPSocket >> close [
	self detach
]

{ #category : #accessing }
InternalUDPSocket >> localPort [
	^ localPort
]

{ #category : #accessing }
InternalUDPSocket >> localPort: anInteger [
	localPort := anInteger
]

{ #category : #accessing }
InternalUDPSocket >> nextPut: anUDPPacket [
	| ip |
	localPort notNil ifTrue: [anUDPPacket source: localPort].
	remotePort notNil ifTrue: [anUDPPacket destination: remotePort].
	ip := IPPacket with: anUDPPacket.
	ip destination: remoteAddress.
	self << ip
]

{ #category : #accessing }
InternalUDPSocket >> nextPut: anInteger from: aByteArray startingAt: startIndex [
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	| udp |
	udp := UDPPacket new: anInteger.
	udp length: udp size.
	udp replaceFrom: udp headerSize + 1 to: udp size with: aByteArray asByteArray startingAt: startIndex.
	udp source: self localPort; destination: self remotePort.
	self nextPut: udp.
	^ anInteger
]

{ #category : #accessing }
InternalUDPSocket >> remoteAddress [
	^ remoteAddress
]

{ #category : #accessing }
InternalUDPSocket >> remoteAddress: anInternetAddress [
	remoteAddress := anInternetAddress
]

{ #category : #accessing }
InternalUDPSocket >> remotePort [
	^ remotePort
]

{ #category : #accessing }
InternalUDPSocket >> remotePort: anInteger [
	remotePort := anInteger
]
