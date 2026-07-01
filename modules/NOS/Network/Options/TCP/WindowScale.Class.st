'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #WindowScale category: 'SqueakNOS-Net-Options-TCP'!
TCPOption subclass: #WindowScale
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Options-TCP'!
!WindowScale methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
factor
	^ 1 bitShift: self shift
! !

!WindowScale methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
factor: anInteger
	self shift: anInteger highBit - 1
! !

!WindowScale methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: '{WSopt='; print: self factor; nextPut: $}
! !

!WindowScale methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shift
	^ self at: 3
! !

!WindowScale methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
shift: anInteger
	self at: 3 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WindowScale class' category: 'SqueakNOS-Net-Options-TCP'!
WindowScale class
	instanceVariableNames: ''!

!WindowScale class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	^ 3
! !

!WindowScale class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 3
! !


