'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #X86ABI category: #'Powerlang-Core-Assembler-Intel'!
ABI subclass: #X86ABI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!X86ABI commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
bits
	^32
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA
	^edx
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regE
	^edi
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFP
	^ebp
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR
	^eax
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regS
	^esi
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regSP
	^esp
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT
	^ecx
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	^4
! !

!X86ABI methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSizeShift
	^2
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'X86ABI class' category: #'Powerlang-Core-Assembler-Intel'!
X86ABI class
	instanceVariableNames: ''!


