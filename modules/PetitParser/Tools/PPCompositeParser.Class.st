'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPCompositeParser category: #Tools!
PPDelegateParser subclass: #PPCompositeParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools'!
!PPCompositeParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPCompositeParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeStartingAt: aSymbol
	| allVariableNames ignoredVariableNames productionIndexesAndNames |
	self initialize.	

	"find all the productions that need to be initialized"
	allVariableNames := self class allInstVarNames
		collect: [ :each | each asSymbol ].
	ignoredVariableNames := self class ignoredNames
		collect: [ :each | each asSymbol ].
	productionIndexesAndNames := ((1 to: self class instSize)
		collect: [ :index | index -> (allVariableNames at: index) ])
		reject: [ :assoc | ignoredVariableNames includes: assoc value ].
	
	"initialize productions with an undefined parser to be replaced later"
	parser := PPUnresolvedParser named: aSymbol.
	productionIndexesAndNames do: [ :assoc |
		self instVarAt: assoc key put: (PPUnresolvedParser named: assoc value) ].
	parser def: (self perform: aSymbol).
	
	"resolve unresolved parsers with their actual implementation"
	productionIndexesAndNames do: [ :assoc |
		(self respondsTo: assoc value)
			ifFalse: [ self error: 'Unable to initialize ' , assoc value printString ]
			ifTrue: [ (self instVarAt: assoc key) def: (self perform: assoc value) ] ]
! !

!PPCompositeParser methodsFor:  'querying' stamp: 'KenD 28/Jun/2026 13:27:39'!
productionAt: aSymbol
	"Answer the production named aSymbol."
	
	^ self productionAt: aSymbol ifAbsent: [ nil ]
! !

!PPCompositeParser methodsFor:  'querying' stamp: 'KenD 28/Jun/2026 13:27:39'!
productionAt: aSymbol ifAbsent: aBlock
	"Answer the production named aSymbol, if there is no such production answer the result of evaluating aBlock."
	
	(self class ignoredNames includes: aSymbol asString)
		ifTrue: [ ^ aBlock value ].
	(self class startSymbol = aSymbol)
		ifTrue: [ ^ parser ].
	^ self instVarAt: (self class allInstVarNames
		indexOf: aSymbol asString
		ifAbsent: [ ^ aBlock value ])
! !

!PPCompositeParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
start
	"Answer the production to start this parser with."
	
	self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPCompositeParser class' category: #Tools!
PPCompositeParser class
	instanceVariableNames: ''!

!PPCompositeParser class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
ignoredNames
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internal to the composite parser."

	^ PPCompositeParser allInstVarNames
! !

!PPCompositeParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	"Answer a new parser starting at the default start symbol."

	^ self newStartingAt: self startSymbol
! !

!PPCompositeParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
newStartingAt: aSymbol
	^self basicNew initializeStartingAt: aSymbol
! !

!PPCompositeParser class methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parse: anObject
	^self parse: anObject startingAt: self startSymbol
! !

!PPCompositeParser class methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parse: anObject onError: aBlock
	^ self parse: anObject startingAt: self startSymbol onError: aBlock
! !

!PPCompositeParser class methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parse: anObject startingAt: aSymbol
	^ (self newStartingAt: aSymbol) parse: anObject
! !

!PPCompositeParser class methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parse: anObject startingAt: aSymbol onError: aBlock
	^ (self newStartingAt: aSymbol) parse: anObject onError: aBlock
! !

!PPCompositeParser class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
startSymbol
	"Answer the method that represents the default start symbol."

	^ #start
! !


