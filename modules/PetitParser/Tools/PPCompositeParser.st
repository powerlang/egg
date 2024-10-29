"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPCompositeParser,
	#superclass : #PPDelegateParser,
	#category : #Tools
}

{ #category : #accessing }
PPCompositeParser class >> ignoredNames [
	"Answer a collection of instance-variables that should not be automatically initialized with productions, but that are used internal to the composite parser."

	^ PPCompositeParser allInstVarNames
]

{ #category : #'instance creation' }
PPCompositeParser class >> new [
	"Answer a new parser starting at the default start symbol."

	^ self newStartingAt: self startSymbol
]

{ #category : #'instance creation' }
PPCompositeParser class >> newStartingAt: aSymbol [
	^self basicNew initializeStartingAt: aSymbol
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject [
	^self parse: anObject startingAt: self startSymbol
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject onError: aBlock [
	^ self parse: anObject startingAt: self startSymbol onError: aBlock
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject startingAt: aSymbol [
	^ (self newStartingAt: aSymbol) parse: anObject
]

{ #category : #parsing }
PPCompositeParser class >> parse: anObject startingAt: aSymbol onError: aBlock [
	^ (self newStartingAt: aSymbol) parse: anObject onError: aBlock
]

{ #category : #accessing }
PPCompositeParser class >> startSymbol [
	"Answer the method that represents the default start symbol."

	^ #start
]

{ #category : #initialization }
PPCompositeParser >> initializeStartingAt: aSymbol [
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
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol [
	"Answer the production named aSymbol."
	
	^ self productionAt: aSymbol ifAbsent: [ nil ]
]

{ #category : #querying }
PPCompositeParser >> productionAt: aSymbol ifAbsent: aBlock [
	"Answer the production named aSymbol, if there is no such production answer the result of evaluating aBlock."
	
	(self class ignoredNames includes: aSymbol asString)
		ifTrue: [ ^ aBlock value ].
	(self class startSymbol = aSymbol)
		ifTrue: [ ^ parser ].
	^ self instVarAt: (self class allInstVarNames
		indexOf: aSymbol asString
		ifAbsent: [ ^ aBlock value ])
]

{ #category : #accessing }
PPCompositeParser >> start [
	"Answer the production to start this parser with."
	
	self subclassResponsibility
]

