"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonSerializer,
	#superclass : #Object,
	#instVars : [
		'mappings',
		'level',
		'condition'
	],
	#category : #JSON
}

{ #category : #services }
JsonSerializer class >> inflate: anObject [
	^self new inflate: anObject
]

{ #category : #services }
JsonSerializer class >> serialize: anObject [
	^self new serialize: anObject
]

{ #category : #accessing }
JsonSerializer >> condition: aBlock [
	condition := aBlock
]

{ #category : #private }
JsonSerializer >> defaultDictionaryFrom: anObject [
	| dictionary |
	dictionary := Dictionary new.
	dictionary at: 'Class' put: anObject class name.
	anObject class allInstVarNames do: [:key | | ivar |
		ivar := anObject instVarNamed: key.
		dictionary at: key put: ivar].
	^dictionary
]

{ #category : #private }
JsonSerializer >> getObject: aJsonPropertyMap from: aJsonObject [
	| key value mapping type |
	key := aJsonPropertyMap name.
	value := aJsonPropertyMap isOptional
		ifTrue: [aJsonObject valueAt: key]
		ifFalse: [aJsonObject at: key].
	value isNil ifTrue: [^nil].
	type := aJsonPropertyMap type singleType.
	type isBasicType ifTrue: [^value].
	mapping := self mappingForType: type.
	^self objectFrom: value using: mapping
]

{ #category : #private }
JsonSerializer >> getProperty: aJsonPropertyMap from: anObject [
	| value |
	value := aJsonPropertyMap getFrom: anObject.
	value isNil ifTrue: [^nil].
	^self jsonFrom: value
]

{ #category : #services }
JsonSerializer >> inflate: aString [
	^self inflate: aString using: nil
]

{ #category : #services }
JsonSerializer >> inflate: aString using: aJsonMapping [
	| json |
	json := [JsonParser parse: aString] on: JsonError do: [].
	json isNil ifTrue: [^nil].
	^self objectFrom: json using: aJsonMapping
]

{ #category : #initialization }
JsonSerializer >> initialize [
	super initialize.
	level := 0.
	self upToLevel: 2]

{ #category : #testing }
JsonSerializer >> isLeaf: anObject [
	anObject isUndefinedValue ifTrue: [^true].
	anObject isNumber ifTrue: [^true].
	anObject isString ifTrue: [^true].
	anObject isBoolean ifTrue: [^true].
	anObject isDate ifTrue: [^true].
	anObject isTimestamp ifTrue: [^true].
	^false
]

{ #category : #private }
JsonSerializer >> jsonFrom: anObject [
	(self isLeaf: anObject) ifTrue: [^anObject].
	anObject isCollection ifTrue: [
		^anObject collect: [:element | | d |
			level := level + 1.
			d := self jsonFrom: element.
			level := level - 1.
			d]].
	^self jsonObjectFrom: anObject
]

{ #category : #services }
JsonSerializer >> jsonObjectFrom: anObject [
	| mapping |
	anObject isJsonObject ifTrue: [^anObject].
	mapping := self mappingForObject: anObject.
	mapping notNil ifTrue: [^self jsonObjectFrom: anObject using: mapping].
	(anObject respondsTo: #asJson) ifTrue: [^anObject asJson].
	^self defaultDictionaryFrom: anObject
]

{ #category : #services }
JsonSerializer >> jsonObjectFrom: anObject using: aJsonMapping [
	| json |
	json := JsonObject new.
	aJsonMapping properties do: [:p | 
		level := level + 1.
		self writeProperty: p from: anObject into: json.
		level := level - 1].
	^json notEmpty ifTrue: [json]
]

{ #category : #private }
JsonSerializer >> mappingForObject: anObject [
	^mappings notNil ifTrue: [mappings mappingFor: anObject]
]

{ #category : #private }
JsonSerializer >> mappingForType: anEdmType [
	^mappings notNil ifTrue: [mappings mappingForType: anEdmType]
]

{ #category : #accessing }
JsonSerializer >> mappings: aJsonMappingRegistry [
	mappings := aJsonMappingRegistry
]

{ #category : #services }
JsonSerializer >> objectFrom: aJsonObject into: anObject using: aJsonMapping [
	aJsonMapping properties
		do: [:p | self readProperty: p from: aJsonObject into: anObject].
	^anObject
]

{ #category : #services }
JsonSerializer >> objectFrom: anObject using: aJsonMapping [
	| class mapping object |
	(self isLeaf: anObject) ifTrue: [^anObject].
	anObject isSequenceableCollection ifTrue: [
		^anObject collect: [:element | | o |
			level := level + 1.
			o := self objectFrom: element using: aJsonMapping.
			level := level - 1.
			o]].
	self ASSERT: anObject isDictionary.
	aJsonMapping isNil ifTrue: [^anObject].
	class := aJsonMapping classFrom: anObject.
	class isNil ifTrue: [^anObject].
	mapping := class == aJsonMapping objectClass
		ifTrue: [aJsonMapping]
		ifFalse: [(mappings mappingForClass: class) ifNil: [aJsonMapping]].
	object := (mapping instanceFor: anObject) ifNil: [class new].
	level := level + 1.
	self objectFrom: anObject into: object using: mapping.
	level := level - 1.
	^object
]

{ #category : #accessing }
JsonSerializer >> onlyKeys [
	self upToLevel: 1]

{ #category : #accessing }
JsonSerializer >> onlyKeysFromLevel: anInteger [
	self upToLevel: anInteger
]

{ #category : #private }
JsonSerializer >> readProperty: aJsonPropertyMap from: aJsonObject into: anObject [
	| object |
	object := self getObject: aJsonPropertyMap from: aJsonObject.
	(object isNil and: [aJsonPropertyMap isOptional]) ifTrue: [^self].
	((condition evaluateWith: level with: object) or: [aJsonPropertyMap isKey])
		ifTrue: [aJsonPropertyMap set: object to: anObject]
]

{ #category : #services }
JsonSerializer >> serialize: anObject [
	| json |
	json := self jsonFrom: anObject.
	^JsonWriter write: json
]

{ #category : #accessing }
JsonSerializer >> upToLevel: anInteger [
	condition := [:depth :object | depth <= anInteger]
]

{ #category : #private }
JsonSerializer >> writeProperty: aJsonPropertyMap from: anObject into: aJsonObject [
	| value |
	value := self getProperty: aJsonPropertyMap from: anObject.
	(value isNil and: [aJsonPropertyMap isOptional]) ifTrue: [^self].
	((condition evaluateWith: level with: anObject) or: [aJsonPropertyMap isKey])
		ifTrue: [aJsonObject at: aJsonPropertyMap name put: value]
]

