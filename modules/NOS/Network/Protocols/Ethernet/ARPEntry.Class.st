'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ARPEntry category: 'SqueakNOS-Net-Protocols-Ethernet'!
Object subclass: #ARPEntry
	instanceVariableNames: 'hardware protocol timeout'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-Ethernet'!
!ARPEntry methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
= anARPEntry
	^ self protocol = anARPEntry protocol
! !

!ARPEntry methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardware
	^ hardware
! !

!ARPEntry methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hardware: aNetAddress
	hardware := aNetAddress
! !

!ARPEntry methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hash
	^ self protocol hash
! !

!ARPEntry methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isDynamic
	^ self isStatic not
! !

!ARPEntry methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
isStatic
	^ timeout isNil
! !

!ARPEntry methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream print: hardware; nextPutAll: ' -> '; print: protocol.
	self isStatic ifTrue: [aStream nextPutAll: ' (STATIC)']
! !

!ARPEntry methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol
	^ protocol
! !

!ARPEntry methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
protocol: aNetAddress
	protocol := aNetAddress
! !

!ARPEntry methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timeout
	^ timeout
! !

!ARPEntry methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
timeout: anInteger
	timeout := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ARPEntry class' category: 'SqueakNOS-Net-Protocols-Ethernet'!
ARPEntry class
	instanceVariableNames: ''!


