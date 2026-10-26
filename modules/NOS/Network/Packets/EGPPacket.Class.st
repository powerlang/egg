'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #EGPPacket category: 'SqueakNOS-Net-Packets'!
Packet subclass: #EGPPacket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Packets'!
!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
checksum
	^ self shortAt: 5
! !

!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
code
	^ self at: 3
! !

!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sequence
	^ self shortAt: 9
! !

!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
status
	^ self at: 4
! !

!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
system
	^ self shortAt: 7
! !

!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ self at: 2
! !

!EGPPacket methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
version
	^ self at: 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EGPPacket class' category: 'SqueakNOS-Net-Packets'!
EGPPacket class
	instanceVariableNames: ''!

!EGPPacket class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ 8
! !


