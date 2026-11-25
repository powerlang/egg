'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAInstructionReader category: #'Powerlang-Core-Assembly-Intel-Tools'!
Object subclass: #ISAInstructionReader
	instanceVariableNames: 'prefixes opcode modrm sib displacement immediate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ISAInstructionReader commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacementFrom: aStream
	
! !

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aStream
	self
		prefixesFrom: aStream;
		opcodeFrom: aStream;
		modrmFrom: aStream;
		sibFrom: aStream;
		displacementFrom: aStream;
		immediateFrom: aStream
! !

!ISAInstructionReader methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSib
	^modrm notNil and: [modrm mod = 0]
! !

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediateFrom: aStream
	immediate := aStream upToEnd
! !

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
modrmFrom: aStream
	modrm := ISAModRMReader new from: aStream; contents
! !

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
opcodeFrom: aStream
	opcode := ISAOpcodeReader new from: aStream; asString
! !

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefixesFrom: aStream
	prefixes := ISAPrefixReader new from: aStream; asString
! !

!ISAInstructionReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream nextPutAll: prefixes.
	prefixes size > 0 ifTrue: [aStream nextPutAll: '| '].
	aStream nextPutAll: opcode.
	aStream nextPutAll: ' | '.
	modrm notNil ifTrue: [modrm printOn: aStream].
	sib notNil ifTrue: [
		aStream nextPutAll: ' | '.
		sib printOn: aStream].
	displacement notNil ifTrue: [
		aStream nextPutAll: ' |'.
		displacement do: [:byte | | hex |
			hex := byte hex.
			hex size = 1 ifTrue: [hex := '0' , hex].
			aStream space; nextPutAll: hex]].
	immediate notNil ifTrue: [
		aStream nextPutAll: ' |'.
		immediate do: [:byte | | hex |
			hex := byte hex.
			hex size = 1 ifTrue: [hex := '0' , hex].
			aStream space; nextPutAll: hex]]
! !

!ISAInstructionReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
sibFrom: aStream
	self hasSib ifFalse: [^self].
	aStream atEnd ifTrue: [^self].
	sib := ISASibReader new from: aStream; contents
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAInstructionReader class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAInstructionReader class
	instanceVariableNames: ''!


