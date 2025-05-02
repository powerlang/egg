"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonSchemaReference,
	#superclass : #Object,
	#instVars : [
		'path'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
JsonSchemaReference class >> path: aString [
	^self new path: aString
]

{ #category : #converting }
JsonSchemaReference >> asJson [
	^path
]

{ #category : #testing }
JsonSchemaReference >> isLocal [
	^path beginsWith: '#'
]

{ #category : #testing }
JsonSchemaReference >> isSchemaReference [
	^true
]

{ #category : #accessing }
JsonSchemaReference >> parent: aJsonSchema [
	"
	do nothing
	"
	]

{ #category : #accessing }
JsonSchemaReference >> path [
	^path
]

{ #category : #accessing }
JsonSchemaReference >> path: aString [
	path := aString
]

{ #category : #printing }
JsonSchemaReference >> printOn: aStream [
	path printOn: aStream
]

{ #category : #resolving }
JsonSchemaReference >> resolveIn: aJsonSchema [
	| segments schema i |
	self ASSERT: self isLocal.
	segments := $/ split: path allButFirst.
	segments := segments reject: #isEmpty.
	schema := aJsonSchema.
	i := 1.
	[i <= segments size] whileTrue: [| segment |
		segment := segments at: i.
		schema := segment = 'definitions'
			ifTrue: [
				i = segments size ifTrue: [^nil].
				i := i + 1.
				schema definitionNamed: (segments at: i)]
			ifFalse: [schema propertyAt: segment].
		schema isNil ifTrue: [^nil].
		i := i + 1].
	^schema
]

