'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SpeciesSpec category: #CodeSpecs!
Object subclass: #SpeciesSpec
	instanceVariableNames: 'instanceVariables methods module format'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodeSpecs'!
!SpeciesSpec commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!SpeciesSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMethod: aMethodSpec
	^methods add: aMethodSpec
! !

!SpeciesSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMethods: aCollection
	aCollection do: [:m | self addMethod: m]
! !

!SpeciesSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
allInstVarNames
	^(self withAllSuperclasses reversed gather: [:c | c instVarNames]) asArray
! !

!SpeciesSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSharedPools
	| pools |
	pools := Set new.
	self withAllSuperclasses do: [:c | pools addAll: c sharedPools].
	^pools
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSubclasses
	| all |
	all := OrderedCollection new.
	self allSubclassesDo: [:cls | all add: cls].
	^all
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSubclassesDo: aBlock
	self subclasses do: [:class | 
		aBlock value: class.
		class allSubclassesDo: aBlock]
! !

!SpeciesSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSuperclasses
	| superclasses |
	superclasses := OrderedCollection new.
	self allSuperclassesDo: [:s | superclasses add: s].
	^superclasses
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
beArrayed
	format := format | IsArrayed
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
beBytes
	format := format | IsBytes
! !

!SpeciesSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasMethods
	^methods notEmpty
! !

!SpeciesSpec methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	methods := OrderedCollection new.
	instanceVariables := #().
	format := 0
! !

!SpeciesSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instancesAreArrayed
	^format anyMask: IsArrayed
! !

!SpeciesSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instancesHavePointers
	^(format anyMask: IsBytes) not
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instVarNames
	^instanceVariables
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instVarNames: aCollection
	instanceVariables := aCollection asOrderedCollection
! !

!SpeciesSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isExtension
	^module extendedClasses includes: self instanceClass
! !

!SpeciesSpec methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMetaclass
	^false
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
ivars: aCollection
	instanceVariables := aCollection asOrderedCollection
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
methods
	^methods
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
module: aModuleSpec
	module := aModuleSpec
! !

!SpeciesSpec methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: '<' , self name , '>'
! !

!SpeciesSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeCategory: aSymbol
	methods removeAllSuchThat: [:m | m category == aSymbol]
! !

!SpeciesSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeMethod: aMethodSpec
	methods remove: aMethodSpec ifAbsent: nil
! !

!SpeciesSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSelector: aSymbol
	methods removeAllSuchThat: [:m | m selector == aSymbol]
! !

!SpeciesSpec methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSelectors: aCollection
	methods removeAllSuchThat: [:m | aCollection includes: m selector]
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
selectors
	^methods collect: #selector
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
subclasses
	^module allClasses select: [:c | c supername = self name]
! !

!SpeciesSpec methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
withAllSubclasses
	^OrderedCollection with: self withAll: self allSubclasses
! !

!SpeciesSpec methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
withAllSuperclasses
	^OrderedCollection with: self withAll: self allSuperclasses
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SpeciesSpec class' category: #CodeSpecs!
SpeciesSpec class
	instanceVariableNames: ''!

!SpeciesSpec class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeFormatMasks
	self addNamespaceAs: #Format.
	Format
		at: 'IsArrayed' put: 0x1;
		at: 'IsBytes' put: 0x2
! !


SpeciesSpec initialize!

