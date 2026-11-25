'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ICMP category: 'SqueakNOS-Net-Protocols-IP'!
Conduit subclass: #ICMP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-IP'!
!ICMP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ aPacket isKindOf: ICMPPacket
! !

!ICMP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anICMPPacket
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
! !

!ICMP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timestamp
	"Answer the number of milliseconds past midnight, UTC."
	^ Time millisecondClockValue
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ICMP class' category: 'SqueakNOS-Net-Protocols-IP'!
ICMP class
	instanceVariableNames: ''!


