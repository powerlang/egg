"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #SpeciesSpec, 
	#superclass : #Object, 
	#instVars : [
		'instanceVariables', 
		'methods', 
		'module', 
		'format'
	], 
	#classVars : [
		'Format'
	], 
	#category : #CodeSpecs
}

{#category : #initialization}
SpeciesSpec class >> initializeFormatMasks [
	Format := PoolDictionary newConstantPool.
	Format
		at: 'IsArrayed' put: 0x1;
		at: 'IsBytes' put: 0x2]

{#category : #'instance creation'}
SpeciesSpec class >> new [
	^super new initialize]

{#category : #'adding / removing'}
SpeciesSpec >> addMethod: aMethodSpec [
	^methods add: aMethodSpec]

{#category : #'adding / removing'}
SpeciesSpec >> addMethods: aCollection [
	aCollection do: [:m | self addMethod: m]]

{#category : #inquiries}
SpeciesSpec >> allInstVarNames [
	^(self withAllSuperclasses reversed gather: [:c | c instVarNames]) asArray]

{#category : #inquiries}
SpeciesSpec >> allSharedPools [
	| pools |
	pools := Set new.
	self withAllSuperclasses do: [:c | pools addAll: c sharedPools].
	^pools]

{#category : #accessing}
SpeciesSpec >> allSubclasses [
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all]

{#category : #accessing}
SpeciesSpec >> allSubclassesDo: aBlock [
	self subclasses do: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]]

{#category : #inquiries}
SpeciesSpec >> allSuperclasses [
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses]

{#category : #accessing}
SpeciesSpec >> beArrayed [
	format := format | IsArrayed]

{#category : #accessing}
SpeciesSpec >> beBytes [
	format := format | IsBytes]

{#category : #testing}
SpeciesSpec >> hasMethods [
	^methods notEmpty]

{#category : #initialization}
SpeciesSpec >> initialize [
	super initialize.
	methods := OrderedCollection new.
	instanceVariables := #().
	format := 0]

{#category : #testing}
SpeciesSpec >> instancesAreArrayed [
	^format anyMask: IsArrayed]

{#category : #testing}
SpeciesSpec >> instancesHavePointers [
	^(format anyMask: IsBytes) not]

{#category : #accessing}
SpeciesSpec >> instVarNames [
	^instanceVariables]

{#category : #accessing}
SpeciesSpec >> instVarNames: aCollection [
	instanceVariables := aCollection asOrderedCollection]

{#category : #testing}
SpeciesSpec >> isExtension [
	^module extendedClasses includes: self instanceClass]

{#category : #testing}
SpeciesSpec >> isMetaclass [
	^false]

{#category : #accessing}
SpeciesSpec >> ivars: aCollection [
	instanceVariables := aCollection asOrderedCollection]

{#category : #accessing}
SpeciesSpec >> methods [
	^methods]

{#category : #accessing}
SpeciesSpec >> module: aModuleSpec [
	module := aModuleSpec]

{#category : #printing}
SpeciesSpec >> printOn: aStream [
	aStream nextPutAll: '<' , self name , '>']

{#category : #'adding / removing'}
SpeciesSpec >> removeCategory: aSymbol [
	methods removeAllSuchThat: [:m | m category == aSymbol]]

{#category : #'adding / removing'}
SpeciesSpec >> removeMethod: aMethodSpec [
	methods remove: aMethodSpec ifAbsent: nil]

{#category : #'adding / removing'}
SpeciesSpec >> removeSelector: aSymbol [
	methods removeAllSuchThat: [:m | m selector == aSymbol]]

{#category : #'adding / removing'}
SpeciesSpec >> removeSelectors: aCollection [
	methods removeAllSuchThat: [:m | aCollection includes: m selector]]

{#category : #accessing}
SpeciesSpec >> selectors [
	^methods collect: #selector]

{#category : #accessing}
SpeciesSpec >> subclasses [
	^module allClasses select: [:c | c supername = self name]]

{#category : #accessing}
SpeciesSpec >> withAllSubclasses [
	^OrderedCollection with: self withAll: self allSubclasses]

{#category : #inquiries}
SpeciesSpec >> withAllSuperclasses [
	^OrderedCollection with: self withAll: self allSuperclasses]

