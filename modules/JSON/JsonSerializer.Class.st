'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonSerializer category: #JSON!
Object subclass: #JsonSerializer
	instanceVariableNames: 'mappings level condition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonSerializer commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonSerializer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
condition: aBlock
	condition := aBlock
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultDictionaryFrom: anObject
	| dictionary |
	dictionary := Dictionary new.
	dictionary at: 'Class' put: anObject class name.
	anObject class allInstVarNames do: [:key | | ivar |
		ivar := anObject instVarNamed: key.
		dictionary at: key put: ivar].
	^dictionary
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
getObject: aJsonPropertyMap from: aJsonObject
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
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
getProperty: aJsonPropertyMap from: anObject
	| value |
	value := aJsonPropertyMap getFrom: anObject.
	value isNil ifTrue: [^nil].
	^self jsonFrom: value
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
inflate: aString
	^self inflate: aString using: nil
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
inflate: aString using: aJsonMapping
	| json |
	json := [JsonParser parse: aString] on: JsonError do: [].
	json isNil ifTrue: [^nil].
	^self objectFrom: json using: aJsonMapping
! !

!JsonSerializer methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	level := 0.
	self upToLevel: 2! !

!JsonSerializer methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isLeaf: anObject
	anObject isUndefinedValue ifTrue: [^true].
	anObject isNumber ifTrue: [^true].
	anObject isString ifTrue: [^true].
	anObject isBoolean ifTrue: [^true].
	anObject isDate ifTrue: [^true].
	anObject isTimestamp ifTrue: [^true].
	^false
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
jsonFrom: anObject
	(self isLeaf: anObject) ifTrue: [^anObject].
	anObject isCollection ifTrue: [
		^anObject collect: [:element | | d |
			level := level + 1.
			d := self jsonFrom: element.
			level := level - 1.
			d]].
	^self jsonObjectFrom: anObject
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
jsonObjectFrom: anObject
	| mapping |
	anObject isJsonObject ifTrue: [^anObject].
	mapping := self mappingForObject: anObject.
	mapping notNil ifTrue: [^self jsonObjectFrom: anObject using: mapping].
	(anObject respondsTo: #asJson) ifTrue: [^anObject asJson].
	^self defaultDictionaryFrom: anObject
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
jsonObjectFrom: anObject using: aJsonMapping
	| json |
	json := JsonObject new.
	aJsonMapping properties do: [:p | 
		level := level + 1.
		self writeProperty: p from: anObject into: json.
		level := level - 1].
	^json notEmpty ifTrue: [json]
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingForObject: anObject
	^mappings notNil ifTrue: [mappings mappingFor: anObject]
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingForType: anEdmType
	^mappings notNil ifTrue: [mappings mappingForType: anEdmType]
! !

!JsonSerializer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappings: aJsonMappingRegistry
	mappings := aJsonMappingRegistry
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: aJsonObject into: anObject using: aJsonMapping
	aJsonMapping properties
		do: [:p | self readProperty: p from: aJsonObject into: anObject].
	^anObject
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: anObject using: aJsonMapping
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
! !

!JsonSerializer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
onlyKeys
	self upToLevel: 1! !

!JsonSerializer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
onlyKeysFromLevel: anInteger
	self upToLevel: anInteger
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
readProperty: aJsonPropertyMap from: aJsonObject into: anObject
	| object |
	object := self getObject: aJsonPropertyMap from: aJsonObject.
	(object isNil and: [aJsonPropertyMap isOptional]) ifTrue: [^self].
	((condition evaluateWith: level with: object) or: [aJsonPropertyMap isKey])
		ifTrue: [aJsonPropertyMap set: object to: anObject]
! !

!JsonSerializer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
serialize: anObject
	| json |
	json := self jsonFrom: anObject.
	^JsonWriter write: json
! !

!JsonSerializer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
upToLevel: anInteger
	condition := [:depth :object | depth <= anInteger]
! !

!JsonSerializer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
writeProperty: aJsonPropertyMap from: anObject into: aJsonObject
	| value |
	value := self getProperty: aJsonPropertyMap from: anObject.
	(value isNil and: [aJsonPropertyMap isOptional]) ifTrue: [^self].
	((condition evaluateWith: level with: anObject) or: [aJsonPropertyMap isKey])
		ifTrue: [aJsonObject at: aJsonPropertyMap name put: value]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonSerializer class' category: #JSON!
JsonSerializer class
	instanceVariableNames: ''!

!JsonSerializer class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
inflate: anObject
	^self new inflate: anObject
! !

!JsonSerializer class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
serialize: anObject
	^self new serialize: anObject
! !


JsonSerializer initialize!

