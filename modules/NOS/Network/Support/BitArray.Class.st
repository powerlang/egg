'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #BitArray category: 'SqueakNOS-Net-Support'!
ArrayedCollection subclass: #BitArray
	instanceVariableNames: 'contents bitSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Support'!
!BitArray methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asByteArray
	^ ((1 to: self byteSize) collect: [ :each | self atByte: each]) asByteArray
! !

!BitArray methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
asInteger
	^ contents
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger
	^ (contents bitShift: 1-anInteger) bitAnd: 1
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anInteger put: bit
	contents := contents bitOr: (bit bitShift: anInteger-1).
	^ bit
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
atByte: anInteger
	^ (contents bitShift: 1-anInteger*8) bitAnd: 16rFF
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
atByte: anInteger put: byte
	contents := contents bitOr: (byte bitShift: anInteger-1*8).
	^ byte
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bitSize
	^ bitSize
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
byteSize
	^ self bitSize - 1 // 8 + 1
! !

!BitArray methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: anInteger
	contents := anInteger
! !

!BitArray methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hex
	| stream |
	stream := WriteStream with: '16r'.
	self asByteArray do: [ :each |
		stream
			nextPut: ('0123456789ABCDEF' at: each // 16 + 1);
			nextPut: ('0123456789ABCDEF' at: each \\ 16 + 1)].
	^ stream contents


! !

!BitArray methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize: anInteger
	bitSize := anInteger.
	contents := 0
! !

!BitArray methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^ self bitSize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BitArray class' category: 'SqueakNOS-Net-Support'!
BitArray class
	instanceVariableNames: ''!

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
byte: anInteger
	^ self new: 8 with: anInteger
! !

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aByteArray
	| integer |
	integer := 0.
	aByteArray reverseDo: [ :each | integer _ integer * 256 + each].
	^ self new: aByteArray size * 8 with: integer
! !

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
double: anInteger
	^ self new: 32 with: anInteger
! !

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new: anInteger
	^ self basicNew initialize: anInteger
! !

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new: bitSize with: bits
	^ (self new: bitSize) contents: bits
! !

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
quad: anInteger
	^ self new: 64 with: anInteger
! !

!BitArray class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
word: anInteger
	^ self new: 16 with: anInteger
! !


