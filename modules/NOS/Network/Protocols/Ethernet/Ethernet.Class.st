'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Ethernet category: 'SqueakNOS-Net-Protocols-Ethernet'!
Conduit subclass: #Ethernet
	instanceVariableNames: 'address arp'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-Ethernet'!
!Ethernet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	^ address
! !

!Ethernet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: anEthernetAddress
	address := anEthernetAddress
! !

!Ethernet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
arp
	^ arp
! !

!Ethernet methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	self | (arp := ARP new)
! !

!Ethernet methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: packet
	(packet destination isBroadcast or: [address isNil or: [packet destination = address]]) ifFalse: [^ self].
	super input: packet data
! !

!Ethernet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mtu
	^ super mtu - EthernetPacket headerSize
! !

!Ethernet methodsFor:  'flow' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: aPacket
	| destination |
	(aPacket isKindOf: EthernetPacket)
		ifTrue: [address notNil ifTrue: [aPacket source: address].
				^ super output: aPacket].
	(destination := arp at: aPacket destination ifAbsent: []) isNil
		ifFalse: [^ super output: ((EthernetPacket with: aPacket) source: address; destination: destination)].
	arp request: aPacket destination enqueue: aPacket
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ethernet class' category: 'SqueakNOS-Net-Protocols-Ethernet'!
Ethernet class
	instanceVariableNames: ''!


Ethernet initialize!

