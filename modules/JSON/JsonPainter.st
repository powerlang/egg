"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonPainter,
	#superclass : #JsonWriter,
	#category : #JSON
}

{ #category : #services }
JsonPainter class >> write: anObject [
	| text writer |
	text := '' asText.
	writer := self write: anObject on: text.
	^text
]

{ #category : #services }
JsonPainter class >> write: anObject indent: anInteger [
	| text |
	text := '' asText.
	self write: anObject on: text indent: anInteger.
	^text
]

{ #category : #private }
JsonPainter >> codeForChar: ch [
	^ch asInteger < 128 ifTrue: [super codeForChar: ch] ifFalse: [ch]
]

{ #category : #colors }
JsonPainter >> keyColor [
	^Color darkGreen
]

{ #category : #colors }
JsonPainter >> keywordColor [
	self disableCode: [^Color red: 245 green: 100 blue: 71].
	^Color darkBlue
]

{ #category : #colors }
JsonPainter >> literalColor [
	^Color darkBlue
]

{ #category : #colors }
JsonPainter >> operatorColor [
	^Color red: 185 green: 126 blue: 148]

{ #category : #colors }
JsonPainter >> specialColor [
	^Color red: 245 green: 100 blue: 71]

{ #category : #colors }
JsonPainter >> stringColor [
	^Color red: 84 green: 134 blue: 192]

{ #category : #private }
JsonPainter >> writeBoolean: aBoolean [
	stream useColor: self literalColor while: [super writeBoolean: aBoolean]
]

{ #category : #private }
JsonPainter >> writeDate: aDate [
	self writeString: aDate iso8601]

{ #category : #private }
JsonPainter >> writeKey: aString [
	stream
		useBoldWhile: [stream
			useColor: self keyColor
			while: [super writeKey: aString]]
]

{ #category : #private }
JsonPainter >> writeNull [
	stream useColor: self specialColor while: [super writeNull]
]

{ #category : #private }
JsonPainter >> writeNumber: aNumber [
	stream useColor: self literalColor while: [super writeNumber: aNumber]
]

{ #category : #private }
JsonPainter >> writeOperator: aCharacter [
	stream
		useColor: self operatorColor
		while: [super writeOperator: aCharacter]
]

{ #category : #private }
JsonPainter >> writeString: aString [
	stream useColor: self stringColor while: [super writeString: aString]
]

{ #category : #private }
JsonPainter >> writeTimestamp: aTimestamp [
	stream
		useColor: self literalColor
		while: [super writeTimestamp: aTimestamp]
]

