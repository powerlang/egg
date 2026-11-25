'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonPainter category: #JSON!
JsonWriter subclass: #JsonPainter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonPainter commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
codeForChar: ch
	^ch asInteger < 128 ifTrue: [super codeForChar: ch] ifFalse: [ch]
! !

!JsonPainter methodsFor:  'colors' stamp: 'KenD 28/Jun/2026 13:27:41'!
keyColor
	^Color darkGreen
! !

!JsonPainter methodsFor:  'colors' stamp: 'KenD 28/Jun/2026 13:27:41'!
keywordColor
	self disableCode: [^Color red: 245 green: 100 blue: 71].
	^Color darkBlue
! !

!JsonPainter methodsFor:  'colors' stamp: 'KenD 28/Jun/2026 13:27:41'!
literalColor
	^Color darkBlue
! !

!JsonPainter methodsFor:  'colors' stamp: 'KenD 28/Jun/2026 13:27:41'!
operatorColor
	^Color red: 185 green: 126 blue: 148! !

!JsonPainter methodsFor:  'colors' stamp: 'KenD 28/Jun/2026 13:27:41'!
specialColor
	^Color red: 245 green: 100 blue: 71! !

!JsonPainter methodsFor:  'colors' stamp: 'KenD 28/Jun/2026 13:27:41'!
stringColor
	^Color red: 84 green: 134 blue: 192! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeBoolean: aBoolean
	stream useColor: self literalColor while: [super writeBoolean: aBoolean]
! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeDate: aDate
	self writeString: aDate iso8601! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeKey: aString
	stream
		useBoldWhile: [stream
			useColor: self keyColor
			while: [super writeKey: aString]]
! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeNull
	stream useColor: self specialColor while: [super writeNull]
! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeNumber: aNumber
	stream useColor: self literalColor while: [super writeNumber: aNumber]
! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeOperator: aCharacter
	stream
		useColor: self operatorColor
		while: [super writeOperator: aCharacter]
! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeString: aString
	stream useColor: self stringColor while: [super writeString: aString]
! !

!JsonPainter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeTimestamp: aTimestamp
	stream
		useColor: self literalColor
		while: [super writeTimestamp: aTimestamp]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonPainter class' category: #JSON!
JsonPainter class
	instanceVariableNames: ''!

!JsonPainter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject
	| text writer |
	text := '' asText.
	writer := self write: anObject on: text.
	^text
! !

!JsonPainter class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
write: anObject indent: anInteger
	| text |
	text := '' asText.
	self write: anObject on: text indent: anInteger.
	^text
! !


