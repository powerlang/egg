'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonPropertyMap category: #JSON!
Object subclass: #JsonPropertyMap
	instanceVariableNames: 'property getter setter mapping'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonPropertyMap commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
adaptor: aDataAdaptor
	self getterAdaptor: aDataAdaptor; setterAdaptor: aDataAdaptor
! !

!JsonPropertyMap methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultGetter
	| default class identifier |
	default := property name asSymbol.
	class := mapping objectClass.
	class isNil ifTrue: [^default].
	(class canUnderstand: default) ifTrue: [^default].
	default first isUppercase ifFalse: [^default].
	identifier := default asIdentifier.
	^(class canUnderstand: identifier) ifTrue: [identifier] ifFalse: [default]
! !

!JsonPropertyMap methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultSetter
	^(getter key , ':') asSymbol -> getter value
! !

!JsonPropertyMap methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
fromType: anEdmPropertyType
	property := anEdmPropertyType.
	getter := property name asSymbol -> nil
! !

!JsonPropertyMap methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
getFrom: anObject
	| value adaptor |
	value := getter key evaluateWith: anObject.
	value isNil ifTrue: [^nil].
	adaptor := getter value.
	adaptor isNil ifTrue: [^value].
	^self isArrayed
		ifTrue: [value collect: [:element | adaptor dataFrom: element]]
		ifFalse: [adaptor dataFrom: value]
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
getter: anAssociation
	getter := anAssociation
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
getterAdaptor: aDataAdaptor
	getter notNil ifTrue: [getter value: aDataAdaptor]
! !

!JsonPropertyMap methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isArrayed
	^property isArrayed
! !

!JsonPropertyMap methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isKey
	^property isKey
! !

!JsonPropertyMap methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isOptional
	^property isOptional
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
mapping: aJsonMapping
	mapping := aJsonMapping
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
name
	^property name
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
name: aString
	property name: aString
! !

!JsonPropertyMap methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: value
	| adaptor |
	adaptor := self setter value.
	^adaptor isNil ifTrue: [value] ifFalse: [adaptor objectFrom: value]
! !

!JsonPropertyMap methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:41'!
printOn: aStream
	aStream nextPut: $#; nextPutAll: getter key printString.
	getter value ifNotNil: [:adaptor | 
		aStream nextPut: $(.
		adaptor printOn: aStream.
		aStream nextPut: $)].
	aStream nextPut: $→; nextPutAll: property name
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
property
	^property
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
property: anEdmPropertyType
	property := anEdmPropertyType
! !

!JsonPropertyMap methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
set: value to: anObject
	| adaptor adapted |
	adaptor := self setter value.
	adapted := adaptor isNil ifTrue: [value] ifFalse: [
		self isArrayed
			ifTrue: [value collect: [:element | adaptor objectFrom: element]]
			ifFalse: [adaptor objectFrom: value]].
	self setter key evaluateWith: anObject with: adapted
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
setter
	^setter ifNil: [self defaultSetter]
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
setter: anAssociation
	setter := anAssociation
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
setterAdaptor: aDataAdaptor
	setter notNil ifTrue: [setter value: aDataAdaptor]
! !

!JsonPropertyMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
type
	^property type
! !

!JsonPropertyMap methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
useDefaultGetter
	getter key: self defaultGetter
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonPropertyMap class' category: #JSON!
JsonPropertyMap class
	instanceVariableNames: ''!

!JsonPropertyMap class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
fromType: anEdmPropertyType mapping: aJsonMapping
	^JsonPropertyMap new mapping: aJsonMapping; fromType: anEdmPropertyType
! !


