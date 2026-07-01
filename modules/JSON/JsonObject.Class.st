'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #JsonObject category: #JSON!
OrderedDictionary subclass: #JsonObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonObject commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:32:24'!
doesNotUnderstand: aMessage
	| key |
	(aMessage isBinary or: [aMessage arity > 1])
		ifTrue: [^super doesNotUnderstand: aMessage].
	key := aMessage selector asString.
	aMessage arity = 0 ifTrue: [^self valueAt: key].
	self at: key allButLast put: aMessage argument
! !

!JsonObject methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
format
	^self asString
! !

!JsonObject methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isJsonObject
	^true
! !

!JsonObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
literals
	| below here |
	here := OrderedSet streamContents: [:strm | 
		below := OrderedCollection new.
		self keysAndValuesDo: [:k :v | 
			k isString ifTrue: [
				strm nextPut: k.
				v class == self class ifTrue: [below add: v]]]].
	^here asArray , (below gather: #literals) asArray
! !

!JsonObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	self printOn: aStream indent: 0! !

!JsonObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream indent: anInteger
	| string |
	string := JsonWriter write: self indent: anInteger.
	aStream eol = String crlf ifTrue: [string := string withCrLf].
	aStream isFileStream
		ifTrue: [aStream nextBytesPut: string utf8]
		ifFalse: [aStream nextPutAll: string]
! !

!JsonObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printTextOn: rtf
	self printTextOn: rtf indent: 0! !

!JsonObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printTextOn: rtf indent: anInteger
	JsonPainter write: self on: rtf indent: anInteger
! !

!JsonObject methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printTextOn: rtf limit: aNumber
	self printTextOn: rtf indent: 0! !

!JsonObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
selectors
	^#()
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonObject class' category: #JSON!
JsonObject class
	instanceVariableNames: ''!

!JsonObject class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromString: aString
	| json |
	json := JsonParser parse: aString.
	self ASSERT: json class == self.
	^json
! !


