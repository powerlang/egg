'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #NetworkingDevice category: 'SqueakNOS-Devices-Network'!
PCIDevice subclass: #NetworkingDevice
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Network'!
!NetworkingDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
down
! !

!NetworkingDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
input: pkt
	"a packet coming from media"
	self triggerEvent: #input: with: pkt.

! !

!NetworkingDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
mtu
	" 1536 - 4 (for Ethernet CRC)"
	^ 1532
! !

!NetworkingDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
output: aPacket
	^ self sendNow: aPacket
! !

!NetworkingDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
up
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetworkingDevice class' category: 'SqueakNOS-Devices-Network'!
NetworkingDevice class
	instanceVariableNames: ''!

!NetworkingDevice class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPCIEntry: aPCIBusEntry computer: aComputer
	| answer |
	answer := super onPCIEntry: aPCIBusEntry computer: aComputer.
	aComputer defaultNetworkInterface: answer.
	^answer
! !


