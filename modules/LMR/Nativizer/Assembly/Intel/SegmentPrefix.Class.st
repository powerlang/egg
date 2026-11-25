'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SegmentPrefix category: #'Powerlang-Core-Assembler-Intel'!
InstructionPrefix subclass: #SegmentPrefix
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!SegmentPrefix commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!SegmentPrefix methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSegment
	^true
! !

!SegmentPrefix methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
register
	^Register named: name allButLast
! !

!SegmentPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^value
! !

!SegmentPrefix methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: aInteger
	value := aInteger
! !

!SegmentPrefix methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeOn: instruction
	instruction writeSegmentPrefix: value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SegmentPrefix class' category: #'Powerlang-Core-Assembler-Intel'!
SegmentPrefix class
	instanceVariableNames: ''!

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
cs
	^self new name: 'cs:'; value: 16r2E
! !

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
ds
	^self new name: 'ds:'; value: 16r3E
! !

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
es
	^self new name: 'es:'; value: 16r26
! !

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
fs
	^self new name: 'fs:'; value: 16r64
! !

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
gs
	^self new name: 'gs:'; value: 16r65
! !

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
named: aString
	| string char |
	aString size < 2 ifTrue: [^nil].
	string := aString asLowercase.
	(string at: 2) = $s ifFalse: [^nil].
	char := string at: 1.
	char = $c ifTrue: [^self cs].
	char = $s ifTrue: [^self ss].
	char = $d ifTrue: [^self ds].
	char = $e ifTrue: [^self es].
	char = $f ifTrue: [^self fs].
	char = $g ifTrue: [^self gs].
	^nil
! !

!SegmentPrefix class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
peekFrom: aStream
	(aStream peekFor: 16r2E) ifTrue: [^self cs].
	(aStream peekFor: 16r3E) ifTrue: [^self ds].
	(aStream peekFor: 16r26) ifTrue: [^self es].
	(aStream peekFor: 16r64) ifTrue: [^self fs].
	(aStream peekFor: 16r65) ifTrue: [^self gs].
	^nil
! !

!SegmentPrefix class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
ss
	^self new name: 'ss:'; value: 16r36
! !


