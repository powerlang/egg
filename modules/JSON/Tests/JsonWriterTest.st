"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonWriterTest,
	#superclass : #TestCase,
	#category : #'JSON\Tests'
}

{ #category : #utf8 }
JsonWriterTest >> testEmbeddings [
	| text json read |
	text := '\ b "Comment"'.
	json := JsonWriter write: text.
	read := JsonParser parse: json.
	self assert: read = text.
	text := '\ b
	"Comment"'.
	json := JsonWriter write: text.
	read := JsonParser parse: json.
	self assert: read = text
]

{ #category : #all }
JsonWriterTest >> testSingleLine [
	| object |
	object := JsonObject new at: 'property' put: 123; yourself.
	self assert: (JsonWriter write: object) = '{"property": 123}'
]

{ #category : #utf8 }
JsonWriterTest >> testTP47626 [
	| date json |
	date := Date yyyymmdd: '2017-10-28'.
	json := JsonWriter write: date.
	self assert: json = date iso8601 doubleQuoted
]

{ #category : #utf8 }
JsonWriterTest >> testTP56387 [
	| json |
	json := JsonObject new Name: 'Trulalá'.
	self assert: (json asString includesString: 'Trulalá')
]

{ #category : #utf8 }
JsonWriterTest >> testUTF8 [
	| text json read |
	text := 'a → 3 + 4'.
	json := JsonWriter write: text.
	read := JsonParser parse: json.
	self assert: read = text
]

