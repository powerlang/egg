'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ClassSpec category: #CodeSpecs!
SpeciesSpec subclass: #ClassSpec
	instanceVariableNames: 'name supername classVariables sharedPools metaclass variable pointers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodeSpecs'!
!ClassSpec commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ClassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
allMethods
	^methods & metaclass methods
! !

!ClassSpec methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSuperclassesDo: aBlock
	| s |
	supername isNil ifTrue: [^self].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
classVariables
	^classVariables
! !

!ClassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
classVarNames
	^classVariables keys
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
configureCompiler: aCompiler
	
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cvarNames: aCollection
	aCollection do: [:cvar | classVariables at: cvar put: nil]
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cvars: aCollection
	classVariables := aCollection
! !

!ClassSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasMethods
	^super hasMethods or: [metaclass hasMethods]
! !

!ClassSpec methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	classVariables := OrderedDictionary new.
	sharedPools := OrderedCollection new
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instanceClass
	^self
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPointers
	^pointers
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPointers: aBoolean
	pointers := aBoolean
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isVariable
	^variable
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isVariable: aBoolean
	variable := aBoolean
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
metaclass
	^metaclass
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
metaclass: aMetaclassSpec
	metaclass := aMetaclassSpec
! !

!ClassSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
metaMethods
	^metaclass methods
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aString
	name := aString
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
sharedPools
	^sharedPools
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
sharedPools: aCollection
	sharedPools addAll: aCollection
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
superclass
	supername ifNil: [^nil].
	^module resolveClass: supername
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
supername
	^supername
! !

!ClassSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
supername: aString
	supername := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ClassSpec class' category: #CodeSpecs!
ClassSpec class
	instanceVariableNames: ''!


ClassSpec initialize!

