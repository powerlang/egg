'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #JsonWriterTest category: #'JSON-Tests'!
TestCase subclass: #JsonWriterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON-Tests'!
!JsonWriterTest commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonWriterTest methodsFor:  'utf8' stamp: 'KenD 28/Jun/2026 13:32:24'!
testEmbeddings
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
! !

!JsonWriterTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:32:24'!
testSingleLine
	| object |
	object := JsonObject new at: 'property' put: 123; yourself.
	self assert: (JsonWriter write: object) = '{"property": 123}'
! !

!JsonWriterTest methodsFor:  'utf8' stamp: 'KenD 28/Jun/2026 13:32:24'!
testTP47626
	| date json |
	date := Date yyyymmdd: '2017-10-28'.
	json := JsonWriter write: date.
	self assert: json = date iso8601 doubleQuoted
! !

!JsonWriterTest methodsFor:  'utf8' stamp: 'KenD 28/Jun/2026 13:32:24'!
testTP56387
	| json |
	json := JsonObject new Name: 'Trulalá'.
	self assert: (json asString includesString: 'Trulalá')
! !

!JsonWriterTest methodsFor:  'utf8' stamp: 'KenD 28/Jun/2026 13:32:24'!
testUTF8
	| text json read |
	text := 'a → 3 + 4'.
	json := JsonWriter write: text.
	read := JsonParser parse: json.
	self assert: read = text
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonWriterTest class' category: #'JSON-Tests'!
JsonWriterTest class
	instanceVariableNames: ''!


