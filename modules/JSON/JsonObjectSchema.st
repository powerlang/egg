"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonObjectSchema,
	#superclass : #JsonSchema,
	#instVars : [
		'properties',
		'required',
		'additionalProperties'
	],
	#category : #JSON
}

{ #category : #accessing }
JsonObjectSchema >> additionalProperties [
	^additionalProperties
]

{ #category : #accessing }
JsonObjectSchema >> additionalProperties: anObject [
	additionalProperties := anObject
]

{ #category : #'adding / removing' }
JsonObjectSchema >> addProperty: aString schema: aJsonSchema [
	properties at: aString put: aJsonSchema.
	aJsonSchema parent: self
]

{ #category : #converting }
JsonObjectSchema >> asJson [
	| json |
	json := super asJson.
	json at: 'properties' put: properties.
	required notEmpty ifTrue: [json at: 'required' put: required].
	additionalProperties notEmpty
		ifTrue: [json at: 'additionalProperties' put: additionalProperties].
	^json
]

{ #category : #initialization }
JsonObjectSchema >> initialize [
	super initialize.
	properties := Dictionary new.
	required := OrderedCollection new.
	additionalProperties := OrderedCollection new
]

{ #category : #testing }
JsonObjectSchema >> isObjectSchema [
	^true
]

{ #category : #accessing }
JsonObjectSchema >> properties [
	^properties
]

{ #category : #accessing }
JsonObjectSchema >> propertyAt: aString [
	^properties at: aString ifAbsent: nil
]

{ #category : #'adding / removing' }
JsonObjectSchema >> removeProperty: aString [
	properties remove: aString ifAbsent: nil
]

{ #category : #accessing }
JsonObjectSchema >> required [
	^required
]

{ #category : #accessing }
JsonObjectSchema >> required: aCollection [
	required := aCollection
]

{ #category : #testing }
JsonObjectSchema >> requires: aString [
	^required includes: aString
]

