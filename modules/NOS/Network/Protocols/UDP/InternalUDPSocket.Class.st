'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #InternalUDPSocket category: 'SqueakNOS-Net-Protocols-UDP'!
InternalRawSocket subclass: #InternalUDPSocket
	instanceVariableNames: 'localPort remotePort remoteAddress'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-UDP'!
!InternalUDPSocket methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ (localPort isNil or: [aPacket destination = localPort])
		and: [(remotePort isNil or: [aPacket source = remotePort])
			and: [remoteAddress isNil or: [aPacket envelope source = remoteAddress]]]
! !

!InternalUDPSocket methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
close
	self detach
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
localPort
	^ localPort
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
localPort: anInteger
	localPort := anInteger
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anUDPPacket
	| ip |
	localPort notNil ifTrue: [anUDPPacket source: localPort].
	remotePort notNil ifTrue: [anUDPPacket destination: remotePort].
	ip := IPPacket with: anUDPPacket.
	ip destination: remoteAddress.
	self << ip
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextPut: anInteger from: aByteArray startingAt: startIndex
	"Write the next anInteger elements in aByteArray, starting at startIndex. Answer the number of bytes actually written."

	| udp |
	udp := UDPPacket new: anInteger.
	udp length: udp size.
	udp replaceFrom: udp headerSize + 1 to: udp size with: aByteArray asByteArray startingAt: startIndex.
	udp source: self localPort; destination: self remotePort.
	self nextPut: udp.
	^ anInteger
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remoteAddress
	^ remoteAddress
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remoteAddress: anInternetAddress
	remoteAddress := anInternetAddress
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePort
	^ remotePort
! !

!InternalUDPSocket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
remotePort: anInteger
	remotePort := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalUDPSocket class' category: 'SqueakNOS-Net-Protocols-UDP'!
InternalUDPSocket class
	instanceVariableNames: ''!


