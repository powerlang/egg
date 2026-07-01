'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAOpcodeReader category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAInstructionPartReader subclass: #ISAOpcodeReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ISAOpcodeReader commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAOpcodeReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aStream
	| byte octets |
	super from: aStream.
	byte := aStream next.
	contents nextPut: byte.
	byte = 16rF ifTrue: [
		octets := (#[16r66 16rF2 16rF3] includes: contents contents first)
			ifTrue: [aStream next: 2]
			ifFalse: [{aStream next}].
		contents nextPutAll: octets]
! !

!ISAOpcodeReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	contents contents
		do: [:byte | aStream nextPutAll: byte hex]
		separatedBy: [aStream nextPut: $.]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAOpcodeReader class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAOpcodeReader class
	instanceVariableNames: ''!


