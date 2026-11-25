'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Module category: #Kernel!
Object subclass: #Module
	instanceVariableNames: 'name version exports namespace hash cachedLookups classes extensions overriden requires'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Module commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Module methodsFor:  'snapshotting' stamp: 'KenD 28/Jun/2026 13:27:38'!
prepareForSnapshot: aBuilder
	aBuilder
		importNilToken;
		addBoundary: Symbol symbolTable as: SymbolicReference symbolTable;
		map: overriden to: Dictionary new
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
addClass: aClass
	classes add: aClass.
	self exportClass: aClass
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
addExtension: aCompiledMethod
	| collection | 
	collection := extensions at: aCompiledMethod classBinding symbol ifAbsentPut: [OrderedCollection new].
	collection add: aCompiledMethod.
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
addOverride: aCompiledMethod
	overriden at: aCompiledMethod signature put: aCompiledMethod
! !

!Module methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicInitialize
	name := self defaultName.
	namespace ifNil: [namespace := Namespace new].
	exports := Set new.
	cachedLookups := Dictionary new.
	classes := OrderedCollection new.
	extensions := Dictionary new.
	overriden := Dictionary new.
	requires := #()
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
bind
	classes
		reject: [:c | classes includes: c superclass]
		thenDo: [:c | c superclass addSubclass: c].
	extensions keysAndValuesDo: [:s :methods | | meta key target |
		meta := s endsWith: ' class'.
		key := meta ifTrue: [(s trimTail: ' class') asSymbol] ifFalse: [s].
		target := namespace at: key ifAbsent: [self _halt].
		meta ifTrue: [target := target class].
		methods do: [:m | | current extension |
			current := target compiledMethodAt: m selector.
			extension := m asExtensionFor: self.
			target addSelector: m selector withMethod: extension.
			current notNil ifTrue: [current module addOverride: current]]
	]
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
bind: anObject as: aSymbol
	namespace at: aSymbol put: anObject.
	self justDefined: aSymbol
! !

!Module methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
bindAll: aDictionary
	aDictionary keysAndValuesDo: [:symbol :value |
		namespace at: symbol put: value.
		self justDefined: symbol].
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
bindKernelExports
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
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^name
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name: aString
	name := aString
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classes
	^classes
! !

!Module methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
classNamed: aString
	^classes detect: [:cls | cls name = aString ] ifNone: nil
! !

!Module methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultName
	| classname |
	classname := self class name.
	(classname endsWith: 'Module') ifTrue: [^classname trimTail: 'Module'].
	(classname beginsWith: 'Module') ifTrue: [^classname trimPrefix: 'Module'].
	^classname
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
exports
	| result |
	result := Dictionary new.
	result at: '__module__' put: self.
	exports do: [:name | | value |
		value := namespace at: name.
		result at: name put: value].
	^result
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
export: anObject as: aSymbol
	namespace at: aSymbol put: anObject.
	exports add: aSymbol
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
exportClass: aClass
	self export: aClass as: aClass name asSymbol
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
extensions
	^extensions
! !

!Module methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
extensionClasses
	^extensions keys
		collect: [:s | | key |
			key := (s endsWith: ' class') ifTrue: [(s trimTail: ' class') asSymbol] ifFalse: [s].
			namespace at: key ifAbsent: [Class new name: (s , '__Not_Found') asSymbol]]
! !

!Module methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isModule
	^true
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
import: moduleName
	| module |
	namespace at: moduleName ifPresent: [:loaded | ^loaded].
	module := Kernel load: moduleName.
	self bind: module as: moduleName.
	^module
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
import: name from: moduleName
	^self import: name from: moduleName as: name
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
import: name from: moduleName as: newName
	| module import |
	module := Kernel load: moduleName.
	import := module namespace at: name.
	self bind: import as: newName
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
importDescriptor: descriptor
	| moduleName token exportNames |
	moduleName := descriptor key.
	token := descriptor value.
	exportNames := token isArray ifTrue: [token] ifFalse: [{token}].
	exportNames do: [:name | self import: name from: moduleName]
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
importRequiredModules
	requires do: [:name | self import: name].
	self imports do: [:descriptor | self importDescriptor: descriptor]
! !

!Module methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
imports
	"
	Returns an array of import descriptors. A descriptor can be:
	 - A composite symbol (i.e #Core.Modules.Writer) (NOT IMPLEMENTED YET).
	 - An association of module name and exported name (i.e #Core.Modules.JSON -> #Writer)
	 - An association of module name, exported name and rename (i.e. #Core.Modules.JSON -> (#Writer -> #JSONWriter)) (NOT IMPLEMENTED YET)
	"
	^#()
! !

!Module methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
justDefined: aSymbol
	| lookups |
	lookups := cachedLookups at: aSymbol ifAbsent: [^nil].
	lookups do: [:lookup | lookup flush]
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
justLoaded
	self bind
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
namespace
	^namespace
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
originalMethodFor: aCompiledMethod
	aCompiledMethod module == self ifTrue: [^aCompiledMethod].
	^overriden at: aCompiledMethod signature ifAbsent: nil
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
overriden
	^overriden
! !

!Module methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
requires
	^requires
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Module class' category: #Kernel!
Module class
	instanceVariableNames: ''!

!Module class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self basicNew basicInitialize
! !


