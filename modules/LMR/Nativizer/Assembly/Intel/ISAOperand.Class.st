'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAOperand category: #'Powerlang-Core-Assembler-Intel'!
Object subclass: #ISAOperand
	instanceVariableNames: 'length'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!ISAOperand commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
, anISAOperand
	^{self. anISAOperand}
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
baseExtension
	^0
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
indexExtension
	^0
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDirectMemoryReference
	^false
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediate
	^false
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isMemory
	^false
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isRegister
	^false
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTemplate
	^false
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
length
	^length
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
length: anInteger
	length := anInteger
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memoryLength
	^length
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
needsExtraBit
	^false
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
offsetOfIndex: index
	length = 64 ifTrue: [^index - 1 bitShift: 3].
	length = 32 ifTrue: [^index - 1 bitShift: 2].
	length = 8 ifTrue: [^index - 1].
	self error: 'invalid operand'
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand1
	^self
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand2
	^self
! !

!ISAOperand methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefers: anOperandType to: anotherOperandType
	^false
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regExtension
	^0
! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sizeInBits
	^self length

! !

!ISAOperand methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sizeInBytes
	^length // 8
! !

!ISAOperand methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
template
	^self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAOperand class' category: #'Powerlang-Core-Assembler-Intel'!
ISAOperand class
	instanceVariableNames: ''!

!ISAOperand class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
new
	^super new initialize
! !


