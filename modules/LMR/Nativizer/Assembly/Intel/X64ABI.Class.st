'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #X64ABI category: #'Powerlang-Core-Assembler-Intel'!
ABI subclass: #X64ABI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!X64ABI commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!X64ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
bits
	^64
! !

!X64ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
newAssembler
	^AMD64TemplateAssembler new
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA
	^rdx
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regE
	^rdi
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFP
	^rbp
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFalse
	^ r14
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regG
	^r15
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regIP
	^ rip
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regM
	^rbx
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regNil
	^ r12
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR
	^rax
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regS
	^rsi
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regSP
	^rsp
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT
	^rcx
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regTrue
	^ r13
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regV
	^r11
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX0
	^xmm0
! !

!X64ABI methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX1
	^xmm1
! !

!X64ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	^8
! !

!X64ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSizeShift
	^3
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'X64ABI class' category: #'Powerlang-Core-Assembler-Intel'!
X64ABI class
	instanceVariableNames: ''!


