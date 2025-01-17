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
	| classes moduleName moduleSpec moduleClass |
	spec := self readModuleSpecNamed: aString.
	classes := self classesSortedBySuperclass: spec classes.
	moduleName := ('.' split: spec name) last asSymbol.
	moduleSpec := spec classes detect: [:cls | cls name = (moduleName , #Module)] ifNone: nil.
	moduleSpec ifNil: [ moduleSpec := spec classes detect: [:cls | cls name = (#Module , moduleName)] ifNone: nil].
	moduleSpec
		ifNil: [
			moduleClass := Module.]
		ifNotNil: [ 
			moduleClass := self createNewClassFrom: moduleSpec in: nil.
			classes remove: moduleSpec ].
	module := self createNewModule: moduleClass.
	module name isEmpty ifTrue: [ module name: moduleName asString ].
	classes do: [:c | self createNewClassFrom: c in: module ].
	spec extendedClasses do: [:c | self createExtensionMethodsOf: c ].
	module justLoaded.
	Kernel loadedModules at: module name asSymbol put: module.
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
	| superclass metaclass class |
	superclass := (module ifNil: [ Kernel ]) namespace at: aClassSpec supername asSymbol.
	class := Class newSubclassOf: superclass.
	metaclass := class class.
	class name: aClassSpec name; instVarNames: aClassSpec instVarNames; classVarNames: aClassSpec classVarNames.
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
	aSpecies methodDictionary at: selector put: method.
	aSpecies organization classify: selector under: method category.
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

{#category : #creating}
ModuleLoader >> createExtensionMethodsOf: aClassSpec [
	| class metaclass |
	class := module namespace at: aClassSpec name asSymbol.
	metaclass := class behavior classBinding.
	aClassSpec methods do: [ :m | | cm |
		 cm := self createNewMethod: m in: class.
		module ifNotNil: [ module addExtension: cm ] ].
	aClassSpec metaclass methods do: [ :m | | cm | 
		cm := self createNewMethod: m in: metaclass.
		module ifNotNil: [ module addExtension: cm ] ].
	^ module
]