Class {
	#name : #TCPChannel,
	#superclass : #Conduit,
	#instVars : [
		'localPort',
		'remotePort',
		'state',
		'reassembler'
	],
	#category : 'SqueakNOS-Net-Protocols-TCP'
}

{ #category : #flow }
TCPChannel >> accepts: aPacket [
	^ ((aPacket isKindOf: TCPPacket)
		and: [localPort isNil or: [aPacket destination = localPort]])
			and: [remotePort isNil or: [aPacket source = remotePort]]
]

{ #category : #flow }
TCPChannel >> input: aPacket [
	state input: aPacket
]

{ #category : #accessing }
TCPChannel >> nextPut: anInteger from: aByteArray startingAt: startIndex [
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	| tcp |
	(tcp := TCPPacket new: anInteger)
		source: localPort;
		destination: remotePort.
	tcp replaceFrom: tcp headerSize + 1 to: tcp size with: aByteArray asByteArray startingAt: startIndex.
	self << tcp.
	^ anInteger
]
