"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonObject,
	#superclass : #OrderedDictionary,
	#category : #JSON
}

{ #category : #'instance creation' }
JsonObject class >> fromString: aString [
	| json |
	json := JsonParser parse: aString.
	self ASSERT: json class == self.
	^json
]

{ #category : #system }
JsonObject >> doesNotUnderstand: aMessage [
	| key |
	(aMessage isBinary or: [aMessage arity > 1])
		ifTrue: [^super doesNotUnderstand: aMessage].
	key := aMessage selector asString.
	aMessage arity = 0 ifTrue: [^self valueAt: key].
	self at: key allButLast put: aMessage argument
]

{ #category : #accessing }
JsonObject >> format [
	^self asString
]

{ #category : #testing }
JsonObject >> isJsonObject [
	^true
]

{ #category : #services }
JsonObject >> literals [
	| below here |
	here := OrderedSet streamContents: [:strm | 
		below := OrderedCollection new.
		self keysAndValuesDo: [:k :v | 
			k isString ifTrue: [
				strm nextPut: k.
				v class == self class ifTrue: [below add: v]]]].
	^here asArray , (below gather: #literals) asArray
]

{ #category : #printing }
JsonObject >> printOn: aStream [
	self printOn: aStream indent: 0]

{ #category : #printing }
JsonObject >> printOn: aStream indent: anInteger [
	| string |
	string := JsonWriter write: self indent: anInteger.
	aStream eol = String crlf ifTrue: [string := string withCrLf].
	aStream isFileStream
		ifTrue: [aStream nextBytesPut: string utf8]
		ifFalse: [aStream nextPutAll: string]
]

{ #category : #printing }
JsonObject >> printTextOn: rtf [
	self printTextOn: rtf indent: 0]

{ #category : #printing }
JsonObject >> printTextOn: rtf indent: anInteger [
	JsonPainter write: self on: rtf indent: anInteger
]

{ #category : #printing }
JsonObject >> printTextOn: rtf limit: aNumber [
	self printTextOn: rtf indent: 0]

{ #category : #services }
JsonObject >> selectors [
	^#()
]

