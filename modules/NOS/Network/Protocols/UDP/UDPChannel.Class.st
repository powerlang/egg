'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #UDPChannel category: 'SqueakNOS-Net-Protocols-UDP'!
Conduit subclass: #UDPChannel
	instanceVariableNames: 'localPort remotePort'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-UDP'!
!UDPChannel methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
accepts: aPacket
	^ ((aPacket isKindOf: UDPPacket)
		and: [localPort isNil or: [aPacket destination = localPort]])
			and: [remotePort isNil or: [aPacket source = remotePort]]
! !

!UDPChannel methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ super mtu - UDPPacket headerSize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UDPChannel class' category: 'SqueakNOS-Net-Protocols-UDP'!
UDPChannel class
	instanceVariableNames: ''!


