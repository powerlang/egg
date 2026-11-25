'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #RelocatableBuffer category: #'Powerlang-Core-Assembly'!
Object subclass: #RelocatableBuffer
	instanceVariableNames: 'stream address fixups'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!RelocatableBuffer commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!RelocatableBuffer methodsFor:  'fixups' stamp: 'KenD 28/Jun/2026 13:27:40'!
addAbsoluteFixup: label
	| fixup |
	fixup := RelocationFixup absoluteFrom: self currentAddress to: label.
	fixups add: fixup
! !

!RelocatableBuffer methodsFor:  'fixups' stamp: 'KenD 28/Jun/2026 13:27:40'!
addRelativeFixup: label size: n
	| fixup |
	fixup := RelocationFixup relativeFrom: self currentAddress to: label.
	fixup size: n.
	fixups add: fixup
! !

!RelocatableBuffer methodsFor:  'fixups' stamp: 'KenD 28/Jun/2026 13:27:40'!
applyFixupsWith: solver
	fixups do: [:fixup | fixup patch: self with: solver]
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
baseAddress
	^address
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
bytes
	^stream contents
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
codeSize
	^stream size
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
currentAddress
	^address + stream position
! !

!RelocatableBuffer methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	fixups := OrderedCollection new.
	address := 0.
	stream := #[] writeStream
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBytePut: byte
	| value |
	value := byte < 0 ifTrue: [ byte + 256 ] ifFalse: byte.
	stream nextBytePut: value
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextBytesPut: aByteArray
	stream nextBytesPut: aByteArray
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextLargePut: large
	stream nextLargePut: large

! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextLongPut: long
	stream nextLongPut: long

! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextPut: byte
	stream nextPut: byte
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextPutAll: aByteArray
	stream nextPutAll: aByteArray
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextULargePut: large
	stream nextULargePut: large

! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nextULongPut: long
	stream nextULongPut: long
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
peek
	^stream peek
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
peek: n
	^stream peek: n
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
position
	^stream position
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
position: anInteger
	stream position: anInteger
! !

!RelocatableBuffer methodsFor:  'relocation' stamp: 'KenD 28/Jun/2026 13:27:40'!
relocateTo: location with: solver
	| delta |
	delta := location - address.
	address := location.
	fixups do: [:fixup | fixup relocateBy: delta].
	self applyFixupsWith: solver
! !

!RelocatableBuffer methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	fixups := OrderedCollection new.
	stream reset
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
size
	^stream size
! !

!RelocatableBuffer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
skip: anInteger
	stream skip: anInteger
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stream
	^stream
! !

!RelocatableBuffer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
stream: aStream
	stream := aStream
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeByte: byte at: location
	| previous value |
	previous := stream position.
	value := byte < 0 ifTrue: [ byte + 256 ] ifFalse: [ byte ].
	stream
		position: location - address;
		nextBytePut: value;
		position: previous
! !

!RelocatableBuffer methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeLong: long at: location
	| previous |
	previous := stream position.
	stream
		position: location - address;
		nextLongPut: long;
		position: previous
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RelocatableBuffer class' category: #'Powerlang-Core-Assembly'!
RelocatableBuffer class
	instanceVariableNames: ''!


RelocatableBuffer initialize!

