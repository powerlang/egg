'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #MethodSpec category: #CodeSpecs!
Object subclass: #MethodSpec
	instanceVariableNames: 'selector class source category module ast'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodeSpecs'!
!MethodSpec commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!MethodSpec methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
= aMethodSpec
	^aMethodSpec class = self class
		and: [aMethodSpec selector == selector]
		and: [aMethodSpec classBinding = class]
! !

!MethodSpec methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asCompiledMethod
	self canBeCompiled ifFalse: [^nil].
	^self
		propertyAt: #compiledMethod
		ifAbsentPut: [self compiler compileMethod: source]
! !

!MethodSpec methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
ast
	self canBeCompiled ifFalse: [^nil].
	^ast ifNil: [ast := self compiler parseMethod: source]
! !

!MethodSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
bytecodes
	^self canBeCompiled ifTrue: [self asCompiledMethod bytecodes]
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
canBeCompiled
	^self compiler notNil
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
canBeParsed
	^self cannonicalAst notNil
! !

!MethodSpec methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
cannonicalAst
	^self halt propertyAt: #cannonicalAst ifAbsentPut: [self ast]
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
category
	^self isExtension
		ifTrue: ['*' , (module name readStream upToLast: $-)]
		ifFalse: [category]
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
category: aString
	category := aString
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
classBinding
	^class
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
classBinding: aSpeciesSpec
	class := aSpeciesSpec
! !

!MethodSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
classname
	^class name
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
equals: aMethodSpec
	^self canBeCompiled
		and: [aMethodSpec canBeCompiled]
		and: [self isFrameless not]
		and: [self isEquivalentTo: aMethodSpec]
! !

!MethodSpec methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hash
	^class name hash hashWith: selector
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEquivalentTo: aMethodSpec
	| m1 m2 |
	selector == aMethodSpec selector ifFalse: [^false].
	class == aMethodSpec classBinding ifFalse: [^false].
	m1 := self asCompiledMethod.
	m1 isNil ifTrue: [^false].
	m2 := aMethodSpec asCompiledMethod.
	m2 isNil ifTrue: [^false].
	^m1 equals: m2
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isExtension
	^class isExtension
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isFrameless
	^self halt asCompiledMethod isFrameless
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
module
	^module
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
module: aModuleSpec
	module := aModuleSpec
! !

!MethodSpec methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: class name asString , '>>#' , selector asString
! !

!MethodSpec methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
referencedIdentifiers
	^self ast ifNil: [#()] ifNotNil: [:node | node identifiers]
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
referencesIdentifier: aString
	^self referencedIdentifiers
		anySatisfy: [:identifier | identifier name = aString]
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeFromClass
	class removeMethod: self
! !

!MethodSpec methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolveClass
	^module resolveClass: class name
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector
	^selector
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector: aSymbol
	selector := aSymbol
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
source
	^source
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: aString
	source := aString.
	ast := nil
! !

!MethodSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
sourceCode
	^source
! !

!MethodSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesInstanceVariableNamed: aString
	^(self ast variableNamed: aString) notNil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MethodSpec class' category: #CodeSpecs!
MethodSpec class
	instanceVariableNames: ''!


