"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonMapping,
	#superclass : #Object,
	#instVars : [
		'type',
		'class',
		'properties',
		'registry',
		'locator'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
JsonMapping class >> defaultFromSchema: aJsonSchema toClass: aClass [
	^(self fromSchema: aJsonSchema toClass: aClass) useDefaultGetters
]

{ #category : #'instance creation' }
JsonMapping class >> defaultFromType: anEdmType toClass: aClass [
	^(self fromType: anEdmType toClass: aClass) useDefaultGetters
]

{ #category : #'instance creation' }
JsonMapping class >> fromSchema: aJsonSchema [
	^self fromSchema: aJsonSchema toClass: nil
]

{ #category : #'instance creation' }
JsonMapping class >> fromSchema: aJsonSchema toClass: aClass [
	^self new fromSchema: aJsonSchema; objectClass: aClass
]

{ #category : #'instance creation' }
JsonMapping class >> fromType: anEdmType [
	^self fromType: anEdmType toClass: nil
]

{ #category : #'instance creation' }
JsonMapping class >> fromType: anEdmType toClass: aClass [
	^self new fromType: anEdmType; objectClass: aClass
]

{ #category : #services }
JsonMapping >> classFrom: aDictionary [
	| subclass |
	class isNil ifTrue: [^nil].
	subclass := (class hasSubclasses
		and: [class respondsTo: #classForJsonDictionary:])
		ifTrue: [class classForJsonDictionary: aDictionary].
	^subclass ifNil: [class]
]

{ #category : #private }
JsonMapping >> fromSchema: aJsonSchema [
	type := aJsonSchema.
	properties := type properties
		collect: [:property | JsonPropertyMap fromType: property mapping: self]
]

{ #category : #private }
JsonMapping >> fromType: anEdmType [
	type := anEdmType.
	properties := type allProperties
		collect: [:property | JsonPropertyMap fromType: property mapping: self]
]

{ #category : #accessing }
JsonMapping >> get: key with: selector [
	self get: key with: selector adaptor: nil
]

{ #category : #accessing }
JsonMapping >> get: key with: selector adaptor: adaptor [
	| map |
	map := properties at: key ifAbsentPut: [self newMap name: key].
	map getter: selector -> adaptor
]

{ #category : #initialization }
JsonMapping >> initialize [
	super initialize.
	properties := OrderedDictionary new
]

{ #category : #accessing }
JsonMapping >> instanceFor: aDictionary [
	^locator notNil ifTrue: [locator evaluateWith: aDictionary]
]

{ #category : #services }
JsonMapping >> jsonObjectFrom: anObject [
	^self serializer jsonObjectFrom: anObject using: self
]

{ #category : #accessing }
JsonMapping >> keys [
	^type isEntityType
		ifTrue: [properties select: [:p | p isKey]]
		ifFalse: [properties]
]

{ #category : #accessing }
JsonMapping >> locator: evaluableObject [
	locator := evaluableObject
]

{ #category : #private }
JsonMapping >> newMap [
	^JsonPropertyMap new
		property: EdmPropertyType new useDefaults;
		mapping: self
]

{ #category : #accessing }
JsonMapping >> objectClass [
	^class
]

{ #category : #accessing }
JsonMapping >> objectClass: aClass [
	class := aClass isSymbol
		ifTrue: [
			Smalltalk at: aClass ifAbsent: [
				Notification signal: 'Class not found'.
				JsonObject]]
		ifFalse: [aClass isString
			ifTrue: [Smalltalk classNamed: aClass]
			ifFalse: [aClass]]
]

{ #category : #services }
JsonMapping >> objectFrom: aDictionary [
	^self serializer
		mappings: registry;
		objectFrom: aDictionary using: self
]

{ #category : #printing }
JsonMapping >> printOn: aStream [
	aStream
		nextPutAll: type typeName;
		nextPutAll: ' type → ';
		nextPutAll: class name
]

{ #category : #accessing }
JsonMapping >> properties [
	^properties
]

{ #category : #accessing }
JsonMapping >> propertyAt: aString [
	^properties at: aString ifAbsent: nil
]

{ #category : #services }
JsonMapping >> read: aJsonObject into: anObject [
	self serializer
		mappings: registry;
		objectFrom: aJsonObject into: anObject using: self
]

{ #category : #accessing }
JsonMapping >> registry [
	^registry
]

{ #category : #accessing }
JsonMapping >> registry: aJsonMappingRegistry [
	registry := aJsonMappingRegistry
]

{ #category : #accessing }
JsonMapping >> removeProperty: aString [
	properties removeKey: aString ifAbsent: nil
]

{ #category : #services }
JsonMapping >> serializer [
	^JsonSerializer new condition: true; mappings: registry
]

{ #category : #accessing }
JsonMapping >> set: key with: selector [
	self set: key with: selector adaptor: nil
]

{ #category : #accessing }
JsonMapping >> set: key with: selector adaptor: adaptor [
	| map |
	map := properties at: key ifAbsentPut: [self newMap name: key].
	map setter: selector -> adaptor
]

{ #category : #accessing }
JsonMapping >> type [
	^type
]

{ #category : #accessing }
JsonMapping >> typeName [
	^type typeName
]

{ #category : #services }
JsonMapping >> useDefaultGetters [
	properties do: #useDefaultGetter
]

