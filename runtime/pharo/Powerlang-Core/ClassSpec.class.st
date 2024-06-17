"
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #ClassSpec,
	#superclass : #SpeciesSpec,
	#instVars : [
		'name',
		'supername',
		'sharedPools',
		'metaclass',
		'variable',
		'pointers',
		'classVarNames'
	],
	#category : 'Powerlang-Core-CodeSpecs',
	#package : 'Powerlang-Core',
	#tag : 'CodeSpecs'
}

{ #category : #'adding / removing' }
ClassSpec >> addMethodFromDefinition: aMethodDefinition in: aModuleSpec [
	| method species |
	species := aMethodDefinition classIsMeta ifTrue: [self metaclass] ifFalse: [self].
	method := MethodSpec new
		module: aModuleSpec;
		selector: aMethodDefinition selector;
		classBinding: species;
		source: aMethodDefinition source;
		category: aMethodDefinition protocol.
	species addMethod: method

]

{ #category : #inquiries }
ClassSpec >> allClassVarNames [

	^ (self withAllSuperclasses reversed gather: [ :c | c classVarNames ])
		  asArray
]

{ #category : #accessing }
ClassSpec >> allInstVarNames [

	allIvars ifNotNil: [ ^ allIvars ].
	^ allIvars := (self withAllSuperclasses reversed gather: [ :c | 
		               c instVarNames ]) asArray
]

{ #category : #inquiries }
ClassSpec >> allMethods [
	^methods & metaclass methods
]

{ #category : #enumerating }
ClassSpec >> allSuperclassesDo: aBlock [
	| s |
	supername isNil ifTrue: [^self].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock
]

{ #category : #accessing }
ClassSpec >> beArrayed [
	variable := true
]

{ #category : #accessing }
ClassSpec >> beBytes [
	pointers := false
]

{ #category : #inquiries }
ClassSpec >> classVarNames [

	^ classVarNames
]

{ #category : #accessing }
ClassSpec >> configureCompiler: aCompiler [
	
]

{ #category : #accessing }
ClassSpec >> cvarNames: aCollection [
	aCollection do: [:cvar | classVarNames at: cvar put: nil]
]

{ #category : #accessing }
ClassSpec >> cvars: aCollection [
	classVarNames := aCollection
]

{ #category : #testing }
ClassSpec >> hasMethods [
	^super hasMethods or: [metaclass hasMethods]
]

{ #category : #initialization }
ClassSpec >> initialize [
	super initialize.
	classVarNames := OrderedDictionary new.
	sharedPools := OrderedCollection new.
	pointers := true.
	variable := false
]

{ #category : #accessing }
ClassSpec >> instanceClass [
	^self
]

{ #category : #accessing }
ClassSpec >> isBytes [

	^ pointers not
]

{ #category : #accessing }
ClassSpec >> isPointers [
	^pointers
]

{ #category : #accessing }
ClassSpec >> isPointers: aBoolean [
	pointers := aBoolean
]

{ #category : #accessing }
ClassSpec >> isVariable [
	^variable
]

{ #category : #accessing }
ClassSpec >> isVariable: aBoolean [
	variable := aBoolean
]

{ #category : #inquiries }
ClassSpec >> metaMethods [
	^metaclass methods
]

{ #category : #accessing }
ClassSpec >> metaclass [
	^metaclass
]

{ #category : #accessing }
ClassSpec >> metaclass: aMetaclassSpec [
	metaclass := aMetaclassSpec
]

{ #category : #accessing }
ClassSpec >> name [
	^name
]

{ #category : #accessing }
ClassSpec >> name: aString [
	name := aString
]

{ #category : #accessing }
ClassSpec >> sharedPools [
	^sharedPools
]

{ #category : #accessing }
ClassSpec >> sharedPools: aCollection [
	sharedPools addAll: aCollection
]

{ #category : #accessing }
ClassSpec >> superclass [
	supername ifNil: [^nil].
	^module resolveClass: supername
]

{ #category : #accessing }
ClassSpec >> supername [
	^supername
]

{ #category : #accessing }
ClassSpec >> supername: aString [
self haltIf: aString = #ByteSymbol.
	supername := aString
]
