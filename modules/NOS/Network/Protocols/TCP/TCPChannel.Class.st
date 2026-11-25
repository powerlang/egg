'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPChannel category: 'SqueakNOS-Net-Protocols-TCP'!
Conduit subclass: #TCPChannel
	instanceVariableNames: 'localPort remotePort state reassembler'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-TCP'!
!TCPChannel methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ ((aPacket isKindOf: TCPPacket)
		and: [localPort isNil or: [aPacket destination = localPort]])
			and: [remotePort isNil or: [aPacket source = remotePort]]
! !

!TCPChannel methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	state input: aPacket
! !

!TCPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anInteger from: aByteArray startingAt: startIndex
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	| tcp |
	(tcp := TCPPacket new: anInteger)
		source: localPort;
		destination: remotePort.
	tcp replaceFrom: tcp headerSize + 1 to: tcp size with: aByteArray asByteArray startingAt: startIndex.
	self << tcp.
	^ anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPChannel class' category: 'SqueakNOS-Net-Protocols-TCP'!
TCPChannel class
	instanceVariableNames: ''!


