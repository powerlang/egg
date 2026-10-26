'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NetAddress category: 'SqueakNOS-Net-Support'!
ArrayedCollection subclass: #NetAddress
	instanceVariableNames: 'bytes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!NetAddress methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:32:25'!
& aNetAddress
	| newBytes |
	newBytes := ByteArray new: bytes size.
	1 to: bytes size do: [ :each | newBytes at: each put: ((bytes at: each) bitAnd: (aNetAddress bytes at: each))].
	^ self class bytes: newBytes
! !

!NetAddress methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
/ anInteger
	^ NetBlock new address: self; mask: (self class bytes: (BitArray new: self size * 8 with: (1 bitShift: anInteger) - 1) asByteArray)
! !

!NetAddress methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
= aNetAddress
	^ self class = aNetAddress class and: [bytes = aNetAddress bytes]
! !

!NetAddress methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asByteArray
	^ bytes
! !

!NetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^ bytes at: anInteger
! !

!NetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: byte
	^ self shouldNotImplement
! !

!NetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes
	^ bytes
! !

!NetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	bytes := aByteArray asByteArray
! !

!NetAddress methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hash
	^ bytes hash
! !

!NetAddress methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:32:25'!
not
	^ self class bytes: (bytes collect: [ :each | each bitInvert])
! !

!NetAddress methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ bytes size
! !

!NetAddress methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:32:25'!
xor: aNetAddress
	| newBytes |
	newBytes := ByteArray new: bytes size.
	1 to: bytes size do: [ :each | newBytes at: each put: ((bytes at: each) bitXor: (aNetAddress bytes at: each))].
	^ self class bytes: newBytes
! !

!NetAddress methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:32:25'!
| aNetAddress
	| newBytes |
	newBytes := ByteArray new: bytes size.
	1 to: bytes size do: [ :each | newBytes at: each put: ((bytes at: each) bitOr: (aNetAddress bytes at: each))].
	^ self class bytes: newBytes
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NetAddress class' category: 'SqueakNOS-Net-Support'!
NetAddress class
	instanceVariableNames: ''!

!NetAddress class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	^ self new bytes: aByteArray
! !

!NetAddress class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
type
	^ nil
! !


