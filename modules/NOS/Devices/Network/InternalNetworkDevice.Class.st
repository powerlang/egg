'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #InternalNetworkDevice category: 'SqueakNOS-Net-Devices'!
Stream subclass: #InternalNetworkDevice
	instanceVariableNames: 'mtu'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Devices'!
!InternalNetworkDevice methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
atEnd
	^ self subclassResponsibility
! !

!InternalNetworkDevice methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
down
	^ self
! !

!InternalNetworkDevice methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	mtu := 1024
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
input: aPacket
	self triggerEvent: #input: with: aPacket
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mtu
	^ mtu
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mtu: anInteger
	mtu := anInteger
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
next
	^ self nextPacket
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextPacket
	^ self subclassResponsibility
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextPut: aPacket
	^ self nextPacketPut: aPacket
! !

!InternalNetworkDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
output: aPacket
	^ self subclassResponsibility
! !

!InternalNetworkDevice methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' mtu='; print: self mtu
! !

!InternalNetworkDevice methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:24'!
up
	^ self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalNetworkDevice class' category: 'SqueakNOS-Net-Devices'!
InternalNetworkDevice class
	instanceVariableNames: ''!

!InternalNetworkDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
new
	^ self basicNew initialize
! !


InternalNetworkDevice initialize!

