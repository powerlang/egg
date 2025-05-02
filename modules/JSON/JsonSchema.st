"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonSchema,
	#superclass : #Object,
	#instVars : [
		'title',
		'description',
		'default',
		'examples',
		'enum',
		'definitions',
		'parent'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
JsonSchema class >> anyOf: aCollection [
	^JsonAnySchema new schemas: aCollection
]

{ #category : #'instance creation' }
JsonSchema class >> array [
	^JsonArraySchema new
]

{ #category : #'instance creation' }
JsonSchema class >> arrayOf: aJsonSchema [
	^JsonArraySchema new items: aJsonSchema
]

{ #category : #'instance creation' }
JsonSchema class >> boolean [
	^JsonBooleanSchema new
]

{ #category : #'instance creation' }
JsonSchema class >> integer [
	^JsonIntegerSchema new
]

{ #category : #accessing }
JsonSchema class >> isAbstract [
	^self = JsonSchema
]

{ #category : #'instance creation' }
JsonSchema class >> multipleOf: aNumber [
	^JsonNumberSchema new multipleOf: aNumber
]

{ #category : #'instance creation' }
JsonSchema class >> not: aJsonSchema [
	^JsonNotSchema new schema: aJsonSchema
]

{ #category : #'instance creation' }
JsonSchema class >> null [
	^JsonNullSchema new
]

{ #category : #'instance creation' }
JsonSchema class >> number [
	^JsonNumberSchema new
]

{ #category : #'instance creation' }
JsonSchema class >> object [
	^JsonObjectSchema new
]

{ #category : #'instance creation' }
JsonSchema class >> oneOf: aCollection [
	^JsonOneSchema new schemas: aCollection
]

{ #category : #'instance creation' }
JsonSchema class >> ref: aString [
	^JsonSchemaReference path: aString
]

{ #category : #'instance creation' }
JsonSchema class >> string [
	^JsonStringSchema new
]

{ #category : #accessing }
JsonSchema class >> typeName [
	^((self name trimPrefix: 'Json') trimTail: 'Schema') asLowercase
]

{ #category : #accessing }
JsonSchema class >> typeNamed: aString [
	^self allSubclasses
		detect: [:c | c isAbstract not and: [c typeName = aString]]
		ifNone: [self error: 'Type named ' , aString asString , ' not found']
]

{ #category : #'adding / removing' }
JsonSchema >> addDefinition: aJsonSchema named: aString [
	definitions at: aString put: aJsonSchema.
	aJsonSchema parent: self
]

{ #category : #converting }
JsonSchema >> asJson [
	| json |
	json := JsonObject new.
	json type: self typeName.
	definitions notEmpty ifTrue: [json at: 'definitions' put: definitions].
	enum notNil ifTrue: [json at: 'enum' put: enum].
	default notNil ifTrue: [json at: 'default' put: default].
	examples notEmpty ifTrue: [json at: 'examples' put: examples].
	^json
]

{ #category : #accessing }
JsonSchema >> default [
	^default
]

{ #category : #accessing }
JsonSchema >> default: anObject [
	default := anObject
]

{ #category : #accessing }
JsonSchema >> definitionNamed: aString [
	definitions at: aString ifPresent: [:s | ^s].
	^parent notNil ifTrue: [parent definitionNamed: aString]
]

{ #category : #accessing }
JsonSchema >> description [
	^description
]

{ #category : #accessing }
JsonSchema >> description: aString [
	description := aString
]

{ #category : #accessing }
JsonSchema >> enum [
	^enum
]

{ #category : #accessing }
JsonSchema >> enum: aCollection [
	enum := aCollection
]

{ #category : #accessing }
JsonSchema >> examples [
	^examples
]

{ #category : #accessing }
JsonSchema >> examples: aCollection [
	examples := aCollection
]

{ #category : #initialization }
JsonSchema >> initialize [
	super initialize.
	examples := OrderedCollection new.
	definitions := Dictionary new
]

{ #category : #testing }
JsonSchema >> isAnySchema [
	^false
]

{ #category : #testing }
JsonSchema >> isArraySchema [
	^false
]

{ #category : #testing }
JsonSchema >> isBooleanSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isIntegerSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isNotSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isNullSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isNumberSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isObjectSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isOneSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isPrimitiveSchema [
	^false
]

{ #category : #testing }
JsonSchema >> isSchemaReference [
	^false
]

{ #category : #testing }
JsonSchema >> isStringSchema [
	^false
]

{ #category : #accessing }
JsonSchema >> name [
	^title
]

{ #category : #converting }
JsonSchema >> not [
	^JsonNotSchema new schema: self
]

{ #category : #accessing }
JsonSchema >> parent [
	^parent
]

{ #category : #accessing }
JsonSchema >> parent: aJsonSchema [
	parent := aJsonSchema
]

{ #category : #printing }
JsonSchema >> printOn: aStream [
	self asJson printOn: aStream
]

{ #category : #printing }
JsonSchema >> printTextOn: rtf [
	self asJson printTextOn: rtf
]

{ #category : #accessing }
JsonSchema >> title [
	^title
]

{ #category : #accessing }
JsonSchema >> title: aString [
	title := aString
]

{ #category : #accessing }
JsonSchema >> typeName [
	^self class typeName
]

{ #category : #validation }
JsonSchema >> validate: aJsonObject [
	^JsonObjectValidator validate: aJsonObject against: self
]

