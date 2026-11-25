'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ModuleSpec category: #CodeSpecs!
Object subclass: #ModuleSpec
	instanceVariableNames: 'name description classes extendedClasses subclassifiedClasses imports dependencies'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodeSpecs'!
!ModuleSpec commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addClass: aClassSpec
	classes add: aClassSpec
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addClasses: aCollection
	aCollection do: [:c | self addClass: c]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addClassExtension: aClassSpec
	extendedClasses add: aClassSpec
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addDependencies: aCollection
	aCollection keysAndValuesDo: [:dep :objects | 
		dependencies
			at: dep
			put: objects
			ifPresent: [:current | (current addAll: objects) withoutDuplicates]]
! !

!ModuleSpec methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
addImport: anAssociation
	imports add: anAssociation
! !

!ModuleSpec methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
addImports: aCollection
	aCollection do: [:token | self addImport: token asSymbol -> nil]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addSubclassifiedClass: aClassSpec
	subclassifiedClasses addIfAbsent: aClassSpec
! !

!ModuleSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
allClasses
	^classes , extendedClasses
! !

!ModuleSpec methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
allClassesDo: aBlock
	classes do: aBlock.
	extendedClasses do: aBlock
! !

!ModuleSpec methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
allMethods
	| methods |
	methods := OrderedCollection new.
	self allMethodsDo: [:m | methods add: m].
	^methods
! !

!ModuleSpec methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
allMethodsDo: aBlock
	self allClassesDo: [:c | 
		c metaclass methods do: aBlock.
		c methods do: aBlock]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
associationAt: aSymbol ifAbsent: aBlock
	^imports associationAt: aSymbol ifAbsent: aBlock
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: aSymbol
	^self at: aSymbol ifAbsent: nil
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: aSymbol ifAbsent: aBlock
	| string |
	string := aSymbol asString.
	classes do: [:c | c name = string ifTrue: [^c]].
	extendedClasses do: [:c | c name = string ifTrue: [^c]].
	subclassifiedClasses do: [:c | c name = string ifTrue: [^c]].
	^imports at: aSymbol ifAbsent: aBlock
! !

!ModuleSpec methodsFor:  'resolving' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicResolveClass: aString
	classes do: [:c | c name asString = aString ifTrue: [^c]].
	extendedClasses do: [:c | c name asString = aString ifTrue: [^c]].
	subclassifiedClasses do: [:c | c name asString = aString ifTrue: [^c]].
	^nil
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
classes
	^classes
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
cleanDependencies
	| needed |
	needed := OrderedCollection new.
	self methodReferences keys do: [:identifier | needed add: identifier name].
	self hierarchyReferences keys
		do: [:identifier | needed add: identifier name].
	extendedClasses do: [:c | needed add: c name].
	dependencies copy keysAndValuesDo: [:module :identifiers | 
		(identifiers keys anySatisfy: [:identifier | needed includes: identifier])
			ifFalse: [dependencies removeKey: module]]
! !

!ModuleSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
definesClassNamed: aString
	^classes anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor:  'resolving' stamp: 'KenD 28/Jun/2026 13:27:39'!
definesGlobal: aString
	^classes anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
dependencies
	^dependencies
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
dependencies: aDictionary
	dependencies := aDictionary
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
description
	^description
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
description: aString
	description := aString
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
extendedClasses
	^extendedClasses
! !

!ModuleSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
extendsClassNamed: aString
	^extendedClasses anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hierarchyReferences
	| references |
	references := Dictionary new.
	self allClassesDo: [:c | | list |
		c superclass ifNotNil: [
			list := references at: c superclass ifAbsentPut: [OrderedCollection new].
			list add: c]].
	^references
! !

!ModuleSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
includesClass: aClassSpec
	^(self resolveClass: aClassSpec) notNil
! !

!ModuleSpec methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	classes := OrderedCollection new.
	extendedClasses := OrderedCollection new.
	subclassifiedClasses := OrderedCollection new.
	imports := Dictionary new.
	dependencies := Dictionary new
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
methodReferences
	| references |
	references := Dictionary new.
	self allMethodsDo: [:m | 
		m referencedIdentifiers reject: #isLocal thenDo: [:identifier | | list |
			list := references at: identifier ifAbsentPut: [OrderedCollection new].
			list add: m]].
	^references
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aString
	name := aString
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPut: $<;
		print: name;
		nextPutAll: '> module'
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
referencedGlobals
	| referenced |
	referenced := Dictionary new.
	self allMethodsDo: [:m | 
		m referencedIdentifiers
			select: [:identifier | | b |
				b := identifier binding.
				b refersToGlobal or: [b isUnresolved]]
			thenDo: [:global | (referenced
				at: global name
				ifAbsentPut: [OrderedCollection new])
				add: m]].
	^referenced
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeCategory: aSymbol inClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	class removeCategory: aSymbol
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	classes remove: class ifAbsent: nil
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeEmptyExtensions
	extendedClasses copy
		reject: #hasMethods
		thenDo: [:c | extendedClasses remove: c]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeExtendedClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	extendedClasses remove: class ifAbsent: nil
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeMethod: aMethodSpec
	self ASSERT: (self includesClass: aMethodSpec classBinding).
	aMethodSpec classBinding removeMethod: aMethodSpec
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSelectors: aCollection
	self allClassesDo: [:c | 
		c removeSelectors: aCollection.
		c metaclass removeSelectors: aCollection]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSelectors: aCollection inClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	class removeSelectors: aCollection
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSelectors: aCollection inScope: aClassSpec
	| class all |
	class := self resolveClass: aClassSpec.
	all := self withAllSubclasses: class.
	all do: [:c | c removeSelectors: aCollection]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSubclassesOf: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	class allSubclasses do: [:c | self removeClass: c; removeExtendedClass: c]
! !

!ModuleSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSubclassifiedClass: aClassSpec
	| class |
	class := self resolveClass: aClassSpec.
	subclassifiedClasses remove: class ifAbsent: nil
! !

!ModuleSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
requiredImports
	| required |
	required := Dictionary new.
	self referencedGlobals
		keysAndValuesDo: [:global :dependents | (self definesGlobal: global)
			ifFalse: [required at: global put: dependents]].
	^required
! !

!ModuleSpec methodsFor:  'resolving' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolveClass: class
	| moniker metaclass found |
	moniker := class isString ifTrue: [class] ifFalse: [class name].
	metaclass := moniker endsWith: ' class'.
	metaclass ifTrue: [moniker := moniker trimTail: ' class'].
	found := self basicResolveClass: moniker.
	^found ifNotNil: [metaclass ifTrue: [found metaclass] ifFalse: [found]]
! !

!ModuleSpec methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
sortedClasses
	| remaining sorted |
	remaining := classes copy.
	sorted := OrderedCollection new.
	[remaining isEmpty] whileFalse: [| c |
		c := remaining first.
		(remaining includes: c superclass)
			ifTrue: [remaining removeFirst; add: c]
			ifFalse: [
				remaining remove: c.
				sorted add: c]].
	^sorted
! !

!ModuleSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
subclassifiesClassNamed: aString
	^subclassifiedClasses anySatisfy: [:c | c name = aString]
! !

!ModuleSpec methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
withAllSubclasses: aClassSpec
	| all |
	all := self allClasses.
	aClassSpec isMetaclass ifTrue: [all := all collect: #metaclass].
	^all select: [:c | c withAllSuperclasses includes: aClassSpec]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ModuleSpec class' category: #CodeSpecs!
ModuleSpec class
	instanceVariableNames: ''!


ModuleSpec initialize!

