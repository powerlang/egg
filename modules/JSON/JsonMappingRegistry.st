"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #JsonMappingRegistry,
	#superclass : #Object,
	#instVars : [
		'mappings',
		'classes'
	],
	#category : #JSON
}

{ #category : #mappings }
JsonMappingRegistry >> addMappingsFrom: aJsonMappingRegistry [
	aJsonMappingRegistry mappingsDo: [:mapping | self register: mapping]
]

{ #category : #initialization }
JsonMappingRegistry >> initialize [
	super initialize.
	mappings := Dictionary new.
	classes := Dictionary new
]

{ #category : #mappings }
JsonMappingRegistry >> mappingFor: anObject [
	^self mappingForClass: anObject class
]

{ #category : #mappings }
JsonMappingRegistry >> mappingForClass: aClass [
	| class |
	class := aClass.
	[| mapping |
		mapping := classes at: class name ifAbsent: nil.
		mapping isNil ifTrue: [
			mapping := mappings detect: [:m | m objectClass == class] ifNone: nil.
			mapping notNil ifTrue: [classes at: class name put: mapping]].
		mapping notNil ifTrue: [^mapping].
		class := class superclass.
		class notNil] whileTrue.
	^nil
]

{ #category : #mappings }
JsonMappingRegistry >> mappingForType: anEdmType [
	^mappings detect: [:m | m type = anEdmType] ifNone: nil
]

{ #category : #mappings }
JsonMappingRegistry >> mappingNamed: aString [
	^mappings at: aString ifAbsent: nil
]

{ #category : #mappings }
JsonMappingRegistry >> mappingNamed: aString ifAbsentPut: aBlock [
	^mappings at: aString ifAbsent: [self register: aBlock value]
]

{ #category : #enumerating }
JsonMappingRegistry >> mappingsDo: aBlock [
	mappings do: aBlock
]

{ #category : #mappings }
JsonMappingRegistry >> register: aJsonMapping [
	^self register: aJsonMapping withName: aJsonMapping typeName
]

{ #category : #mappings }
JsonMappingRegistry >> register: aJsonMapping withName: aString [
	aJsonMapping registry: self.
	classes at: aJsonMapping objectClass name put: aJsonMapping.
	^mappings at: aString put: aJsonMapping
]

