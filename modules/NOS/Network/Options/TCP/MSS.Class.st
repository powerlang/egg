'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #MSS category: 'SqueakNOS-Net-Options-TCP'!
TCPOption subclass: #MSS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Options-TCP'!
!MSS methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: '{MSS='; print: self value; nextPut: $}
! !

!MSS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
value
	^ self shortAt: 3
! !

!MSS methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
value: anInteger
	self shortAt: 3 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MSS class' category: 'SqueakNOS-Net-Options-TCP'!
MSS class
	instanceVariableNames: ''!

!MSS class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	^ 4
! !

!MSS class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 2
! !


