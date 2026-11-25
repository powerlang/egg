'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPSequenceNumber category: 'SqueakNOS-Net-Support'!
Magnitude subclass: #TCPSequenceNumber
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!TCPSequenceNumber methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:32:25'!
+ anInteger
	^ self class value: value + anInteger asInteger \\ 16r100000000
! !

!TCPSequenceNumber methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:32:25'!
- anInteger
	^ self class value: value - anInteger asInteger \\ 16r100000000
! !

!TCPSequenceNumber methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
< aNumber
	^ value ~= aNumber asInteger and: [aNumber asInteger - value \\ 16r100000000 < 16r80000000]
! !

!TCPSequenceNumber methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
= aNumber
	^ value = aNumber asInteger
! !

!TCPSequenceNumber methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
adaptToInteger: rcvr andSend: selector
	^ self class value: (rcvr perform: selector with: value) \\ 16r100000000
! !

!TCPSequenceNumber methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asInteger
	^ value
! !

!TCPSequenceNumber methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hash
	^ value hash
! !

!TCPSequenceNumber methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	aStream nextPut: $[; print: self asInteger; nextPut: $]
! !

!TCPSequenceNumber methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
setValue: anInteger
	value := anInteger asInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPSequenceNumber class' category: 'SqueakNOS-Net-Support'!
TCPSequenceNumber class
	instanceVariableNames: ''!

!TCPSequenceNumber class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
value: anInteger
	^ self new setValue: anInteger
! !


