'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #HostDown category: 'SqueakNOS-Net-Exceptions'!
Error subclass: #HostDown
	instanceVariableNames: 'address'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Exceptions'!
!HostDown methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	^ address
! !

!HostDown methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: aNetAddress
	address := aNetAddress
! !

!HostDown methodsFor:  'description' stamp: 'KenD 28/Jun/2026 13:32:25'!
isResumable
	^ true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HostDown class' category: 'SqueakNOS-Net-Exceptions'!
HostDown class
	instanceVariableNames: ''!


