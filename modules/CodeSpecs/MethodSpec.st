"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #MethodSpec, 
	#superclass : #Object, 
	#instVars : [
		'selector', 
		'class', 
		'source', 
		'category', 
		'module', 
		'ast'
	], 
	#category : #CodeSpecs
}

{#category : #comparing}
MethodSpec >> = aMethodSpec [
	^aMethodSpec class = self class
		and: [aMethodSpec selector == selector]
		and: [aMethodSpec classBinding = class]]

{#category : #converting}
MethodSpec >> asCompiledMethod [
	self canBeCompiled ifFalse: [^nil].
	^self
		propertyAt: #compiledMethod
		ifAbsentPut: [self compiler compileMethod: source]]

{#category : #converting}
MethodSpec >> ast [
	self canBeCompiled ifFalse: [^nil].
	^ast ifNil: [ast := self compiler parseMethod: source]]

{#category : #inquiries}
MethodSpec >> bytecodes [
	^self canBeCompiled ifTrue: [self asCompiledMethod bytecodes]]

{#category : #testing}
MethodSpec >> canBeCompiled [
	^self compiler notNil]

{#category : #testing}
MethodSpec >> canBeParsed [
	^self cannonicalAst notNil]

{#category : #converting}
MethodSpec >> cannonicalAst [
	^self halt propertyAt: #cannonicalAst ifAbsentPut: [self ast]]

{#category : #accessing}
MethodSpec >> category [
	^self isExtension
		ifTrue: ['*' , (module name readStream upToLast: $-)]
		ifFalse: [category]]

{#category : #accessing}
MethodSpec >> category: aString [
	category := aString]

{#category : #accessing}
MethodSpec >> classBinding [
	^class]

{#category : #accessing}
MethodSpec >> classBinding: aSpeciesSpec [
	class := aSpeciesSpec]

{#category : #inquiries}
MethodSpec >> classname [
	^class name]

{#category : #testing}
MethodSpec >> equals: aMethodSpec [
	^self canBeCompiled
		and: [aMethodSpec canBeCompiled]
		and: [self isFrameless not]
		and: [self isEquivalentTo: aMethodSpec]]

{#category : #comparing}
MethodSpec >> hash [
	^class name hash hashWith: selector]

{#category : #testing}
MethodSpec >> isEquivalentTo: aMethodSpec [
	| m1 m2 |
	selector == aMethodSpec selector ifFalse: [^false].
	class == aMethodSpec classBinding ifFalse: [^false].
	m1 := self asCompiledMethod.
	m1 isNil ifTrue: [^false].
	m2 := aMethodSpec asCompiledMethod.
	m2 isNil ifTrue: [^false].
	^m1 equals: m2]

{#category : #testing}
MethodSpec >> isExtension [
	^class isExtension]

{#category : #testing}
MethodSpec >> isFrameless [
	^self halt asCompiledMethod isFrameless]

{#category : #accessing}
MethodSpec >> module [
	^module]

{#category : #accessing}
MethodSpec >> module: aModuleSpec [
	module := aModuleSpec]

{#category : #printing}
MethodSpec >> printOn: aStream [
	aStream nextPutAll: class name asString , '>>#' , selector asString]

{#category : #converting}
MethodSpec >> referencedIdentifiers [
	^self ast ifNil: [#()] ifNotNil: [:node | node identifiers]]

{#category : #testing}
MethodSpec >> referencesIdentifier: aString [
	^self referencedIdentifiers
		anySatisfy: [:identifier | identifier name = aString]]

{#category : #accessing}
MethodSpec >> removeFromClass [
	class removeMethod: self]

{#category : #services}
MethodSpec >> resolveClass [
	^module resolveClass: class name]

{#category : #accessing}
MethodSpec >> selector [
	^selector]

{#category : #accessing}
MethodSpec >> selector: aSymbol [
	selector := aSymbol]

{#category : #accessing}
MethodSpec >> source [
	^source]

{#category : #accessing}
MethodSpec >> source: aString [
	source := aString.
	ast := nil]

{#category : #accessing}
MethodSpec >> sourceCode [
	^source]

{#category : #testing}
MethodSpec >> usesInstanceVariableNamed: aString [
	^(self ast variableNamed: aString) notNil]

