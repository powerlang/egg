"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleLoader,
	#superclass : #Object,
	#instVars : [
		'module',
		'spec'
	],
	#category : #ModuleImporter
}

{#category : #loading}
ModuleLoader >> readModuleSpecNamed: aString [
	| reader |
	reader := ModuleSpecReader new.
	reader path: '../../modules/', aString.
	^reader read
]


{#category : #loading}
ModuleLoader >> loadModuleNamed: aString [
	| spec classes moduleName moduleSpec moduleClass module |
	spec := self readModuleSpecNamed: aString.
	classes := self classesSortedBySuperclass: spec classes.
	moduleName := ('.' split: aString) last asSymbol.
	moduleSpec := spec classes detect: [:cls | cls name = (moduleName , #Module)] ifNone: nil.
	moduleSpec ifNil: [ moduleSpec := spec classes detect: [:cls | cls name = (#Module , moduleName)] ifNone: nil].
	moduleSpec
		ifNil: [
			moduleClass := Module.]
		ifNotNil: [ 
			moduleClass := self createNewClassFrom: moduleSpec in: nil.
			classes remove: moduleSpec ].
	module := self createNewModule: moduleClass.
	module name isEmpty ifTrue: [ module name: symbol asString ].
	classes do: [:c | self createNewClassFrom: c in: module ].
	spec extendedClasses do: [:c | self createExtensionMethodsOf: c in: module ].
	module justLoaded.
	^ module
]

{#category : #private}
ModuleLoader >> classesSortedBySuperclass: anArray [
	| result seen s dfs |
	result := OrderedCollection new.
	seen := IdentitySet new.
	dfs := [ :class | 
	       s := class superclass.
	       ((anArray includes: s) andNot: [ seen includes: s ]) ifTrue: [ 
		       dfs value: s ].	
	       result add: class.
	       seen add: class ].
	anArray do: [ :class | (seen includes: class) ifFalse: [ dfs value: class ] ].
	self ASSERT: result asSet = anArray asSet.
	^ result
]

{#category : #creating}
ModuleLoader >> createNewClassFrom: aClassSpec in: module [
	| supername superclass metaclass class |
	supername := aClassSpec supername.
	superclass := module 
					ifNil: [ (Kernel namespace at: supername)  ]
					ifNotNil: [ module namespace at: supername ].
	class := Class newSubclassOf: superclass.
	metaclass := class class.
	class name: aClassSpec name; instVarNames: aClassSpec instVarNames; classVarNames: aClassSpec classVars.
	aClassSpec methods do: [ :m | self createNewMethod: m in: class ].
	aClassSpec metaclass methods do: [ :m | self createNewMethod: m in: metaclass ].
	module ifNotNil: [
		module addClass: class.
		class module: module].
	^ class
]

{#category : #creating}
ModuleLoader >> createNewMethod: aMethodSpec in: aSpecies [
	| method selector |
	method := SCompiler new compile: aMethodSpec sourceCode.
	selector := method selector.
	method classBinding: aSpecies.
	aSpecies methodDictionary at: selector put: smethod.
	aSpecies organization classify: selector under: category.
	^method
]

{#category : #creating}
ModuleLoader >> createNewModule: aClass [
	| module |
	module := aClass new.
	module bindKernelExports; importRequiredModules.
	aClass name != #Module ifTrue: [ aClass module: module. module addClass: aClass].
	^module
]