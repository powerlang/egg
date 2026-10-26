'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonMappingRegistry category: #JSON!
Object subclass: #JsonMappingRegistry
	instanceVariableNames: 'mappings classes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonMappingRegistry commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
addMappingsFrom: aJsonMappingRegistry
	aJsonMappingRegistry mappingsDo: [:mapping | self register: mapping]
! !

!JsonMappingRegistry methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	mappings := Dictionary new.
	classes := Dictionary new
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingFor: anObject
	^self mappingForClass: anObject class
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingForClass: aClass
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
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingForType: anEdmType
	^mappings detect: [:m | m type = anEdmType] ifNone: nil
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingNamed: aString
	^mappings at: aString ifAbsent: nil
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingNamed: aString ifAbsentPut: aBlock
	^mappings at: aString ifAbsent: [self register: aBlock value]
! !

!JsonMappingRegistry methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
mappingsDo: aBlock
	mappings do: aBlock
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
register: aJsonMapping
	^self register: aJsonMapping withName: aJsonMapping typeName
! !

!JsonMappingRegistry methodsFor:  'mappings' stamp: 'KenD 28/Jun/2026 13:27:41'!
register: aJsonMapping withName: aString
	aJsonMapping registry: self.
	classes at: aJsonMapping objectClass name put: aJsonMapping.
	^mappings at: aString put: aJsonMapping
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonMappingRegistry class' category: #JSON!
JsonMappingRegistry class
	instanceVariableNames: ''!


JsonMappingRegistry initialize!

