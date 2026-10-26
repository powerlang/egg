'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPTimestamp category: 'SqueakNOS-Net-Options-TCP'!
TCPOption subclass: #TCPTimestamp
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Options-TCP'!
!TCPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
echo
	^ self longAt: 7
! !

!TCPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
echo: anInteger
	self longAt: 7 put: anInteger
! !

!TCPTimestamp methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPutAll: '{TSval='; print: self value.
	self echo = 0 ifFalse: [aStream nextPutAll: ',TSecr='; print: self echo].
	aStream nextPut: $}
! !

!TCPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
value
	^ self longAt: 3
! !

!TCPTimestamp methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
value: anInteger
	self longAt: 3 put: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPTimestamp class' category: 'SqueakNOS-Net-Options-TCP'!
TCPTimestamp class
	instanceVariableNames: ''!

!TCPTimestamp class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
length
	^ 10
! !

!TCPTimestamp class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ 8
! !


