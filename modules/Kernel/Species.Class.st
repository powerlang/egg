'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Species category: #Kernel!
Object subclass: #Species
	instanceVariableNames: 'superclass instanceBehavior format organization instanceVariables'
	classVariableNames: 'Flags'
	poolDictionaries: ''
	category: 'Kernel'!
!Species commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
_instancesAreArrayed
	^format & Variable = Variable
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
_instancesAreFixed
	^format & Variable = 0
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
_instancesHavePointers
	^format & Pointers !!= 0
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>> aSelector
	^self compiledMethodAt: aSelector
! !

!Species methodsFor:  'add/remove' stamp: 'KenD 28/Jun/2026 13:27:38'!
addSelector: aSymbol withMethod: aCompiledMethod
	| selector |
	selector := aSymbol asSymbol.
	self methodDictionary at: selector put: aCompiledMethod.
	self organization notNil ifTrue: [self organization classify: selector]
! !

!Species methodsFor:  'hierarchy' stamp: 'KenD 28/Jun/2026 13:27:38'!
addSubclass: aClass
	| copy |
	(self subclasses includes: aClass) ifTrue: [^self].
	copy := self subclasses copyWith: aClass.
	self subclasses: copy.
	aClass superclass: self
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allClassVarNames
	^(self withAllSuperclasses reversed gather: [:cls | cls classVarNames]) asArray
! !

!Species methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
allInstances
	^Kernel memory allInstancesOf: self
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allInstVarNames
	^(self withAllSuperclasses reversed gather: [:class | class instVarNames]) asArray
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSubclasses
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSubclassesDo: aBlock
	self subclassesDo: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSubinstances
	| subinstances |
	subinstances := OrderedCollection new.
	[
		self
			withAllSubclassesDo: [:cls | subinstances
				addAll: cls allExistingInstances]]
		evaluateAtomically.
	^subinstances asArray
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSubspecies
	| all |
	all := OrderedCollection new.
	self allSubspeciesDo: [:cls | all add: cls].
	^all
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSubspeciesDo: aBlock
	self subspeciesDo: [:class | 
		aBlock value: class.
		class allSubspeciesDo: aBlock]
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSuperclasses
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
allSuperclassesDo: aBlock
	superclass isNil ifTrue: [^self].
	aBlock value: superclass.
	superclass allSuperclassesDo: aBlock
! !

!Species methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicNew
	^self errorVMSpecific
! !

!Species methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicNew: anInteger
	^self errorVMSpecific
! !

!Species methodsFor:  'flags' stamp: 'KenD 28/Jun/2026 13:27:38'!
bePointers
	format := Pointers + self instSize
! !

!Species methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
browse
	Smalltalk browsingTools browse: self
! !

!Species methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
buildBehavior
	| behavior |
	behavior := Behavior with: self methodDictionary copy.
	superclass ifNotNil: [behavior next: superclass instanceBehavior].
	instanceBehavior := behavior
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canUnderstand: aSymbol
	^instanceBehavior implements: aSymbol
! !

