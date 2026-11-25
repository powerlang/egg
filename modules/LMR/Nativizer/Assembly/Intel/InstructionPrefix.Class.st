'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #InstructionPrefix category: #'Powerlang-Core-Assembler-Intel'!
Object subclass: #InstructionPrefix
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!InstructionPrefix commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!InstructionPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLegacy
	^false
! !

!InstructionPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isRex
	^false
! !

!InstructionPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSegment
	^false
! !

!InstructionPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isVex
	^false
! !

!InstructionPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^name
! !

!InstructionPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name: aString
	name := aString
! !

!InstructionPrefix methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	(name includes: Character space)
		ifTrue: [
			aStream
				nextPut: ${;
				nextPutAll: name;
				nextPut: $}]
		ifFalse: [aStream nextPutAll: name]
! !

!InstructionPrefix methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeOn: anInstruction
	self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InstructionPrefix class' category: #'Powerlang-Core-Assembler-Intel'!
InstructionPrefix class
	instanceVariableNames: ''!

!InstructionPrefix class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
classFor: aString
	(aString beginsWith: 'REX') ifTrue: [^REXPrefix].
	(aString beginsWith: 'VEX') ifTrue: [^VEXPrefix].
	^LegacyPrefix
! !

!InstructionPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
fromString: aString
	| reader prefixes rex |
	reader := aString readStream.
	prefixes := Prefixes
		select: [:p | reader peekForAll: p value hex]
		in: OrderedCollection new.
	(reader peek: 'REX' size) = 'REX' ifTrue: [
		rex := REXPrefix fromStream: reader.
		prefixes add: rex].
	(reader peek: 'VEX' size) = 'VEX' ifTrue: [
		rex := VEXPrefix fromStream: reader.
		prefixes add: rex].
	^prefixes
! !

!InstructionPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializePrefixes
	self addNamespaceAs: #Prefixes.
	LegacyPrefix initializePrefixes.
	REXPrefix initializePrefixes
! !

!InstructionPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
named: aString
	^self new name: aString
! !

!InstructionPrefix class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
peekFrom: aStream
	(aStream peekFor: LOCK value) ifTrue: [^LOCK].
	(aStream peekFor: REPNE value) ifTrue: [^REPNE].
	(aStream peekFor: REP value) ifTrue: [^REP].
	(aStream peekFor: OperandSize_Override value)
		ifTrue: [^OperandSize_Override].
	(aStream peekFor: AddressSize_Override value)
		ifTrue: [^AddressSize_Override].
	^nil
! !

!InstructionPrefix class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefixes
	^Prefixes
! !


