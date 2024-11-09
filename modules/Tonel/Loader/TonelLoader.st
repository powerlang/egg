"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #TonelLoader, 
	#superclass : #Object, 
	#instVars : [
		'moduleDir',
	], 
	#category : #Tonel
}

{#category : #private}
TonelLoader >> findModulePath: moduleName [
	| parts path candidates dir |
	parts := '.' split: moduleName.
	path := ('/' join: parts) asFilename.
	candidates := moduleDir allDirectoriesMatching: parts first.
	candidates do: [:match | 
		dir := match parent / path asString.
		dir exists ifTrue: [ ^moduleDir / dir ]].
	self error: 'module ' , moduleName , ' couldn''t be found'
]

{#category : #private}
TonelLoader >> classesSortedBySuperclass: anArray [
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
TonelLoader >> createNewClassFrom: spec in: module [
	| supername superclass metaclass class |
	supername := spec supername.
	superclass := module 
					ifNil: [ (Kernel namespace at: supername)  ]
					ifNotNil: [ module namespace at: supername ].
	class := Class newSubclassOf: superclass.
	metaclass := class class.
	class name: spec name.
	class instVarNames: spec instVarNames.
	class classVariables: (self createNamespaceWith: spec classVars).
	behaviors
		at: spec put: class instanceBehavior;
		at: spec metaclass put: metaclass instanceBehavior.
	spec methods do: [ :m | self createNewMethod: m in: class ].
	spec metaclass methods do: [ :m | self createNewMethod: m in: metaclass ].
	module ifNotNil: [
		module addClass: class.
		class module: module].
	^ class
]

{#category : #creating}
TonelLoader >> createExtensionMethodsOf: spec in: module [
	| name namespace class metaclass |
	name := spec name.
	namespace := module namespace. 
	class := namespace at: name.
	metaclass := class behavior classBinding.
	spec methods do: [ :m | | cm |
		 cm := self createNewMethod: m in: class.
		module ifNotNil: [ module addExtension: cm ] ].
	spec metaclass methods do: [ :m | | cm | 
		cm := self createNewMethod: m in: metaclass.
		module ifNotNil: [ module addExtension: cm ] ].
	^ module
]

{#category : #creating}
TonelLoader >> createNewMethod: m in: species [
	| method selector |
	method := SCompiler new compile: m sourceCode.
	selector := method selector.
	method classBinding: species.
	species methodDictionary at: selector put: smethod.
	species organization classify: selector under: category.
	^ method
]

{#category : #creating}
TonelLoader >> createNewModule: spec class: class [
	| module |
	module := class new.
	module bindKernelExports; importRequiredModules.
	spec name != #Module ifTrue: [ class module: module. module addClass: class].
	^ module
]

{#category : #loading}
TonelLoader >> loadModule: symbol [
	| spec classes moduleName moduleSpec moduleClass module |
	spec := self readModuleSpec: symbol.
	classes := self classesSortedBySuperclass: spec classes.
	moduleName := ('.' split: symbol) last asSymbol.
	moduleSpec := spec at: moduleName , #Module.
	moduleSpec ifNil: [ moduleSpec := spec at: #Module , moduleName ].
	moduleSpec
		ifNil: [
			moduleClass := Module.
			moduleSpec := Module spec ]
		ifNotNil: [ 
			moduleClass := self createNewClassFrom: moduleSpec in: nil.
			classes remove: moduleSpec ].
	module := self createNewModule: moduleSpec class: moduleClass.
	module name isEmpty ifTrue: [ module name: symbol asString ].
	classes do: [ :classSpec | self createNewClassFrom: classSpec in: module ].
	spec extendedClasses do: [ :classSpec | self createExtensionMethodsOf: classSpec in: module ].
	module justLoaded.
	^ module
]

{#category : #reading}
TonelLoader >> readModuleSpec: aSymbol [
	| path |
	path := self findModulePath: aSymbol.
	^path ifNotNil: [self readSpec: aSymbol at: path parent]
]

{#category : #reading}
TonelLoader >> readSpec: specName at: path [
	| dir subdir |
	dir := self module path.
	subdir := path isString ifTrue: [ path ] ifFalse: [ path asString ].
	subdir notEmpty ifTrue: [ dir := dir  / subdir].
		
	^self readSpec: ('.' split: specName) last atDir: dir
]

{#category : #reading}
TonelLoader >> readSpec: specName atDir: dir [
	| definitions module classDefs methodDefs class |
	definitions := (TonelReader on: dir fileName: specName) loadDefinitions; definitions.

	module := ModuleSpec new name: specName.
	classDefs := definitions select: #isClassDefinition.
	methodDefs := definitions select: #isMethodDefinition.
	classDefs do: [ :cdef | module addClassFromDefinition: cdef].
	methodDefs do: [ :mdef |
		class := module ensureClassNamed: mdef className.
		class addMethodFromDefinition: mdef in: module ].
	^ module
]