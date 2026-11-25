'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ISAPrefixReader category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAInstructionPartReader subclass: #ISAPrefixReader
	instanceVariableNames: 'legacy rex vex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly-Intel-Tools'!
!ISAPrefixReader commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!ISAPrefixReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aStream
	super from: aStream.
	self
		legacyFrom: aStream;
		rexFrom: aStream;
		vexFrom: aStream
! !

!ISAPrefixReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
legacyFrom: aStream
	| prefix |
	legacy := #() writeStream.
	[
		prefix := LegacyPrefix withValue: aStream peek.
		prefix isNil]
		whileFalse: [
			legacy nextPut: prefix.
			contents nextPut: aStream next]
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printLegacyOn: aStream
	legacy contents
		do: [:p | aStream nextPutAll: p asString]
		separatedBy: [aStream space]
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	self printLegacyOn: aStream.
	legacy size > 0 ifTrue: [aStream space].
	rex notNil ifTrue: [
		self printRexOn: aStream.
		aStream space].
	vex notNil ifTrue: [self printVexOn: aStream]
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printRexOn: aStream
	rex isNil ifTrue: [^self].
	aStream nextPutAll: REXPrefix rex asString.
	(rex isOnBit: REXPrefix w value) ifTrue: [aStream nextPutAll: '.W'].
	(rex isOnBit: REXPrefix r value) ifTrue: [aStream nextPutAll: '.R'].
	(rex isOnBit: 1) ifTrue: [aStream nextPutAll: '.B'].
	(rex isOnBit: 2) ifTrue: [aStream nextPutAll: '.X']
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printVex2On: aStream
	self printVexVvvvLpp: vex second on: aStream
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printVex3On: aStream
	| byte x b mmmmm w |
	byte := vex second.
	x := (byte bitAnd: 2r1000000) > 0 ifTrue: [$1] ifFalse: [$0].
	aStream nextPut: x; nextPut: $..
	b := (byte bitAnd: 2r100000) > 0 ifTrue: [$1] ifFalse: [$0].
	aStream nextPut: b; nextPut: $..
	mmmmm := byte bitAnd: 2r11111.
	aStream
		nextPutAll: (mmmmm bin: 5);
		nextPut: $|.
	byte := vex third.
	w := byte >= 16r80 ifTrue: [$1] ifFalse: [$0].
	aStream nextPut: w; nextPut: $..
	self printVexVvvvLpp: byte on: aStream
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printVexOn: aStream
	| byte r |
	vex isNil ifTrue: [^self].
	aStream nextPutAll: vex first hex; nextPut: $|.
	byte := vex second.
	r := byte // 16r80 > 0 ifTrue: [$1] ifFalse: [$0].
	aStream nextPut: r; nextPut: $..
	vex size = 2
		ifTrue: [self printVex2On: aStream]
		ifFalse: [self printVex3On: aStream]
! !

!ISAPrefixReader methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printVexVvvvLpp: byte on: aStream
	| vvvv l pp |
	vvvv := (byte bitShift: -3) bitAnd: 2r1111.
	aStream
		nextPutAll: (vvvv bin: 4);
		nextPut: $..
	l := (byte bitAnd: 2r100) > 0 ifTrue: [$1] ifFalse: [$0].
	aStream nextPut: l; nextPut: $..
	pp := byte bitAnd: 2r11.
	aStream nextPutAll: (pp bin: 2)
! !

!ISAPrefixReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
rexFrom: aStream
	(aStream peek bitAnd: 16rF0) = REXPrefix rex value ifTrue: [
		rex := aStream next.
		contents nextPut: rex]
! !

!ISAPrefixReader methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
vexFrom: aStream
	| byte |
	byte := aStream peek.
	vex := byte = 16rC4 ifTrue: [aStream next: 3] ifFalse: [
		byte = 16rC5 ifFalse: [^self].
		aStream next: 2].
	contents nextPutAll: vex
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ISAPrefixReader class' category: #'Powerlang-Core-Assembly-Intel-Tools'!
ISAPrefixReader class
	instanceVariableNames: ''!


