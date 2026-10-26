'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #LegacyPrefix category: #'Powerlang-Core-Assembler-Intel'!
InstructionPrefix subclass: #LegacyPrefix
	instanceVariableNames: 'group value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!LegacyPrefix commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!LegacyPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
group
	^group
! !

!LegacyPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
group: anInteger
	group := anInteger
! !

!LegacyPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLegacy
	^true
! !

!LegacyPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
matches: aLegacyPrefix
	^self == aLegacyPrefix
! !

!LegacyPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
overridesAddressSize
	^self = AddressSize_Override
! !

!LegacyPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
overridesOperandSize
	^self = OperandSize_Override
! !

!LegacyPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^value
! !

!LegacyPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: anInteger
	value := anInteger
! !

!LegacyPrefix methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeOn: instruction
	instruction writeLegacyPrefix: value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LegacyPrefix class' category: #'Powerlang-Core-Assembler-Intel'!
LegacyPrefix class
	instanceVariableNames: ''!

!LegacyPrefix class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
addressSizeOverride
	^AddressSize_Override
! !

!LegacyPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeGroup1
	#(#(0xF0 'LOCK') #(0xF2 'REPNE/REPNZ') #(0xF3 'REP/REPE/REPZ'))
		do: [:pair | | names prefix |
			names := $/ split: pair second.
			prefix := self new
				group: 1;
				value: pair first;
				name: names first.
			names do: [:aka | Prefixes at: aka put: prefix]]
! !

!LegacyPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeGroup2
	#(#(0x2E 'CS') #(0x36 'SS') #(0x3E 'DS') #(0x26 'ES') #(0x64 FS) #(0x65 'GS'))
		do: [:pair | | prefix |
			prefix := self new
				group: 2;
				value: pair first;
				name: pair second , ' segment override'.
			self disableCode: [Prefixes at: prefix name put: prefix]].
	#(#(0x2E 'not') #(0x3E '')) do: [:pair | | prefix |
		prefix := self new
			group: 2;
			value: pair first;
			name: 'Branch ' , pair second , ' taken'.
		self disableCode: [Prefixes at: prefix name put: prefix]]
! !

!LegacyPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeGroup3
	| prefix |
	prefix := self new
		group: 3;
		value: 16r66;
		name: 'OperandSize_Override'.
	Prefixes at: prefix name put: prefix
! !

!LegacyPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeGroup4
	| prefix |
	prefix := self new
		group: 4;
		value: 16r67;
		name: 'AddressSize_Override'.
	Prefixes at: prefix name put: prefix
! !

!LegacyPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializePrefixes
	self
		initializeGroup1;
		initializeGroup2;
		initializeGroup3;
		initializeGroup4.
! !

!LegacyPrefix class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
operandSizeOverride
	^OperandSize_Override
! !

!LegacyPrefix class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
withValue: byte
	^Prefixes
		detect: [:prefix | prefix isLegacy and: [prefix value = byte]]
		ifNone: nil
! !


