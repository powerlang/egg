"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Class,
	#superclass : #Species,
	#instVars : [
		'name',
		'subclasses',
		'namespaces',
		'module'
	],
	#category : #Kernel
}

Class class >> newSubclassOf: aClass [
	| meta |
	meta := Metaclass new beSubclassOf: aClass class.
	^meta instanceClass module: Kernel; initializeFrom: aClass.
]

{ #category : #lookup }
Class >> _lookupName: aSymbol [
	| current vars result |
	current := self.
	[ 
		vars := current classVariables.
		vars == nil ifFalse: [
			result := vars _namespaceLookup: aSymbol.
			result == nil ifFalse: [^result].
		].
		current := current superclass.
		current == nil] whileFalse.
	^module _namespaceLookup: aSymbol.
]

{ #category : #services }
Class >> addNamespace [
	^self addNamespace: Namespace new.
]

{ #category : #services }
Class >> addNamespace: aNamespace [
	"
		first namespace are class variables, remaining ones are local pools of the class
	"
	namespaces ifNil: [namespaces := Array with: Namespace new].
	namespaces := namespaces copyWith: aNamespace.
	^aNamespace
]

{ #category : #services }
Class >> addNamespaceAs: aSymbol [
	| names |
	names := self addNamespace.
	^self classVarNamed: aSymbol put: names
]

{ #category : #services }
Class >> beDeleted [
	| behavior md |
	self behavior: DeletedClass instanceBehavior.
	name := ('Deleted ' , self symbol) asSymbol.
	behavior := self instanceBehavior.
	md := MethodDictionary new.
	self withAllSuperclasses reverseDo: [:c | 
		c selectors do: [:s | | cm |
			cm := c >> s.
			cm notNil ifTrue: [md at: s put: cm]]].
	behavior methods: md; next: nil.
	instanceVariables := self allInstVarNames.
	superclass := ProtoObject
]

{ #category : #private }
Class >> beNamed: aSymbol in: aSmalltalkSystem [
	| symbol assoc |
	symbol := aSymbol asSymbol.
	assoc := aSmalltalkSystem associationClass key: symbol value: self.
	aSmalltalkSystem basicAdd: assoc.
	name := symbol
]

{ #category : #services }
Class >> beSubclassOf: aClass [
	self installer superclass: aClass; install
]

{ #category : #testing }
Class >> canBeDeleted [
	^self !== Class
]

{ #category : #accessing }
Class >> classVariables [
	^namespaces isEmpty ifTrue: [Namespace new] ifFalse: [namespaces first]
]

{ #category : #accessing }
Class >> classVariables: aNamespace [
	namespaces isEmpty
		ifTrue: [namespaces := Array with: aNamespace]
		ifFalse: [namespaces at: 1 put: aNamespace].
	(aNamespace isEmpty and: [namespaces size = 1])
		ifTrue: [namespaces := #()]
]

{ #category : #accessing }
Class >> classVarNamed: aString put: anObject [
	^namespaces first at: aString put: anObject
]

{ #category : #accessing }
Class >> classVarNames [
	^self classVariables keys
]


{ #category : #accessing }
Class >> classVarNames: aCollection [
	| new old |
	new := Namespace new.
	old := sef classVariables.
	
	aCollection do: [:k | | assoc |
		assoc := old associationAt: k ifAbsent: [k -> nil].
		new add: assoc].
	
	self classVariables: new.
]

{ #category : #accessing }
Class >> comment [
	^self organization isNil ifTrue: [''] ifFalse: [self organization comment]
]

{ #category : #accessing }
Class >> comment: aString [
	self organization comment: aString
]

{ #category : #removing }
Class >> delete [
	self canBeDeleted
		ifFalse: [self error: 'System Classes cannot be removed.'].
	Smalltalk removeClass: self
]

{ #category : #services }
Class >> duplicate [
	| copy meta md |
	copy := self objectShallowCopy buildBehavior.
	md := copy methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	meta := self class objectShallowCopy instanceClass: copy; buildBehavior.
	md := meta methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	copy behavior: meta instanceBehavior; subclasses: #().
	^copy
]

{ #category : #services }
Class >> duplicateHierarchy [
	| copy |
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: self with: copy.
		child basicBeSubclassOf: copy].
	^copy
]

{ #category : #services }
Class >> duplicateHierarchyFrom: aClass with: aClassCopy [
	| copy |
	self == aClass ifTrue: [^aClassCopy].
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: aClass with: aClassCopy.
		child basicBeSubclassOf: copy].
	^copy
]

{ #category : #accessing }
Class >> fillFrom: aClass [
	| pools |
	super fillFrom: aClass.
	self == aClass ifTrue: [^self].
	self classVariables: aClass classVariables.
	self class fillFrom: aClass class
]

{ #category : #testing }
Class >> hasSubclasses [
	^self subclasses size > 0
]

{ #category : #initialization }
Class >> initializeFrom: aSpecies [
	| md |
	superclass := aSpecies.
	namespaces := #().
	md := MethodDictionary new.
	instanceBehavior := Behavior with: md.
	instanceBehavior classBinding: self.
	format := Object format.
	superclass notNil ifTrue: [
		instanceBehavior next: superclass instanceBehavior.
		format := superclass format]
]

{ #category : #accessing }
Class >> instanceClass [
	^self
]

{ #category : #testing }
Class >> isClass [
	^true
]

{ #category : #testing }
Class >> isDeleted [
	^false
]

{ #category : #accessing }
Class >> module [
	^module
]

{ #category : #accessing }
Class >> module: aModule [
	module := aModule
]

{ #category : #accessing }
Class >> name [
	^name asString
]

{ #category : #accessing }
Class >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #services }
Class >> namespaces [
	^namespaces
]

{ #category : #testing }
Class >> needsReinstallation [
	self hasClassBehavior ifFalse: [^true].
	superclass isNil ifTrue: [^false].
	self instSize - self instVarNames size = superclass instSize
		ifFalse: [^true].
	self class instSize - self class instVarNames size
		= self class superclass instSize
		ifFalse: [^true].
	^self installer shouldRecomputeBehavior
]

{ #category : #accessing }
Class >> pointer: pointers variable: variable [
	| flags bits |
	flags := 0.
	variable ifTrue: [flags := flags | Variable].
	format := pointers
		ifTrue: [
			flags := flags | Pointers.
			flags | self instSize]
		ifFalse: [flags].
	variable ifTrue: [
		bits := Variable | Pointers.
		flags := flags & bits.
		self allSubclasses
			do: [:cls | cls format: cls format & bits bitInvert | flags]]
]

{ #category : #removing }
Class >> removeFromSystem [
	self allInstances notEmpty
		ifTrue: [^self error: 'There are instances of this class'].
	self delete
]

{ #category : #'add/remove' }
Class >> removeSubclass: aClass [
	subclasses isNil ifTrue: [^self].
	subclasses := subclasses copyWithout: aClass
]

{ #category : #accessing }
Class >> subclasses [
	subclasses isNil ifTrue: [^#()].
	^name == #Class
		ifTrue: [subclasses reject: [:s | s isMetaclass]]
		ifFalse: [subclasses]
]

{ #category : #accessing }
Class >> subclasses: aCollection [
	subclasses := aCollection isEmpty ifFalse: [aCollection asArray]
]

{ #category : #queries }
Class >> subclassesDo: aBlock [
	subclasses isNil ifTrue: [^self].
	subclasses
		select: [:cls | cls notNil]
		thenDo: [:c | aBlock evaluateWith: c]
]

{ #category : #accessing }
Class >> subspecies [
	subclasses isNil ifTrue: [^#()].
	^subclasses
]

{ #category : #queries }
Class >> subspeciesDo: aBlock [
	subclasses isNil ifTrue: [^self].
	self subspecies do: aBlock
]

{ #category : #accessing }
Class >> symbol [
	^name
]

