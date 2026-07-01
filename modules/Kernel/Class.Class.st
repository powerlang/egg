'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Class category: #Kernel!
Species subclass: #Class
	instanceVariableNames: 'name subclasses namespaces module'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Class commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Class methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_lookupName: aSymbol
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
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
addNamespace
	^self addNamespace: Namespace new.
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
addNamespace: aNamespace
	"
		first namespace are class variables, remaining ones are local pools of the class
	"
	namespaces isEmpty ifTrue: [namespaces := Array with: Namespace new].
	namespaces := namespaces copyWith: aNamespace.
	^aNamespace
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
addNamespaceAs: aSymbol
	| names |
	names := self addNamespace.
	^self classVarNamed: aSymbol put: names
! !

!Species methodsFor:  'flags' stamp: 'KenD 28/Jun/2026 13:27:38'!
beBytes
	format := Variable
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beDeleted
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
! !

!Class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
beNamed: aSymbol in: aSmalltalkSystem
	| symbol assoc |
	symbol := aSymbol asSymbol.
	assoc := aSmalltalkSystem associationClass key: symbol value: self.
	aSmalltalkSystem basicAdd: assoc.
	name := symbol
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beSubclassOf: aClass
	self installer superclass: aClass; install
! !

!Class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeDeleted
	^self !!== Class
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVariables
	^namespaces isEmpty ifTrue: [Namespace new] ifFalse: [namespaces first]
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVariables: aNamespace
	namespaces isEmpty
		ifTrue: [namespaces := Array with: aNamespace]
		ifFalse: [namespaces at: 1 put: aNamespace].
	(aNamespace isEmpty and: [namespaces size = 1])
		ifTrue: [namespaces := #()]
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVarNamed: aString
	^self classVariables at: aString ifAbsent: []
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVarNamed: aString put: anObject
    namespaces isEmpty ifTrue: [self addNamespace].
	^namespaces first at: aString put: anObject
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVarNames
	^self classVariables keys
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVarNames: aCollection
	| new old |
	new := Namespace new.
	old := self classVariables.
	
	aCollection do: [:k | | assoc |
		assoc := old associationAt: k ifAbsent: [k -> nil].
		new add: assoc].
	
	self classVariables: new.
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
comment
	^self organization isNil ifTrue: [''] ifFalse: [self organization comment]
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
comment: aString
	self organization comment: aString
! !

!Class methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
delete
	self canBeDeleted
		ifFalse: [self error: 'System Classes cannot be removed.'].
	Smalltalk removeClass: self
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
duplicate
	| copy meta md |
	copy := self objectShallowCopy buildBehavior.
	md := copy methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	meta := self class objectShallowCopy instanceClass: copy; buildBehavior.
	md := meta methodDictionary.
	md keysAndValuesDo: [:selector :method | md at: selector put: method copy].
	copy behavior: meta instanceBehavior; subclasses: #().
	^copy
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
duplicateHierarchy
	| copy |
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: self with: copy.
		child basicBeSubclassOf: copy].
	^copy
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
duplicateHierarchyFrom: aClass with: aClassCopy
	| copy |
	self == aClass ifTrue: [^aClassCopy].
	copy := self duplicate.
	self subspecies do: [:s | | child |
		child := s duplicateHierarchyFrom: aClass with: aClassCopy.
		child basicBeSubclassOf: copy].
	^copy
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
fillFrom: aClass
	| pools |
	super fillFrom: aClass.
	self == aClass ifTrue: [^self].
	self classVariables: aClass classVariables.
	self class fillFrom: aClass class
! !

!Class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasSubclasses
	^self subclasses size > 0
! !

!Class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeFrom: aSpecies
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
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceClass
	^self
! !

!Class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isClass
	^true
! !

!Class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDeleted
	^false
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
module
	^module
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
module: aModule
	module := aModule
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^name asString
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name: aSymbol
	name := aSymbol asSymbol
! !

!Class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
namespaces
	^namespaces
! !

!Class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
needsReinstallation
	self hasInstanceBehavior ifTrue: [^true].
	superclass isNil ifTrue: [^false].
	self instSize - self instVarNames size = superclass instSize
		ifFalse: [^true].
	self class instSize - self class instVarNames size
		= self class superclass instSize
		ifFalse: [^true].
	^self installer shouldRecomputeBehavior
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
pointer: pointers variable: variable
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
! !

!Class methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeFromSystem
	self allInstances notEmpty
		ifTrue: [^self error: 'There are instances of this class'].
	self delete
! !

!Class methodsFor:  'add/remove' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeSubclass: aClass
	subclasses isNil ifTrue: [^self].
	subclasses := subclasses copyWithout: aClass
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclasses
	subclasses isNil ifTrue: [^#()].
	^name == #Class
		ifTrue: [subclasses reject: [:s | s isMetaclass]]
		ifFalse: [subclasses]
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclasses: aCollection
	subclasses := aCollection isEmpty ifFalse: [aCollection asArray]
! !

!Class methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
subclassesDo: aBlock
	subclasses isNil ifTrue: [^self].
	subclasses
		select: [:cls | cls notNil]
		thenDo: [:c | aBlock evaluateWith: c]
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
subspecies
	subclasses isNil ifTrue: [^#()].
	^subclasses
! !

!Class methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
subspeciesDo: aBlock
	subclasses isNil ifTrue: [^self].
	self subspecies do: aBlock
! !

!Class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
symbol
	^name
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Class class' category: #Kernel!
Class class
	instanceVariableNames: ''!

!Class class methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
newSubclassOf: aClass
	| meta |
	meta := Metaclass new beSubclassOf: aClass class.
	^meta instanceClass module: Kernel; initializeFrom: aClass.
! !


