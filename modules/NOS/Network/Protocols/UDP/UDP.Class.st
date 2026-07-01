'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #UDP category: 'SqueakNOS-Net-Protocols-UDP'!
Conduit subclass: #UDP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-UDP'!
!UDP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ aPacket isKindOf: UDPPacket
! !

!UDP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleDestinationUnreachable: anICMPPacket
	Transcript cr; show: 'destination unreachable: ', anICMPPacket printString
! !

!UDP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: anUDPPacket
	anUDPPacket verifiesChecksum ifFalse: [^ self].
	anUDPPacket envelope source isUnicast ifFalse: [^ self].
	super input: anUDPPacket
! !

!UDP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
ip
	^ self left
! !

!UDP methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
left: anIP
	super left: anIP.
	anIP icmp when: #destinationUnreachable: send: #handleDestinationUnreachable: to: self
! !

!UDP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
socketAt: localPort
	^ self | (InternalUDPSocket new localPort: localPort)
! !

!UDP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
socketTo: remoteAddress port: remotePort
	| localPort |
	localPort := (0 to: 65535) atRandom. self flag: #hack.
	^ self | (InternalUDPSocket new localPort: localPort; remoteAddress: remoteAddress; remotePort: remotePort)
! !

!UDP methodsFor:  'protocol' stamp: 'KenD 28/Jun/2026 13:32:25'!
socketTo: remoteAddress port: remotePort localPort: localPort
	^ self | (InternalUDPSocket new localPort: localPort; remoteAddress: remoteAddress; remotePort: remotePort)
! !

!UDP methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
undeliverable: aPacket
	| icmp ip |
	icmp := (ICMPPacket quote: aPacket envelope)
		typeName: #DestinationUnreachable;
		codeName: #PortUnreachable.
	ip := (IPPacket with: icmp)
		source: aPacket envelope destination;
		destination: aPacket envelope source.
	self << ip
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UDP class' category: 'SqueakNOS-Net-Protocols-UDP'!
UDP class
	instanceVariableNames: ''!


