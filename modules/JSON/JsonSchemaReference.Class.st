'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #JsonSchemaReference category: #JSON!
Object subclass: #JsonSchemaReference
	instanceVariableNames: 'path'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonSchemaReference commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonSchemaReference methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:24'!
asJson
	^path
! !

!JsonSchemaReference methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isLocal
	^path beginsWith: '#'
! !

!JsonSchemaReference methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isSchemaReference
	^true
! !

!JsonSchemaReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
parent: aJsonSchema
	"
	do nothing
	"
	! !

!JsonSchemaReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
path
	^path
! !

!JsonSchemaReference methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
path: aString
	path := aString
! !

!JsonSchemaReference methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	path printOn: aStream
! !

!JsonSchemaReference methodsFor:  'resolving' stamp: 'KenD 28/Jun/2026 13:32:24'!
resolveIn: aJsonSchema
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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonSchemaReference class' category: #JSON!
JsonSchemaReference class
	instanceVariableNames: ''!

!JsonSchemaReference class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
path: aString
	^self new path: aString
! !


