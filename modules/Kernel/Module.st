"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Module,
	#superclass : #Object,
	#instVars : [
		'name',
		'version',
		'exports',
		'namespace',
		'hash',
		'cachedLookups',
		'classes',
		'extensions',
		'overriden',
		'requires'
	],
	#category : #Kernel
}

{ #category : #services }
Module class >> new [
	^self basicNew basicInitialize
]

{ #category : #'snapshotting' }
Module >> prepareForSnapshot: aBuilder [
	aBuilder
		importNilToken;
		addBoundary: Symbol symbolTable as: SymbolicReference symbolTable;
		map: overriden to: Dictionary new
]

{ #category : #'snapshotting' }
Module >> writeCachedSegmentAt: filename [
	(Kernel loadedModules includesKey: #'ImageSegmentBuilder.Native')
		ifTrue: [^self].
	[Kernel load: #'ImageSegmentBuilder.Native'] on: Error do: [:e | ^self].
	^self writeCachedSegmentAt: filename
]

{ #category : #services }
Module >> addClass: aClass [
	classes add: aClass.
	self exportClass: aClass
]

{ #category : #services }
Module >> addExtension: aCompiledMethod [
	| collection extension |
	collection := extensions at: aCompiledMethod classBinding symbol ifAbsentPut: [OrderedCollection new].
	extension := aCompiledMethod asExtensionFor: self.
	collection add: extension
]

{ #category : #services }
Module >> addOverride: aCompiledMethod [
	overriden at: aCompiledMethod signature put: aCompiledMethod
]

{ #category : #initialization }
Module >> basicInitialize [
	name := self defaultName.
	namespace ifNil: [namespace := Namespace new].
	exports := Set new.
	cachedLookups := Dictionary new.
	classes := OrderedCollection new.
	extensions := Dictionary new.
	overriden := Dictionary new.
	requires := #()
]

{ #category : #services }
Module >> bind [
	classes
		reject: [:c | classes includes: c superclass]
		thenDo: [:c | c superclass addSubclass: c].
	self extensionsDo: [:target :m | | current |
		current := target compiledMethodAt: m selector.
		target addSelector: m selector withMethod: m.
		current notNil ifTrue: [current module addOverride: current]]
]

{ #category : #services }
Module >> bind: anObject as: aSymbol [
	namespace at: aSymbol put: anObject.
	self justDefined: aSymbol
]

{ #category : #private }
Module >> bindAll: aDictionary [
	aDictionary keysAndValuesDo: [:symbol :value |
		namespace at: symbol put: value.
		self justDefined: symbol].
]

{ #category : #services }
Module >> bindKernelExports [
	| bindings |
	bindings := Dictionary new.
	{
		Object. Class. Metaclass. CompiledMethod.
		Array. OrderedCollection. Set. Dictionary.
		SmallInteger. String. Character.
	} do: [:class |
			bindings at: class symbol put: class].
	bindings at: #Kernel put: Kernel.
	self bindAll: bindings
]

{ #category : #accessing }
Module >> name [
	^name
]

{ #category : #accessing }
Module >> name: aString [
	name := aString
]

{ #category : #accessing }
Module >> classes [
	^classes
]

{ #category : #inquiries }
Module >> classNamed: aString [
	^classes detect: [:cls | cls name = aString ] ifNone: nil
]

{ #category : #initialization }
Module >> defaultName [
	| classname |
	classname := self class name.
	(classname endsWith: 'Module') ifTrue: [^classname trimTail: 'Module'].
	(classname beginsWith: 'Module') ifTrue: [^classname trimPrefix: 'Module'].
	^classname
]

{ #category : #services }
Module >> exports [
	| result |
	result := Dictionary new.
	result at: '__module__' put: self.
	exports do: [:name | | value |
		value := namespace at: name.
		result at: name put: value].
	^result
]

{ #category : #services }
Module >> export: anObject as: aSymbol [
	namespace at: aSymbol put: anObject.
	exports add: aSymbol
]

{ #category : #services }
Module >> exportByReference: anObject as: aSymbol [
	| reference |
	self export: anObject as: aSymbol.
	reference := SymbolicReference forMvarNamed: aSymbol in: self name.
	Kernel register: anObject exportedBy: self as: reference
]

{ #category : #services }
Module >> exportClass: aClass [
	self export: aClass as: aClass name asSymbol
]

{ #category : #accessing }
Module >> extensions [
	^extensions
]

{ #category : #enumerating }
Module >> extensions: aCollection of: aString do: aBlock [
	| target |
	target := self extensionTarget: aString.
	aCollection do: [:m | aBlock value: target value: m]
]

{ #category : #enumerating }
Module >> extensionsDo: aBlock [
	extensions keysAndValuesDo: [:s :methods | self extensions: methods of: s do: aBlock]
]

{ #category : #private }
Module >> extensionTarget: aString [
	| meta key target |
	meta := aString endsWith: ' class'.
	key := meta ifTrue: [(aString trimTail: ' class') asSymbol] ifFalse: [aString].
	target := namespace at: key ifAbsent: [self _halt].
	^meta ifTrue: [target class] ifFalse: [target]
]

{ #category : #inquiries }
Module >> extensionClasses [
	^extensions keys
		collect: [:s | | key |
			key := (s endsWith: ' class') ifTrue: [(s trimTail: ' class') asSymbol] ifFalse: [s].
			namespace at: key ifAbsent: [Class new name: (s , '__Not_Found') asSymbol]]
]

{ #category : #testing }
Module >> isModule [
	^true
]

{ #category : #services }
Module >> import: moduleName [
	| module |
	namespace at: moduleName ifPresent: [:loaded | ^loaded].
	module := Kernel load: moduleName.
	self bind: module as: moduleName.
	^module
]

{ #category : #services }
Module >> require: aSymbol [
	| name module |
	name := (self name , '.' , aSymbol) asSymbol.
	module := Kernel load: name.
	self bind: module as: aSymbol.
	^module
]

{ #category : #services }
Module >> import: name from: moduleName [
	^self import: name from: moduleName as: name
]

{ #category : #services }
Module >> import: name from: moduleName as: newName [
	| module import |
	module := Kernel load: moduleName.
	import := module namespace at: name.
	self bind: import as: newName
]

{ #category : #services }
Module >> importDescriptor: descriptor [
	| moduleName token exportNames |
	moduleName := descriptor key.
	token := descriptor value.
	exportNames := token isArray ifTrue: [token] ifFalse: [{token}].
	exportNames do: [:name | self import: name from: moduleName]
]

{ #category : #services }
Module >> importRequiredModules [
	self requires do: [:name | self import: name].
	self imports do: [:descriptor | self importDescriptor: descriptor]
]

{ #category : #services }
Module >> imports [
	"
	Returns an array of import descriptors. A descriptor can be:
	 - A composite symbol (i.e #Core.Modules.Writer) (NOT IMPLEMENTED YET).
	 - An association of module name and exported name (i.e #Core.Modules.JSON -> #Writer)
	 - An association of module name, exported name and rename (i.e. #Core.Modules.JSON -> (#Writer -> #JSONWriter)) (NOT IMPLEMENTED YET)
	"
	^#()
]

{ #category : #private }
Module >> justDefined: aSymbol [
	| lookups |
	lookups := cachedLookups at: aSymbol ifAbsent: [^nil].
	lookups do: [:lookup | lookup flush]
]

{ #category : #accessing }
Module >> justLoaded [
	self bind
]

{ #category : #accessing }
Module >> namespace [
	^namespace
]

{ #category : #accessing }
Module >> originalMethodFor: aCompiledMethod [
	aCompiledMethod module == self ifTrue: [^aCompiledMethod].
	^overriden at: aCompiledMethod signature ifAbsent: nil
]

{ #category : #accessing }
Module >> overriden [
	^overriden
]

{ #category : #accessing }
Module >> requires [
	^requires
]

