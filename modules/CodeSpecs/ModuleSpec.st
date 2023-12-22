"
	Copyright (c) 2021 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #ModuleSpec, 
	#superclass : #Object, 
	#instVars : [
		'name', 
		'description', 
		'classes', 
		'extendedClasses', 
		'subclassifiedClasses', 
		'imports', 
		'dependencies'
	], 
	#category : #CodeSpecs
}

{#category : #'instance creation'}
ModuleSpec class >> new [
	^super new initialize]

{#category : #'adding / removing'}
ModuleSpec >> addClass: aClassSpec [
	classes add: aClassSpec]

{#category : #'adding / removing'}
ModuleSpec >> addClasses: aCollection [
	aCollection do: [:c | self addClass: c]]

{#category : #'adding / removing'}
ModuleSpec >> addClassExtension: aClassSpec [
	extendedClasses add: aClassSpec]

{#category : #'adding / removing'}
ModuleSpec >> addDependencies: aCollection [
	aCollection keysAndValuesDo: [:dep :objects | 
		dependencies
			at: dep
			put: objects
			ifPresent: [:current | (current addAll: objects) withoutDuplicates]]]

{#category : #initialization}
ModuleSpec >> addImport: anAssociation [
	imports add: anAssociation]

{#category : #initialization}
ModuleSpec >> addImports: aCollection [
	aCollection do: [:token | self addImport: token asSymbol -> nil]]

{#category : #'adding / removing'}
ModuleSpec >> addSubclassifiedClass: aClassSpec [
	subclassifiedClasses addIfAbsent: aClassSpec]

{#category : #inquiries}
ModuleSpec >> allClasses [
	^classes , extendedClasses]

{#category : #enumerating}
ModuleSpec >> allClassesDo: aBlock [
	classes do: aBlock.
	extendedClasses do: aBlock]

{#category : #enumerating}
ModuleSpec >> allMethods [
	| methods |
	methods := OrderedCollection new.
	self allMethodsDo: [:m | methods add: m].
	^methods]

{#category : #enumerating}
ModuleSpec >> allMethodsDo: aBlock [
	self allClassesDo: [:c | 
		c metaclass methods do: aBlock.
		c methods do: aBlock]]

{#category : #'adding / removing'}
ModuleSpec >> associationAt: aSymbol ifAbsent: aBlock [
	^imports associationAt: aSymbol ifAbsent: aBlock]

{#category : #accessing}
ModuleSpec >> at: aSymbol [
	^self at: aSymbol ifAbsent: nil]

{#category : #accessing}
ModuleSpec >> at: aSymbol ifAbsent: aBlock [
	| string |
	string := aSymbol asString.
	classes do: [:c | c name = string ifTrue: [^c]].
	extendedClasses do: [:c | c name = string ifTrue: [^c]].
	subclassifiedClasses do: [:c | c name = string ifTrue: [^c]].
	^imports at: aSymbol ifAbsent: aBlock]

{#category : #resolving}
ModuleSpec >> basicResolveClass: aString [
	classes do: [:c | c name asString = aString ifTrue: [^c]].
	extendedClasses do: [:c | c name asString = aString ifTrue: [^c]].
	subclassifiedClasses do: [:c | c name asString = aString ifTrue: [^c]].
	^nil]

{#category : #accessing}
ModuleSpec >> classes [
	^classes]

{#category : #'adding / removing'}
ModuleSpec >> cleanDependencies [
	| needed |
	needed := OrderedCollection new.
	self methodReferences keys do: [:identifier | needed add: identifier name].
	self hierarchyReferences keys
		do: [:identifier | needed add: identifier name].
	extendedClasses do: [:c | needed add: c name].
	dependencies copy keysAndValuesDo: [:module :identifiers | 
		(identifiers keys anySatisfy: [:identifier | needed includes: identifier])
			ifFalse: [dependencies removeKey: module]]]

{#category : #testing}
ModuleSpec >> definesClassNamed: aString [
	^classes anySatisfy: [:c | c name = aString]]

{#category : #resolving}
ModuleSpec >> definesGlobal: aString [
	^classes anySatisfy: [:c | c name = aString]]

{#category : #accessing}
ModuleSpec >> dependencies [
	^dependencies]

{#category : #accessing}
ModuleSpec >> dependencies: aDictionary [
	dependencies := aDictionary]

{#category : #accessing}
ModuleSpec >> description [
	^description]

{#category : #accessing}
ModuleSpec >> description: aString [
	description := aString]

{#category : #accessing}
ModuleSpec >> extendedClasses [
	^extendedClasses]

{#category : #testing}
ModuleSpec >> extendsClassNamed: aString [
	^extendedClasses anySatisfy: [:c | c name = aString]]

{#category : #'adding / removing'}
ModuleSpec >> hierarchyReferences [
	| references |
	references := Dictionary new.
	self allClassesDo: [:c | | list |
		c superclass ifNotNil: [
			list := references at: c superclass ifAbsentPut: [OrderedCollection new].
			list add: c]].
	^references]

{#category : #testing}
ModuleSpec >> includesClass: aClassSpec [
	^(self resolveClass: aClassSpec) notNil]

{#category : #initialization}
ModuleSpec >> initialize [
	classes := OrderedCollection new.
	extendedClasses := OrderedCollection new.
	subclassifiedClasses := OrderedCollection new.
	imports := Dictionary new.
	dependencies := Dictionary new]

{#category : #'adding / removing'}
ModuleSpec >> methodReferences [
	| references |
	references := Dictionary new.
	self allMethodsDo: [:m | 
		m referencedIdentifiers reject: #isLocal thenDo: [:identifier | | list |
			list := references at: identifier ifAbsentPut: [OrderedCollection new].
			list add: m]].
	^references]

{#category : #accessing}
ModuleSpec >> name [
	^name]

{#category : #accessing}
ModuleSpec >> name: aString [
	name := aString]

{#category : #'adding / removing'}
ModuleSpec >> printOn: aStream [
	aStream
		nextPut: $<;
		print: name;
		nextPutAll: '> module']

{#category : #accessing}
ModuleSpec >> referencedGlobals [
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
	^referenced]

{#category : #'adding / removing'}
ModuleSpec >> removeCategory: aSymbol inClass: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	class removeCategory: aSymbol]

{#category : #'adding / removing'}
ModuleSpec >> removeClass: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	classes remove: class ifAbsent: nil]

{#category : #'adding / removing'}
ModuleSpec >> removeEmptyExtensions [
	extendedClasses copy
		reject: #hasMethods
		thenDo: [:c | extendedClasses remove: c]]

{#category : #'adding / removing'}
ModuleSpec >> removeExtendedClass: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	extendedClasses remove: class ifAbsent: nil]

{#category : #'adding / removing'}
ModuleSpec >> removeMethod: aMethodSpec [
	self ASSERT: (self includesClass: aMethodSpec classBinding).
	aMethodSpec classBinding removeMethod: aMethodSpec]

{#category : #'adding / removing'}
ModuleSpec >> removeSelectors: aCollection [
	self allClassesDo: [:c | 
		c removeSelectors: aCollection.
		c metaclass removeSelectors: aCollection]]

{#category : #'adding / removing'}
ModuleSpec >> removeSelectors: aCollection inClass: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	class removeSelectors: aCollection]

{#category : #'adding / removing'}
ModuleSpec >> removeSelectors: aCollection inScope: aClassSpec [
	| class all |
	class := self resolveClass: aClassSpec.
	all := self withAllSubclasses: class.
	all do: [:c | c removeSelectors: aCollection]]

{#category : #'adding / removing'}
ModuleSpec >> removeSubclassesOf: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	class allSubclasses do: [:c | self removeClass: c; removeExtendedClass: c]]

{#category : #'adding / removing'}
ModuleSpec >> removeSubclassifiedClass: aClassSpec [
	| class |
	class := self resolveClass: aClassSpec.
	subclassifiedClasses remove: class ifAbsent: nil]

{#category : #accessing}
ModuleSpec >> requiredImports [
	| required |
	required := Dictionary new.
	self referencedGlobals
		keysAndValuesDo: [:global :dependents | (self definesGlobal: global)
			ifFalse: [required at: global put: dependents]].
	^required]

{#category : #resolving}
ModuleSpec >> resolveClass: class [
	| moniker metaclass found |
	moniker := class isString ifTrue: [class] ifFalse: [class name].
	metaclass := moniker endsWith: ' class'.
	metaclass ifTrue: [moniker := moniker trimTail: ' class'].
	found := self basicResolveClass: moniker.
	^found ifNotNil: [metaclass ifTrue: [found metaclass] ifFalse: [found]]]

{#category : #private}
ModuleSpec >> sortedClasses [
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
	^sorted]

{#category : #testing}
ModuleSpec >> subclassifiesClassNamed: aString [
	^subclassifiedClasses anySatisfy: [:c | c name = aString]]

{#category : #services}
ModuleSpec >> withAllSubclasses: aClassSpec [
	| all |
	all := self allClasses.
	aClassSpec isMetaclass ifTrue: [all := all collect: #metaclass].
	^all select: [:c | c withAllSuperclasses includes: aClassSpec]]