!Species methodsFor:  'organization' stamp: 'KenD 28/Jun/2026 13:27:38'!
categories
	^self organization notNil
		ifTrue: [self organization categoriesOn: self]
		ifFalse: [#()]
! !

!Species methodsFor:  'organization' stamp: 'KenD 28/Jun/2026 13:27:38'!
categorizedSelectors
	^self organization notNil
		ifTrue: [self organization allSelectors]
		ifFalse: [#()]
! !

!Species methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
categoryFor: selector
	| category |
	self organization notNil ifTrue: [
		category := self organization categoryFor: selector.
		category notNil ifTrue: [^category]].
	^ClassOrganizer default
! !

!Species methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
classImplementing: aSymbol
	(self methodDictionary includesKey: aSymbol) ifTrue: [^self].
	^self allSuperclasses
		detect: [:class | class includesSelector: aSymbol]
		ifNone: []
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVariableAssociationAt: aString
	| c assoc |
	c := self.
	[
		c isNil ifTrue: [^nil].
		c classVariables notNil and: [
			assoc := c classVariables associationAt: aString ifAbsent: nil.
			assoc notNil]]
		whileFalse: [c := c superclass].
	^assoc
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
classVariableString
	| stream |
	stream := '' writeStream.
	self classVarNames asSortedCollection
		do: [:cvar | stream nextPutAll: cvar]
		separatedBy: [stream space].
	^stream contents
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
compiledMethodAt: aSymbol
	^self methodDictionary at: aSymbol ifAbsent: nil
! !

!Species methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self
! !

!Species methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
depth
	"
	Object depth
	SmallInteger depth 4
	"
	| depth ancestor |
	depth := 0.
	ancestor := self superclass.
	ancestor notNil ifTrue: [depth := ancestor depth + 1].
	^depth
! !

!Species methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorNotIndexable
	^self error: 'Instances of ' , self name , ' are not indexable'
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
fillFrom: aClass
	| ivars |
	self == aClass ifTrue: [^self].
	format := aClass format.
	ivars := aClass instVarNames.
	instanceVariables := ivars notEmpty ifTrue: [ivars]
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
format
	^format
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
format: anInteger
	format := anInteger
! !

!Species methodsFor:  'organization' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasUnclassifiedSelectors
	^self categorizedSelectors size < self methodDictionary size
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesSelector: aSymbol
	^self methodDictionary includesKey: aSymbol
! !

!Species methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
inheritsFrom: aClass
	| class |
	class := self.
	[class == nil] whileFalse: [
		class == aClass ifTrue: [^true].
		class := class superclass].
	^false
! !

!Species methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeOrganization
	self
		organization: (ClassOrganizer new classifyAll: self selectors under: nil)
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceBehavior
	^instanceBehavior
! !

!Species methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceBehavior: aBehavior
	instanceBehavior := aBehavior
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instancesAreArrayed
	^self _instancesAreArrayed
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instancesHavePointers
	^self _instancesHavePointers
! !

!Species methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
instanceVariableString
	^String streamContents: [:strm | 
		self instVarNames
			do: [:ivar | strm nextPutAll: ivar]
			separatedBy: [strm space]]
! !

!Species methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
instSize
	^format & 16r7F
! !

!Species methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
instVarNames
	instanceVariables isNil ifTrue: [^#()].
	instanceVariables isArray ifTrue: [^instanceVariables].
	^instanceVariables substrings
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
instVarNames: aCollection
	instanceVariables := aCollection isEmpty 
		ifFalse: [
			self isBytes ifTrue: [^self error: 'byte objects cannot have named instance variables'].
			aCollection asArray].
	self updateInstSize; allSubspeciesDo: [:class | class updateInstSize]
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBytes
	^self _instancesHavePointers not
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCategorized
	^self organization notNil
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSpecies
	^true
! !

!Species methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isVariable
	^self _instancesAreArrayed
! !

!Species methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
kindOfSubclass
	self _instancesAreFixed ifTrue: [^'subclass:'].
	self isBytes ifTrue: [^'variableByteSubclass:'].
	self _instancesHavePointers ifTrue: [^'variableSubclass:'].
	self error: 'invalid type of subclass'
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodDictionary
	^instanceBehavior methods
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodsReadingInstVar: aString
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm usesInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodsReferencingClassVar: aString
	| methods assoc |
	methods := OrderedCollection new.
	assoc := self classVariableAssociationAt: aString.
	assoc isNil ifTrue: [^methods].
	self instanceClass methodDictionary
		& self instanceClass class methodDictionary
		select: [:cm | cm referencesAssociation: assoc]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodsReferencingInstVar: aString
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm referencesInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
methodsWritingInstVar: aString
	| methods index |
	methods := OrderedCollection new.
	index := self indexOfSlot: aString.
	index = 0 ifTrue: [^methods].
	self methodDictionary
		select: [:cm | cm assignsInstanceVariable: index]
		thenDo: [:cm | methods add: cm].
	^methods
! !

!Species methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self errorVMSpecific
! !

!Species methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self errorVMSpecific
! !

!Species methodsFor:  'organization' stamp: 'KenD 28/Jun/2026 13:27:38'!
organization
	organization isNil ifTrue: [self initializeOrganization].
	^organization
! !

!Species methodsFor:  'organization' stamp: 'KenD 28/Jun/2026 13:27:38'!
organization: aClassOrganizer
	organization := aClassOrganizer
! !

!Species methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveNewBytes: size
	^self errorVMSpecific
! !

!Species methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: self name
! !

!Species methodsFor:  'add/remove' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeSelector: aSymbol
	self methodDictionary removeKey: aSymbol ifAbsent: [].
	self organization notNil ifTrue: [self organization remove: aSymbol]
! !

!Species methodsFor:  'add/remove' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeSubclass: aClass
	"
	do nothing
	"
	
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selectors
	^self methodDictionary keys
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
selectorsInCategory: aSymbol
	^self organization selectorsFor: aSymbol
! !

!Species methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopy
	^self
! !

!Species methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
shouldBeHidden: aSymbol
	^false
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
superclass
	^superclass
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
superclass: aClass
	superclass := aClass
! !

!Species methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
timestamp
	^organization notNil ifTrue: [organization timestamp]
! !

!Species methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
updateClassifications
	organization notNil ifTrue: [organization updateOn: self]
! !

!Species methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
updateInstSize
	| size |
	size := superclass isNil ifTrue: [0] ifFalse: [superclass instSize].
	format := format - self instSize + size + self instVarNames size
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAllSubclasses
	^OrderedCollection with: self withAll: self allSubclasses
! !

!Species methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAllSubclassesDo: aBlock
	aBlock evaluateWith: self.
	self allSubclassesDo: aBlock
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAllSubspecies
	^OrderedCollection with: self withAll: self allSubspecies
! !

!Species methodsFor:  'queries' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAllSuperclasses
	^OrderedCollection with: self withAll: self allSuperclasses
! !

!Species methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAllSuperclassesDo: aBlock
	aBlock evaluateWith: self.
	self allSuperclassesDo: aBlock
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Species class' category: #Kernel!
Species class
	instanceVariableNames: 'Flags'!

!Species class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeFormatFlags
	Flags := self addNamespace.
	Flags
		at: #Variable put: 16r2000;
		at: #Pointers put: 16r4000
! !

!Species class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxInstVarCount
	^16r7F
! !


