'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAImmediate category: #'Powerlang-Core-Assembler-Intel'!
ISAOperand subclass: #ISAImmediate
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!ISAImmediate commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAImmediate methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
= operand
	self class == operand class ifFalse: [^false].
	value = operand value ifFalse: [^false].
	^length = operand length
! !

!ISAImmediate methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
bytes
	| bytes v |
	bytes := ByteArray new: length // 8.
	v := value.
	v < 0 ifTrue: [v := v + (1 bitShift: length)].
	1 to: bytes size do: [:i | 
		bytes at: i put: (v bitAnd: 16rFF).
		v := v bitShift: -8].
	^bytes
! !

!ISAImmediate methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
defaultLength
	value < -168000000000000000 ifTrue: [^128].
	value < -16r80000000 ifTrue: [^64].
	value < -16r8000 ifTrue: [^32].
	value < -16r80 ifTrue: [^16].
	value < 16r80 ifTrue: [^8].
	value < 16r8000 ifTrue: [^16].
	value < 16r80000000 ifTrue: [^32].
	value < 16r8000000000000000 ifTrue: [^64].
	^128
! !

!ISAImmediate methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hash
	^value hashWith: length
! !

!ISAImmediate methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCompatibleWith: anOperandType
	(value = 0 and: [anOperandType name = '0']) ifTrue: [^true].
	(value = 1 and: [anOperandType name = '1']) ifTrue: [^true].
	(value = 3 and: [anOperandType name = '3']) ifTrue: [^true].
	^anOperandType isImmediate
		and: [anOperandType hasImmediateFlag]
		and: [length <= anOperandType length]
! !

!ISAImmediate methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediate
	^true
! !

!ISAImmediate methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
looksLikeAddress
	^value > 65536 and: [value even]
! !

!ISAImmediate methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memoryLength
	^nil
! !

!ISAImmediate methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefers: anOperandType to: otherOperandType
	anOperandType length < otherOperandType length ifTrue: [^true].
	(value = 0 and: [anOperandType name = '0']) ifTrue: [^true].
	(value = 1 and: [anOperandType name = '1']) ifTrue: [^true].
	(value = 3 and: [anOperandType name = '3']) ifTrue: [^true].
	^false
! !

!ISAImmediate methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	| v |
	v := value isNil ifTrue: ['???'] ifFalse: [value hex].
	aStream nextPutAll: v
! !

!ISAImmediate methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
template
	(0 <= value and: [value < 4]) ifTrue: [^self copy].
	^self class new value: length; length: length
! !

!ISAImmediate methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^value
! !

!ISAImmediate methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: anInteger
	value := anInteger.
	length := self defaultLength
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAImmediate class' category: #'Powerlang-Core-Assembler-Intel'!
ISAImmediate class
	instanceVariableNames: ''!


