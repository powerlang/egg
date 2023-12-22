"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ClassSpec, 
	#superclass : #SpeciesSpec, 
	#instVars : [
		'name', 
		'supername', 
		'classVariables', 
		'sharedPools', 
		'metaclass', 
		'variable', 
		'pointers'
	], 
	#category : #CodeSpecs
}

{#category : #inquiries}
ClassSpec >> allMethods [
	^methods & metaclass methods]

{#category : #enumerating}
ClassSpec >> allSuperclassesDo: aBlock [
	| s |
	supername isNil ifTrue: [^self].
	s := self superclass.
	s isNil ifTrue: [^self].
	aBlock value: s.
	s allSuperclassesDo: aBlock]

{#category : #accessing}
ClassSpec >> classVariables [
	^classVariables]

{#category : #inquiries}
ClassSpec >> classVarNames [
	^classVariables keys]

{#category : #accessing}
ClassSpec >> configureCompiler: aCompiler [
	]

{#category : #accessing}
ClassSpec >> cvarNames: aCollection [
	aCollection do: [:cvar | classVariables at: cvar put: nil]]

{#category : #accessing}
ClassSpec >> cvars: aCollection [
	classVariables := aCollection]

{#category : #testing}
ClassSpec >> hasMethods [
	^super hasMethods or: [metaclass hasMethods]]

{#category : #initialization}
ClassSpec >> initialize [
	super initialize.
	classVariables := OrderedDictionary new.
	sharedPools := OrderedCollection new]

{#category : #accessing}
ClassSpec >> instanceClass [
	^self]

{#category : #accessing}
ClassSpec >> isPointers [
	^pointers]

{#category : #accessing}
ClassSpec >> isPointers: aBoolean [
	pointers := aBoolean]

{#category : #accessing}
ClassSpec >> isVariable [
	^variable]

{#category : #accessing}
ClassSpec >> isVariable: aBoolean [
	variable := aBoolean]

{#category : #inquiries}
ClassSpec >> localPools [
	^classVariables select: [:c | c isKindOf: PoolDictionary]]

{#category : #accessing}
ClassSpec >> metaclass [
	^metaclass]

{#category : #accessing}
ClassSpec >> metaclass: aMetaclassSpec [
	metaclass := aMetaclassSpec]

{#category : #inquiries}
ClassSpec >> metaMethods [
	^metaclass methods]

{#category : #accessing}
ClassSpec >> name [
	^name]

{#category : #accessing}
ClassSpec >> name: aString [
	name := aString]

{#category : #accessing}
ClassSpec >> sharedPools [
	^sharedPools]

{#category : #accessing}
ClassSpec >> sharedPools: aCollection [
	sharedPools addAll: aCollection]

{#category : #accessing}
ClassSpec >> superclass [
	supername ifNil: [^nil].
	^module resolveClass: supername]

{#category : #accessing}
ClassSpec >> supername [
	^supername]

{#category : #accessing}
ClassSpec >> supername: aString [
	supername := aString]

