"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonPropertyMap,
	#superclass : #Object,
	#instVars : [
		'property',
		'getter',
		'setter',
		'mapping'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
JsonPropertyMap class >> fromType: anEdmPropertyType mapping: aJsonMapping [
	^JsonPropertyMap new mapping: aJsonMapping; fromType: anEdmPropertyType
]

{ #category : #accessing }
JsonPropertyMap >> adaptor: aDataAdaptor [
	self getterAdaptor: aDataAdaptor; setterAdaptor: aDataAdaptor
]

{ #category : #services }
JsonPropertyMap >> defaultGetter [
	| default class identifier |
	default := property name asSymbol.
	class := mapping objectClass.
	class isNil ifTrue: [^default].
	(class canUnderstand: default) ifTrue: [^default].
	default first isUppercase ifFalse: [^default].
	identifier := default asIdentifier.
	^(class canUnderstand: identifier) ifTrue: [identifier] ifFalse: [default]
]

{ #category : #private }
JsonPropertyMap >> defaultSetter [
	^(getter key , ':') asSymbol -> getter value
]

{ #category : #private }
JsonPropertyMap >> fromType: anEdmPropertyType [
	property := anEdmPropertyType.
	getter := property name asSymbol -> nil
]

{ #category : #services }
JsonPropertyMap >> getFrom: anObject [
	| value adaptor |
	value := getter key evaluateWith: anObject.
	value isNil ifTrue: [^nil].
	adaptor := getter value.
	adaptor isNil ifTrue: [^value].
	^self isArrayed
		ifTrue: [value collect: [:element | adaptor dataFrom: element]]
		ifFalse: [adaptor dataFrom: value]
]

{ #category : #accessing }
JsonPropertyMap >> getter: anAssociation [
	getter := anAssociation
]

{ #category : #accessing }
JsonPropertyMap >> getterAdaptor: aDataAdaptor [
	getter notNil ifTrue: [getter value: aDataAdaptor]
]

{ #category : #testing }
JsonPropertyMap >> isArrayed [
	^property isArrayed
]

{ #category : #testing }
JsonPropertyMap >> isKey [
	^property isKey
]

{ #category : #testing }
JsonPropertyMap >> isOptional [
	^property isOptional
]

{ #category : #accessing }
JsonPropertyMap >> mapping: aJsonMapping [
	mapping := aJsonMapping
]

{ #category : #accessing }
JsonPropertyMap >> name [
	^property name
]

{ #category : #accessing }
JsonPropertyMap >> name: aString [
	property name: aString
]

{ #category : #private }
JsonPropertyMap >> objectFrom: value [
	| adaptor |
	adaptor := self setter value.
	^adaptor isNil ifTrue: [value] ifFalse: [adaptor objectFrom: value]
]

{ #category : #printing }
JsonPropertyMap >> printOn: aStream [
	aStream nextPut: $#; nextPutAll: getter key printString.
	getter value ifNotNil: [:adaptor | 
		aStream nextPut: $(.
		adaptor printOn: aStream.
		aStream nextPut: $)].
	aStream nextPut: $→; nextPutAll: property name
]

{ #category : #accessing }
JsonPropertyMap >> property [
	^property
]

{ #category : #accessing }
JsonPropertyMap >> property: anEdmPropertyType [
	property := anEdmPropertyType
]

{ #category : #services }
JsonPropertyMap >> set: value to: anObject [
	| adaptor adapted |
	adaptor := self setter value.
	adapted := adaptor isNil ifTrue: [value] ifFalse: [
		self isArrayed
			ifTrue: [value collect: [:element | adaptor objectFrom: element]]
			ifFalse: [adaptor objectFrom: value]].
	self setter key evaluateWith: anObject with: adapted
]

{ #category : #accessing }
JsonPropertyMap >> setter [
	^setter ifNil: [self defaultSetter]
]

{ #category : #accessing }
JsonPropertyMap >> setter: anAssociation [
	setter := anAssociation
]

{ #category : #accessing }
JsonPropertyMap >> setterAdaptor: aDataAdaptor [
	setter notNil ifTrue: [setter value: aDataAdaptor]
]

{ #category : #accessing }
JsonPropertyMap >> type [
	^property type
]

{ #category : #services }
JsonPropertyMap >> useDefaultGetter [
	getter key: self defaultGetter
]

