"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Species,
	#superclass : #Object,
	#instVars : [
		'superclass',
		'instanceBehavior',
		'format',
		'organization',
		'instanceVariables'
	],
	#classVars : [
		'Flags'
	],
	#category : #Kernel
}

{ #category : #initialization }
Species class >> initializeFormatFlags [
	Flags := self addNamespace.
	Flags
		at: #Variable put: 16r2000;
		at: #Pointers put: 16r4000
]

{ #category : #initialization }
Species class >> maxInstVarCount [
	^16r7F
]

{ #category : #testing }
Species >> _instancesAreArrayed [
	^format & Variable = Variable
]

{ #category : #testing }
Species >> _instancesAreFixed [
	^format & Variable = 0
]

{ #category : #testing }
Species >> _instancesHavePointers [
	^format & Pointers != 0
]

{ #category : #accessing }
Species >> >> aSelector [
	^self compiledMethodAt: aSelector
]

{ #category : #'add/remove' }
Species >> addSelector: aSymbol withMethod: aCompiledMethod [
	| selector |
	selector := aSymbol asSelector.
	self methodDictionary at: selector put: aCompiledMethod.
	self organization notNil ifTrue: [self organization classify: selector]
]

{ #category : #hierarchy }
Species >> addSubclass: aClass [
	| copy |
	(self subclasses includes: aClass) ifTrue: [^self].
	copy := self subclasses copyWith: aClass.
	self subclasses: copy.
	aClass superclass: self
]

{ #category : #queries }
Species >> allClassVarNames [
	^(self withAllSuperclasses reversed gather: [:cls | cls classVarNames]) asArray
]

{ #category : #private }
Species >> allExistingInstances [
	^Memory current allInstancesOf: self
]

{ #category : #instances }
Species >> allInstances [
	^[
		Smalltalk collectGarbage.
		self allExistingInstances] evaluateAtomically
]

{ #category : #queries }
Species >> allInstVarNames [
	^(self withAllSuperclasses reversed gather: [:class | class instVarNames]) asArray
]

{ #category : #'instance creation' }
Species >> allocate: byteSize size: size [
	| headerSize totalSize buffer object extended |
	extended := size > 255.
	headerSize := extended ifTrue: [16] ifFalse: [8].
	totalSize := headerSize + byteSize.
	buffer := self memory allocate: totalSize.
	object := (buffer + headerSize _asPointer) _asObject.
	object
		_basicULongAt: _Behavior put: self instanceBehavior;
		initializeExtended: extended contentSize: size.
	^object
]

{ #category : #queries }
Species >> allSubclasses [
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all
]

{ #category : #queries }
Species >> allSubclassesDo: aBlock [
	self subclassesDo: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]
]

{ #category : #queries }
Species >> allSubinstances [
	| subinstances |
	subinstances := OrderedCollection new.
	[
		Smalltalk collectGarbage.
		self
			withAllSubclassesDo: [:cls | subinstances
				addAll: cls allExistingInstances]]
		evaluateAtomically.
	^subinstances asArray
]

{ #category : #queries }
Species >> allSubspecies [
	| all |
	all := OrderedCollection new.
	self allSubspeciesDo: [:cls | all add: cls].
	^all
]

{ #category : #queries }
Species >> allSubspeciesDo: aBlock [
	self subspeciesDo: [:class | 
		aBlock value: class.
		class allSubspeciesDo: aBlock]
]

{ #category : #queries }
Species >> allSuperclasses [
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses
]

{ #category : #queries }
Species >> allSuperclassesDo: aBlock [
	superclass isNil ifTrue: [^self].
	aBlock value: superclass.
	superclass allSuperclassesDo: aBlock
]

{ #category : #'instance creation' }
Species >> basicNew [
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]
]

{ #category : #'instance creation' }
Species >> basicNew: anInteger [
	^self primitiveNew: anInteger
]

{ #category : #flags }
Species >> bePointers [
	format := Pointers + self instSize
]

{ #category : #services }
Species >> browse [
	Smalltalk browsingTools browse: self
]

{ #category : #services }
Species >> buildBehavior [
	| behavior |
	behavior := Behavior with: self methodDictionary copy.
	superclass ifNotNil: [behavior next: superclass instanceBehavior].
	instanceBehavior := behavior
]

{ #category : #testing }
Species >> canUnderstand: aSymbol [
	^instanceBehavior implements: aSymbol
]

{ #category : #organization }
Species >> categories [
	^self organization notNil
		ifTrue: [self organization categoriesOn: self]
		ifFalse: [#()]
]

{ #category : #organization }
Species >> categorizedSelectors [
	^self organization notNil
		ifTrue: [self organization allSelectors]
		ifFalse: [#()]
]

{ #category : #inquiries }
Species >> categoryFor: selector [
	| category |
	self organization notNil ifTrue: [
		category := self organization categoryFor: selector.
		category notNil ifTrue: [^category]].
	^ClassOrganizer default
]

{ #category : #inquiries }
Species >> classImplementing: aSymbol [
	(self methodDictionary includesKey: aSymbol) ifTrue: [^self].
	^self allSuperclasses
		detect: [:class | class includesSelector: aSymbol]
		ifNone: []
]

{ #category : #accessing }
Species >> classVariableAssociationAt: aString [
	| c assoc |
	c := self.
	[
		c isNil ifTrue: [^nil].
		c classVariables notNil and: [
			assoc := c classVariables associationAt: aString ifAbsent: nil.
			assoc notNil]]
		whileFalse: [c := c superclass].
	^assoc
]

{ #category : #accessing }
Species >> classVariableString [
	| stream |
	stream := '' writeStream.
	self classVarNames asSortedCollection
		do: [:cvar | stream nextPutAll: cvar]
		separatedBy: [stream space].
	^stream contents
]

{ #category : #accessing }
Species >> compiledMethodAt: aSymbol [
	^self methodDictionary at: aSymbol ifAbsent: nil
]

{ #category : #copying }
Species >> deepCopy [
	^self
]

{ #category : #inquiries }
Species >> depth [
	"
	Object depth
	SmallInteger depth 4
	"
	| depth ancestor |
	depth := 0.
	ancestor := self superclass.
	ancestor notNil ifTrue: [depth := ancestor depth + 1].
	^depth
]

{ #category : #errors }
Species >> errorNotIndexable [
	^self error: 'Instances of ' , self name , ' are not indexable'
]

{ #category : #accessing }
Species >> fillFrom: aClass [
	| ivars |
	self == aClass ifTrue: [^self].
	format := aClass format.
	ivars := aClass instVarNames.
	instanceVariables := ivars notEmpty ifTrue: [ivars]
]

{ #category : #accessing }
Species >> format [
	^format
]

{ #category : #accessing }
Species >> format: anInteger [
	format := anInteger
]

{ #category : #organization }
Species >> hasUnclassifiedSelectors [
	^self categorizedSelectors size < self methodDictionary size
]

{ #category : #testing }
Species >> includesSelector: aSymbol [
	^self methodDictionary includesKey: aSymbol
]

{ #category : #inquiries }
Species >> inheritsFrom: aClass [
	| class |
	class := self.
	[class == nil] whileFalse: [
		class == aClass ifTrue: [^true].
		class := class superclass].
	^false
]

{ #category : #initialization }
Species >> initializeOrganization [
	self
		organization: (ClassOrganizer new classifyAll: self selectors under: nil)
]

{ #category : #accessing }
Species >> instanceBehavior [
	^instanceBehavior
]

{ #category : #private }
Species >> instanceBehavior: aBehavior [
	instanceBehavior := aBehavior
]

{ #category : #testing }
Species >> instancesAreArrayed [
	^self _instancesAreArrayed
]

{ #category : #testing }
Species >> instancesHavePointers [
	^self _instancesHavePointers
]

{ #category : #services }
Species >> instanceVariableString [
	^String streamContents: [:strm | 
		self instVarNames
			do: [:ivar | strm nextPutAll: ivar]
			separatedBy: [strm space]]
]

{ #category : #inquiries }
Species >> instSize [
	^format & 16r7F
]

{ #category : #services }
Species >> instVarNames [
	instanceVariables isNil ifTrue: [^#()].
	instanceVariables isArray ifTrue: [^instanceVariables].
	^instanceVariables substrings
]

{ #category : #accessing }
Species >> instVarNames: aCollection [
	instanceVariables := aCollection isEmpty ifFalse: [aCollection asArray].
	self updateInstSize; allSubspeciesDo: [:class | class updateInstSize]
]

{ #category : #testing }
Species >> isBytes [
	^self _instancesHavePointers not
]

{ #category : #testing }
Species >> isCategorized [
	^self organization notNil
]

{ #category : #testing }
Species >> isSpecies [
	^true
]

{ #category : #testing }
Species >> isVariable [
	^self _instancesAreArrayed
]

{ #category : #services }
Species >> kindOfSubclass [
	self _instancesAreFixed ifTrue: [^'subclass:'].
	self isBytes ifTrue: [^'variableByteSubclass:'].
	self _instancesHavePointers ifTrue: [^'variableSubclass:'].
	self error: 'invalid type of subclass'
]

{ #category : #private }
Species >> memory [
	^Memory current
]

{ #category : #accessing }
Species >> methodDictionary [
	^instanceBehavior methods
]

{ #category : #queries }
Species >> methodsReadingInstVar: aString [
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm usesInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
]

{ #category : #queries }
Species >> methodsReferencingClassVar: aString [
	| methods assoc |
	methods := OrderedCollection new.
	assoc := self classVariableAssociationAt: aString.
	assoc isNil ifTrue: [^methods].
	self instanceClass methodDictionary
		& self instanceClass class methodDictionary
		select: [:cm | cm referencesAssociation: assoc]
		thenDo: [:cm | methods add: cm].
	^methods
]

{ #category : #queries }
Species >> methodsReferencingInstVar: aString [
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm referencesInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
]

{ #category : #queries }
Species >> methodsWritingInstVar: aString [
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm assignsInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
]

{ #category : #'instance creation' }
Species >> new [
	^self _instancesAreArrayed
		ifTrue: [self primitiveNew: 0]
		ifFalse: [self primitiveNew]
]

{ #category : #'instance creation' }
Species >> new: anInteger [
	^self primitiveNew: anInteger
]

{ #category : #'instance creation' }
Species >> nil: size slotsOf: object [
	object _nilSlots: size
]

{ #category : #organization }
Species >> organization [
	organization isNil ifTrue: [self initializeOrganization].
	^organization
]

{ #category : #organization }
Species >> organization: aClassOrganizer [
	organization := aClassOrganizer
]

{ #category : #unclassified }
Species >> primitiveNew [
	^self memory newPointers: instanceBehavior size: self instSize
]

{ #category : #unclassified }
Species >> primitiveNew: size [
	size _isSmallInteger ifFalse: [self error: 'invalid size'].
	self _instancesAreArrayed ifFalse: [self errorNotIndexable].
	^self _instancesHavePointers
		ifTrue: [self primitiveNewPointers: size + self instSize]
		ifFalse: [self primitiveNewBytes: size]
]

{ #category : #unclassified }
Species >> primitiveNewBytes: size [
	^self memory newArrayedBytes: instanceBehavior size: size
]

{ #category : #unclassified }
Species >> primitiveNewPointers: size [
	^self memory
		newArrayedPointers: instanceBehavior
		size: size
		named: self instSize > 0
]

{ #category : #printing }
Species >> printOn: aStream [
	aStream nextPutAll: self name
]

{ #category : #'add/remove' }
Species >> removeSelector: aSymbol [
	self methodDictionary removeKey: aSymbol ifAbsent: [].
	self organization notNil ifTrue: [self organization remove: aSymbol]
]

{ #category : #'add/remove' }
Species >> removeSubclass: aClass [
	"
	do nothing
	"
	
]

{ #category : #accessing }
Species >> selectors [
	^self methodDictionary keys
]

{ #category : #queries }
Species >> selectorsInCategory: aSymbol [
	^self organization selectorsFor: aSymbol
]

{ #category : #copying }
Species >> shallowCopy [
	^self
]

{ #category : #inquiries }
Species >> shouldBeHidden: aSymbol [
	^false
]

{ #category : #accessing }
Species >> superclass [
	^superclass
]

{ #category : #accessing }
Species >> superclass: aClass [
	superclass := aClass
]

{ #category : #accessing }
Species >> timestamp [
	^organization notNil ifTrue: [organization timestamp]
]

{ #category : #services }
Species >> updateClassifications [
	organization notNil ifTrue: [organization updateOn: self]
]

{ #category : #private }
Species >> updateInstSize [
	| size |
	size := superclass isNil ifTrue: [0] ifFalse: [superclass instSize].
	format := format - self instSize + size + self instVarNames size
]

{ #category : #queries }
Species >> withAllSubclasses [
	^OrderedCollection with: self withAll: self allSubclasses
]

{ #category : #enumerating }
Species >> withAllSubclassesDo: aBlock [
	aBlock evaluateWith: self.
	self allSubclassesDo: aBlock
]

{ #category : #queries }
Species >> withAllSubspecies [
	^OrderedCollection with: self withAll: self allSubspecies
]

{ #category : #queries }
Species >> withAllSuperclasses [
	^OrderedCollection with: self withAll: self allSuperclasses
]

{ #category : #enumerating }
Species >> withAllSuperclassesDo: aBlock [
	aBlock evaluateWith: self.
	self allSuperclassesDo: aBlock
]

{ #category : #'instance creation' }
Species >> zero: size bytesOf: object [
	object _zeroSlots: (size bitShift: 0 - WordSizeShift)
]

