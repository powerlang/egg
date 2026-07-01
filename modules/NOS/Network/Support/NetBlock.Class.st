'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NetBlock category: 'SqueakNOS-Net-Support'!
ArrayedCollection subclass: #NetBlock
	instanceVariableNames: 'address mask'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	^ address
! !

!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
address: aNetAddress
	address := aNetAddress
! !

!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	| bits orBits newBit |
	bits := anInteger.
	orBits := (BitArray bytes: mask bytes reversed)
		collect: [ :each |
			each = 0
				ifTrue: [newBit := bits bitAnd: 1. bits := bits bitShift: -1. newBit]
				ifFalse: [0]].
	^ address & mask | (NetAddress bytes: orBits asByteArray reversed)
! !

!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
broadcast
	^ self at: self size - 1
! !

!NetBlock methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
includes: aNetAddress
	^ aNetAddress & mask = address
! !

!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mask
	^ mask
! !

!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
mask: aNetAddress
	mask := aNetAddress
! !

!NetBlock methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: aStream
	| bits index |
	aStream print: address.
	bits := BitArray bytes: mask bytes.
	index := bits findLast: [ :one | one = 1].
	index + 1 = (bits findFirst: [ :one | one = 0])
		ifTrue: [aStream nextPut: $/; print: index]
		ifFalse: [aStream space; print: mask]
! !

!NetBlock methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ 2 raisedTo: ((BitArray bytes: mask bytes) occurrencesOf: 0)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetBlock class' category: 'SqueakNOS-Net-Support'!
NetBlock class
	instanceVariableNames: ''!


