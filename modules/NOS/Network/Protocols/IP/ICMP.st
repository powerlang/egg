Class {
	#name : #ICMP,
	#superclass : #Conduit,
	#category : 'SqueakNOS-Net-Protocols-IP'
}

{ #category : #flow }
ICMP >> accepts: aPacket [
	^ aPacket isKindOf: ICMPPacket
]

{ #category : #flow }
ICMP >> input: anICMPPacket [
	| answer |
	anICMPPacket verifiesChecksum ifFalse: [^ self error: 'Bad checksum'].
	anICMPPacket isTimestampRequest
		ifTrue: [(answer := anICMPPacket envelope copy) data
					type: 14; "TimestampReply"
					receiveTimestamp: self timestamp;
					transmitTimestamp: self timestamp;
					setChecksum.
				answer swapSourceAndDestination.
				^ self << answer].
	anICMPPacket isEchoRequest
		ifTrue: [(answer := anICMPPacket envelope copy) data
					type: 0; "EchoReply"
					setChecksum.
				answer swapSourceAndDestination.
				^ self << answer].
	anICMPPacket isDestinationUnreachable
		ifTrue: [self triggerEvent: #destinationUnreachable: with: anICMPPacket].
	super input: anICMPPacket
]

{ #category : #accessing }
ICMP >> timestamp [
	"Answer the number of milliseconds past midnight, UTC."
	^ Time millisecondClockValue
]
