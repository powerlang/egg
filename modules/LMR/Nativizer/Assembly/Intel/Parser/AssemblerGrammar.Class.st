'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #AssemblerGrammar category: #'Powerlang-Core-Assembly-Intel-Parser'!
PPCompositeParser subclass: #AssemblerGrammar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Parser'!
!AssemblerGrammar commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
base
	^self reg
! !

!AssemblerGrammar methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
comma
	^$, asParser trim
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
constant
	^self hex / self decimal
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
decimal
	^#digit asParser plus flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
displacement
	^self operator , self constant
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hex
	^'0x' asParser , #hex asParser plus
! !

!AssemblerGrammar methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
imm
	^self immH / self immD
! !

!AssemblerGrammar methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
immD
	^self sign , self decimal
! !

!AssemblerGrammar methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
immH
	^self hex
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^self sum , self reg
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
instruction
	^self prefix optional , self mnemonic trim , self operands
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
label
	^(self labelName , $: asParser) flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
labelName
	^($@ asParser , #word asParser plus) flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memory
	^self memorySize optional , $[ asParser trim
		, (self segment , ':' asParser) optional
		, self sib
		, $] asParser trim
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memorySize
	^'qword' asParser / 'dword' asParser / 'word' asParser / 'bword' asParser
		/ 'byte' asParser
		/ 'xmmword' asParser
		/ 'ymmword' asParser
		/ 'zmmword' asParser
		, 'ptr' asParser trim optional
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mnemonic
	^(#letter asParser , (#letter asParser / #digit asParser) star) flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
mul
	^$* asParser trim flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand
	^self memory / self reg / self imm / self labelName
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands
	^(self operands3 / self operands2 / self operands1) optional
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands1
	^self operand
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands2
	^self operand , self comma , self operand
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operands3
	^self operand , self comma , self operand , self comma , self operand
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operator
	^($+ asParser / $- asParser) trim
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prefix
	^PPChoiceParser
		withAll: (#(	'lock' 'repne' 'repnz' 'repe' 'repz'  'rep')
			collect: [:name | name asParser trim])
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
reg
	^ (PPChoiceParser
		withAll:
			((Registers asArray sort: [ :a :b | a name size > b name size ])
				collect: [ :r | r name asParser ])) flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scale
	^self mul , ($1 asParser / $2 asParser / $4 asParser / $8 asParser)
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
segment
	^'cs' asParser / 'ds' asParser / 'ss' asParser / 'es' asParser
		/ 'fs' asParser
		/ 'gs' asParser
! !

!AssemblerGrammar methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
separator
	^#blank asParser star flatten
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib
	^self sib1 / self sib3 / self sib2
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib1
	^self displacement / self constant
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib2
	^self base , self index optional , self scale optional
		, self displacement optional
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sib3
	^self reg , self scale , self displacement
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sign
	^($+ asParser / $- asParser) trim optional
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
start
	^self label / self instruction
		, (#blank asParser plus flatten , (self label / self instruction)) star
! !

!AssemblerGrammar methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sum
	^$+ asParser trim flatten
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AssemblerGrammar class' category: #'Powerlang-Core-Assembly-Intel-Parser'!
AssemblerGrammar class
	instanceVariableNames: ''!


