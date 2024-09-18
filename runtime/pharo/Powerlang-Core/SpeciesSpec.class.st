"
Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'SpeciesSpec',
	#superclass : 'Object',
	#instVars : [
		'methods',
		'module',
		'instSize',
		'allIvars',
		'instVarNames'
	],
	#category : 'Powerlang-Core-CodeSpecs',
	#package : 'Powerlang-Core',
	#tag : 'CodeSpecs'
}

{ #category : 'instance creation' }
SpeciesSpec class >> new [
	^super new initialize
]

{ #category : 'adding / removing' }
SpeciesSpec >> addMethod: aMethodSpec [
	^methods add: aMethodSpec
]

{ #category : 'adding / removing' }
SpeciesSpec >> addMethods: aCollection [
	aCollection do: [:m | self addMethod: m]
]

{ #category : 'adding / removing' }
SpeciesSpec >> addReplacingMethod: aMethodSpec [
	| s index |
	s := aMethodSpec selector.
	index := methods indexOf: [ :m | m selector == s ] ifAbsent: [^methods add: aMethodSpec].
	methods at: index put: aMethodSpec
]

{ #category : 'inquiries' }
SpeciesSpec >> allInstVarNames [

	allIvars ifNotNil: [^allIvars]. 
	^allIvars := (self withAllSuperclasses reversed gather: [ :c | 
			               c instVarNames ]) asArray 
]

{ #category : 'inquiries' }
SpeciesSpec >> allSharedPools [
	| pools |
	pools := Set new.
	self withAllSuperclasses do: [:c | pools addAll: c sharedPools].
	^pools
]

{ #category : 'accessing' }
SpeciesSpec >> allSubclasses [
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all
]

{ #category : 'accessing' }
SpeciesSpec >> allSubclassesDo: aBlock [
	self subclasses do: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]
]

{ #category : 'inquiries' }
SpeciesSpec >> allSuperclasses [
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses
]

{ #category : 'testing' }
SpeciesSpec >> hasMethods [
	^methods notEmpty
]

{ #category : 'initialization' }
SpeciesSpec >> initialize [
	super initialize.
	methods := OrderedCollection new.
	instVarNames := #()

]

{ #category : 'accessing' }
SpeciesSpec >> instSize [

	^ instSize ifNil: [ 
		  instSize := self allInstVarNames size]
]

{ #category : 'accessing' }
SpeciesSpec >> instVarNames [

	^ instVarNames asArray
]

{ #category : 'accessing' }
SpeciesSpec >> instVarNames: aCollection [

	instVarNames := aCollection asOrderedCollection
]

{ #category : 'accessing' }
SpeciesSpec >> instanceClass [
	^self subclassResponsibility
]

{ #category : 'accessing' }
SpeciesSpec >> instanceSide [

	^ self instanceClass
]

{ #category : 'testing' }
SpeciesSpec >> isBytes [

	^ false
]

{ #category : 'testing' }
SpeciesSpec >> isExtension [
	^module extendedClasses includes: self instanceClass
]

{ #category : 'testing' }
SpeciesSpec >> isMetaclass [
	^false
]

{ #category : 'testing' }
SpeciesSpec >> isPointers [

	^ true
]

{ #category : 'testing' }
SpeciesSpec >> isVariable [

	^ false
]

{ #category : 'accessing' }
SpeciesSpec >> ivars: aCollection [
	self haltIf: (aCollection anySatisfy: [:each | each isString not]).
	instVarNames := aCollection asOrderedCollection
]

{ #category : 'initialization' }
SpeciesSpec >> methodNamed: aSymbol [

	^methods detect: [ :m | m selector = aSymbol ] ifNone: nil
]

{ #category : 'accessing' }
SpeciesSpec >> methods [
	^methods
]

{ #category : 'accessing' }
SpeciesSpec >> module: aModuleSpec [
	module := aModuleSpec
]

{ #category : 'printing' }
SpeciesSpec >> printOn: aStream [
	aStream nextPutAll: '<' , self name , '>'
]

{ #category : 'adding / removing' }
SpeciesSpec >> removeCategory: aSymbol [
	methods removeAllSuchThat: [:m | m category == aSymbol]
]

{ #category : 'adding / removing' }
SpeciesSpec >> removeMethod: aMethodSpec [
	methods remove: aMethodSpec ifAbsent: nil
]

{ #category : 'adding / removing' }
SpeciesSpec >> removeSelector: aSymbol [
	methods removeAllSuchThat: [:m | m selector == aSymbol]
]

{ #category : 'adding / removing' }
SpeciesSpec >> removeSelectors: aCollection [
	methods removeAllSuchThat: [:m | aCollection includes: m selector]
]

{ #category : 'accessing' }
SpeciesSpec >> selectors [
	^methods collect: #selector
]

{ #category : 'accessing' }
SpeciesSpec >> subclasses [
	^module allClasses select: [:c | c supername = self name]
]

{ #category : 'accessing' }
SpeciesSpec >> withAllSubclasses [
	^OrderedCollection with: self withAll: self allSubclasses
]

{ #category : 'inquiries' }
SpeciesSpec >> withAllSuperclasses [
	^OrderedCollection with: self withAll: self allSuperclasses
]
