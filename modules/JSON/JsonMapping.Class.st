'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #JsonMapping category: #JSON!
Object subclass: #JsonMapping
	instanceVariableNames: 'type class properties registry locator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonMapping commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonMapping methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
classFrom: aDictionary
	| subclass |
	class isNil ifTrue: [^nil].
	subclass := (class hasSubclasses
		and: [class respondsTo: #classForJsonDictionary:])
		ifTrue: [class classForJsonDictionary: aDictionary].
	^subclass ifNil: [class]
! !

!JsonMapping methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromSchema: aJsonSchema
	type := aJsonSchema.
	properties := type properties
		collect: [:property | JsonPropertyMap fromType: property mapping: self]
! !

!JsonMapping methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromType: anEdmType
	type := anEdmType.
	properties := type allProperties
		collect: [:property | JsonPropertyMap fromType: property mapping: self]
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
get: key with: selector
	self get: key with: selector adaptor: nil
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
get: key with: selector adaptor: adaptor
	| map |
	map := properties at: key ifAbsentPut: [self newMap name: key].
	map getter: selector -> adaptor
! !

!JsonMapping methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	properties := OrderedDictionary new
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
instanceFor: aDictionary
	^locator notNil ifTrue: [locator evaluateWith: aDictionary]
! !

!JsonMapping methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
jsonObjectFrom: anObject
	^self serializer jsonObjectFrom: anObject using: self
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
keys
	^type isEntityType
		ifTrue: [properties select: [:p | p isKey]]
		ifFalse: [properties]
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
locator: evaluableObject
	locator := evaluableObject
! !

!JsonMapping methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
newMap
	^JsonPropertyMap new
		property: EdmPropertyType new useDefaults;
		mapping: self
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
objectClass
	^class
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
objectClass: aClass
	class := aClass isSymbol
		ifTrue: [
			Smalltalk at: aClass ifAbsent: [
				Notification signal: 'Class not found'.
				JsonObject]]
		ifFalse: [aClass isString
			ifTrue: [Smalltalk classNamed: aClass]
			ifFalse: [aClass]]
! !

!JsonMapping methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
objectFrom: aDictionary
	^self serializer
		mappings: registry;
		objectFrom: aDictionary using: self
! !

!JsonMapping methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	aStream
		nextPutAll: type typeName;
		nextPutAll: ' type → ';
		nextPutAll: class name
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
properties
	^properties
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
propertyAt: aString
	^properties at: aString ifAbsent: nil
! !

!JsonMapping methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
read: aJsonObject into: anObject
	self serializer
		mappings: registry;
		objectFrom: aJsonObject into: anObject using: self
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
registry
	^registry
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
registry: aJsonMappingRegistry
	registry := aJsonMappingRegistry
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
removeProperty: aString
	properties removeKey: aString ifAbsent: nil
! !

!JsonMapping methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
serializer
	^JsonSerializer new condition: true; mappings: registry
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
set: key with: selector
	self set: key with: selector adaptor: nil
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
set: key with: selector adaptor: adaptor
	| map |
	map := properties at: key ifAbsentPut: [self newMap name: key].
	map setter: selector -> adaptor
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
type
	^type
! !

!JsonMapping methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
typeName
	^type typeName
! !

!JsonMapping methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
useDefaultGetters
	properties do: #useDefaultGetter
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonMapping class' category: #JSON!
JsonMapping class
	instanceVariableNames: ''!

!JsonMapping class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultFromSchema: aJsonSchema toClass: aClass
	^(self fromSchema: aJsonSchema toClass: aClass) useDefaultGetters
! !

!JsonMapping class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultFromType: anEdmType toClass: aClass
	^(self fromType: anEdmType toClass: aClass) useDefaultGetters
! !

!JsonMapping class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromSchema: aJsonSchema
	^self fromSchema: aJsonSchema toClass: nil
! !

!JsonMapping class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromSchema: aJsonSchema toClass: aClass
	^self new fromSchema: aJsonSchema; objectClass: aClass
! !

!JsonMapping class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromType: anEdmType
	^self fromType: anEdmType toClass: nil
! !

!JsonMapping class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromType: anEdmType toClass: aClass
	^self new fromType: anEdmType; objectClass: aClass
! !


JsonMapping initialize!

