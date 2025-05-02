"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonNumberSchema,
	#superclass : #JsonPrimitiveSchema,
	#instVars : [
		'minimum',
		'exclusiveMinimum',
		'maximum',
		'exclusiveMaximum',
		'multipleOf'
	],
	#category : #JSON
}

{ #category : #converting }
JsonNumberSchema >> asJson [
	| json |
	json := super asJson.
	minimum notNil ifTrue: [
		json
			at: 'minimum' put: minimum;
			at: 'exclusiveMinimum' put: exclusiveMinimum].
	maximum notNil ifTrue: [
		json
			at: 'maximum' put: maximum;
			at: 'exclusiveMinimum' put: exclusiveMaximum].
	multipleOf notNil ifTrue: [json at: 'multipleOf' put: multipleOf].
	^json
]

{ #category : #accessing }
JsonNumberSchema >> defaultFormat [
	^JsonNumberFormat new
]

{ #category : #accessing }
JsonNumberSchema >> exclusiveMaximum [
	^exclusiveMaximum ifTrue: [maximum]
]

{ #category : #accessing }
JsonNumberSchema >> exclusiveMaximum: anObject [
	anObject isNumber
		ifTrue: [
			maximum := anObject.
			exclusiveMaximum := true]
		ifFalse: [exclusiveMaximum := anObject]
]

{ #category : #accessing }
JsonNumberSchema >> exclusiveMinimum [
	^exclusiveMinimum ifTrue: [minimum]
]

{ #category : #accessing }
JsonNumberSchema >> exclusiveMinimum: anObject [
	anObject isNumber
		ifTrue: [
			minimum := anObject.
			exclusiveMinimum := true]
		ifFalse: [exclusiveMinimum := anObject]
]

{ #category : #initialization }
JsonNumberSchema >> initialize [
	super initialize.
	exclusiveMinimum := exclusiveMaximum := false
]

{ #category : #testing }
JsonNumberSchema >> isNumberSchema [
	^true
]

{ #category : #accessing }
JsonNumberSchema >> maximum [
	^maximum
]

{ #category : #accessing }
JsonNumberSchema >> maximum: aNumber [
	maximum := aNumber
]

{ #category : #accessing }
JsonNumberSchema >> minimum [
	^minimum
]

{ #category : #accessing }
JsonNumberSchema >> minimum: aNumber [
	minimum := aNumber
]

{ #category : #accessing }
JsonNumberSchema >> multipleOf [
	^multipleOf
]

{ #category : #accessing }
JsonNumberSchema >> multipleOf: anNumber [
	multipleOf := anNumber
]

