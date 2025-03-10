"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"
Class {
	#name : #LegacyPrefix,
	#superclass : #InstructionPrefix,
	#instVars : [
		'group',
		'value'
	],
	#category : #'Powerlang-Core-Assembler-Intel'
}

{ #category : #private }
LegacyPrefix class >> addressSizeOverride [
	^AddressSize_Override
]

{ #category : #initialization }
LegacyPrefix class >> initializeGroup1 [
	#(#(0xF0 'LOCK') #(0xF2 'REPNE/REPNZ') #(0xF3 'REP/REPE/REPZ'))
		do: [:pair | | names prefix |
			names := $/ split: pair second.
			prefix := self new
				group: 1;
				value: pair first;
				name: names first.
			names do: [:aka | Prefixes at: aka put: prefix]]
]

{ #category : #initialization }
LegacyPrefix class >> initializeGroup2 [
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
]

{ #category : #initialization }
LegacyPrefix class >> initializeGroup3 [
	| prefix |
	prefix := self new
		group: 3;
		value: 16r66;
		name: 'OperandSize_Override'.
	Prefixes at: prefix name put: prefix
]

{ #category : #initialization }
LegacyPrefix class >> initializeGroup4 [
	| prefix |
	prefix := self new
		group: 4;
		value: 16r67;
		name: 'AddressSize_Override'.
	Prefixes at: prefix name put: prefix
]

{ #category : #initialization }
LegacyPrefix class >> initializePrefixes [
	self
		initializeGroup1;
		initializeGroup2;
		initializeGroup3;
		initializeGroup4.
]

{ #category : #private }
LegacyPrefix class >> operandSizeOverride [
	^OperandSize_Override
]

{ #category : #accessing }
LegacyPrefix class >> withValue: byte [
	^Prefixes
		detect: [:prefix | prefix isLegacy and: [prefix value = byte]]
		ifNone: nil
]

{ #category : #accessing }
LegacyPrefix >> group [
	^group
]

{ #category : #accessing }
LegacyPrefix >> group: anInteger [
	group := anInteger
]

{ #category : #testing }
LegacyPrefix >> isLegacy [
	^true
]

{ #category : #testing }
LegacyPrefix >> matches: aLegacyPrefix [
	^self == aLegacyPrefix
]

{ #category : #testing }
LegacyPrefix >> overridesAddressSize [
	^self = AddressSize_Override
]

{ #category : #testing }
LegacyPrefix >> overridesOperandSize [
	^self = OperandSize_Override
]

{ #category : #accessing }
LegacyPrefix >> value [
	^value
]

{ #category : #accessing }
LegacyPrefix >> value: anInteger [
	value := anInteger
]

{ #category : #writing }
LegacyPrefix >> writeOn: instruction [
	instruction writeLegacyPrefix: value
]
