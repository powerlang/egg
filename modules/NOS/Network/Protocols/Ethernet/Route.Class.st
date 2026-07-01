'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Route category: 'SqueakNOS-Net-Protocols-Ethernet'!
Object subclass: #Route
	instanceVariableNames: 'destination gateway interface'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Protocols-Ethernet'!
!Route methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
destination
	^ destination
! !

!Route methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
destination: aNetBlock
	destination := aNetBlock
! !

!Route methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
gateway
	^ gateway
! !

!Route methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
gateway: aNetAddress
	gateway := aNetAddress
! !

!Route methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
interface
	^ interface
! !

!Route methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
interface: aNetInterface
	interface := aNetInterface
! !

!Route methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream print: self destination; nextPutAll: ' -> '.
	self gateway isNil ifFalse: [aStream print: self gateway; nextPutAll: ' -> '].
	aStream print: self interface
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Route class' category: 'SqueakNOS-Net-Protocols-Ethernet'!
Route class
	instanceVariableNames: ''!


