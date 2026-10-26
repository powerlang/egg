'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCP category: 'SqueakNOS-Net-Protocols-TCP'!
Conduit subclass: #TCP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP'!
!TCP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ aPacket isKindOf: TCPPacket
! !

!TCP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
connectTo: remoteAddress port: remotePort
	^ NetStream on: (self socketTo: remoteAddress port: remotePort) connect
! !

!TCP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aTCPPacket
	aTCPPacket verifiesChecksum ifFalse: [^ self].
	aTCPPacket envelope source isUnicast ifFalse: [^ self].
	super input: aTCPPacket
! !

!TCP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
ip
	^ self left
! !

!TCP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
listenAt: localPort
	^ NetStream on: (self socketAt: localPort) listen
! !

!TCP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
socketAt: localPort
	^ self | (InternalTCPSocket new localPort: localPort)
! !

!TCP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
socketTo: remoteAddress port: remotePort
	| localPort |
	localPort := (0 to: 65535) atRandom. self flag: #hack.
	^ self socketTo: remoteAddress port: remotePort localPort: localPort
! !

!TCP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
socketTo: remoteAddress port: remotePort localPort: localPort
	^ self | (InternalTCPSocket new localPort: localPort; remoteAddress: remoteAddress; remotePort: remotePort)
! !

!TCP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
undeliverable: aPacket
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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCP class' category: 'SqueakNOS-Net-Protocols-TCP'!
TCP class
	instanceVariableNames: ''!


