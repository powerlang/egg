'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #Loopback category: 'SqueakNOS-Net-Devices'!
InternalNetworkDevice subclass: #Loopback
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Devices'!
!Loopback methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	mtu := 1536
! !

!Loopback methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
input: aPacket
	self triggerEvent: #input: with: aPacket
! !

!Loopback methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
output: aPacket
	^ self input: aPacket
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Loopback class' category: 'SqueakNOS-Net-Devices'!
Loopback class
	instanceVariableNames: ''!


Loopback initialize!

