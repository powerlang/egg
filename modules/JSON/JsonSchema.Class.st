'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonSchema category: #JSON!
Object subclass: #JsonSchema
	instanceVariableNames: 'title description default examples enum definitions parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonSchema methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:41'!
addDefinition: aJsonSchema named: aString
	definitions at: aString put: aJsonSchema.
	aJsonSchema parent: self
! !

!JsonSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	| json |
	json := JsonObject new.
	json type: self typeName.
	definitions notEmpty ifTrue: [json at: 'definitions' put: definitions].
	enum notNil ifTrue: [json at: 'enum' put: enum].
	default notNil ifTrue: [json at: 'default' put: default].
	examples notEmpty ifTrue: [json at: 'examples' put: examples].
	^json
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
default
	^default
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
default: anObject
	default := anObject
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
definitionNamed: aString
	definitions at: aString ifPresent: [:s | ^s].
	^parent notNil ifTrue: [parent definitionNamed: aString]
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
description
	^description
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
description: aString
	description := aString
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
enum
	^enum
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
enum: aCollection
	enum := aCollection
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
examples
	^examples
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
examples: aCollection
	examples := aCollection
! !

!JsonSchema methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	examples := OrderedCollection new.
	definitions := Dictionary new
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isAnySchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isArraySchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isBooleanSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isIntegerSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isNotSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isNullSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isNumberSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isObjectSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isOneSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isPrimitiveSchema
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isSchemaReference
	^false
! !

!JsonSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isStringSchema
	^false
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
name
	^title
! !

!JsonSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
not
	^JsonNotSchema new schema: self
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parent
	^parent
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
parent: aJsonSchema
	parent := aJsonSchema
! !

!JsonSchema methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:41'!
printOn: aStream
	self asJson printOn: aStream
! !

!JsonSchema methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:41'!
printTextOn: rtf
	self asJson printTextOn: rtf
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
title
	^title
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
title: aString
	title := aString
! !

!JsonSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
typeName
	^self class typeName
! !

!JsonSchema methodsFor:  'validation' stamp: 'KenD 28/Jun/2026 13:27:41'!
validate: aJsonObject
	^JsonObjectValidator validate: aJsonObject against: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonSchema class' category: #JSON!
JsonSchema class
	instanceVariableNames: ''!

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
anyOf: aCollection
	^JsonAnySchema new schemas: aCollection
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
array
	^JsonArraySchema new
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
arrayOf: aJsonSchema
	^JsonArraySchema new items: aJsonSchema
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
boolean
	^JsonBooleanSchema new
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
integer
	^JsonIntegerSchema new
! !

!JsonSchema class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isAbstract
	^self = JsonSchema
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
multipleOf: aNumber
	^JsonNumberSchema new multipleOf: aNumber
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
not: aJsonSchema
	^JsonNotSchema new schema: aJsonSchema
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
null
	^JsonNullSchema new
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
number
	^JsonNumberSchema new
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
object
	^JsonObjectSchema new
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
oneOf: aCollection
	^JsonOneSchema new schemas: aCollection
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
ref: aString
	^JsonSchemaReference path: aString
! !

!JsonSchema class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
string
	^JsonStringSchema new
! !

!JsonSchema class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
typeName
	^((self name trimPrefix: 'Json') trimTail: 'Schema') asLowercase
! !

!JsonSchema class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
typeNamed: aString
	^self allSubclasses
		detect: [:c | c isAbstract not and: [c typeName = aString]]
		ifNone: [self error: 'Type named ' , aString asString , ' not found']
! !


JsonSchema initialize!

