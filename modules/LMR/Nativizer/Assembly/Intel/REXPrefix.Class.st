'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #REXPrefix category: #'Powerlang-Core-Assembler-Intel'!
InstructionPrefix subclass: #REXPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!REXPrefix commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!REXPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isRex
	^true
! !

!REXPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
matches: anInteger
	^anInteger isOnBit: self value
! !

!REXPrefix methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	self == REX_W ifTrue: [^16r48].
	self == REX_R ifTrue: [^16r44].
	self == REX ifTrue: [^16r40].
	self ASSERT: false.
	^nil
! !

!REXPrefix methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeOn: instruction
	instruction writeRexPrefix: self value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'REXPrefix class' category: #'Powerlang-Core-Assembler-Intel'!
REXPrefix class
	instanceVariableNames: ''!

!REXPrefix class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
b
	^1
! !

!REXPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
fromStream: aStream
	| s |
	s := aStream upTo: $+.
	^self fromString: s
! !

!REXPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
fromString: aString
	(aString endsWith: 'REX.W') ifTrue: [^self w].
	(aString endsWith: 'REX.R') ifTrue: [^self r].
	(aString endsWith: 'REX') ifTrue: [^self rex].
	^nil
! !

!REXPrefix class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializePrefixes
	#('REX' 'REX_W' 'REX_R')
		do: [ :s | 
			| rex |
			rex := self new name: s.
			Prefixes at: s put: rex ].

! !

!REXPrefix class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
peekFrom: aStream
	^(aStream peek bitAnd: 16rF0) = 16r40 ifTrue: [aStream next]
! !

!REXPrefix class methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
print: byte on: aStream
	self ASSERT: (byte isOnBit: REX value).
	aStream nextPutAll: '0100'.
	(byte isOnBit: self w value) ifTrue: [aStream nextPut: $w].
	(byte isOnBit: self r) ifTrue: [aStream nextPut: $r].
	(byte isOnBit: self x) ifTrue: [aStream nextPut: $x].
	(byte isOnBit: self b) ifTrue: [aStream nextPut: $b]
! !

!REXPrefix class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
r
	^REX_R
! !

!REXPrefix class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
rex
	^REX
! !

!REXPrefix class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
w
	^REX_W
! !

!REXPrefix class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
x
	^2
! !


