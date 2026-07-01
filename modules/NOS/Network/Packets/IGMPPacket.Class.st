'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IGMPPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #IGMPPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum
	^ self shortAt: 3
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum: anInteger
	self shortAt: 3 put: anInteger
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
code
	^ self at: 2
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
code: anInteger
	self at: 2 put: anInteger
! !

!IGMPPacket methodsFor:  'helpers' stamp: 'KenD 28/Jun/2026 13:32:25'!
computeChecksum
	^ 0
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
group
	^ self longAt: 5
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
group: anInteger
	self longAt: 5 put: anInteger
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ self at: 1
! !

!IGMPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type: anInteger
	self at: 1 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IGMPPacket class' category: 'SqueakNOS-Net-Packets'!
IGMPPacket class
	instanceVariableNames: ''!

!IGMPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
headerSize
	^ 8
! !

!IGMPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ 2
! !


