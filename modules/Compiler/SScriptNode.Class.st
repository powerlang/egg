'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SScriptNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SScriptNode
	instanceVariableNames: 'statements arguments temporaries children scope'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SScriptNode methodsFor:  'add/remove' stamp: 'KenD 28/Jun/2026 13:27:40'!
addChild: aBlockNode
	children add: aBlockNode
! !

!SScriptNode methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
addStatements: anOrderedCollection
	statements addAll: anOrderedCollection
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
arguments
	^arguments
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
arguments: aCollection
	arguments := aCollection
! !

!SScriptNode methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
bindLocals
	arguments do: [:arg | arg defineArgumentIn: scope].
	temporaries do: [:temp | temp checkLowercase; defineTemporaryIn: scope].
	children do: [:block | block bindLocals]
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
children
	^children
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentSize
	^scope environmentSize
! !

!SScriptNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasAssign
	statements do: [:s | s hasAssign ifTrue: [^true]].
	^false
! !

!SScriptNode methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
identifiers
	| result |
	result := OrderedCollection new.
	self nodesDo: [:node | node isIdentifier ifTrue: [result add: node]].
	^result withoutDuplicates
! !

!SScriptNode methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	statements := OrderedCollection new.
	arguments := #().
	temporaries := #().
	children := OrderedCollection new
! !

!SScriptNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	aBoolean ifTrue: [
		arguments do: [:a | a nodesDo: aBlock includingDeclarations: aBoolean].
		temporaries do: [:a | a nodesDo: aBlock includingDeclarations: aBoolean]].
	statements do: [:s | s nodesDo: aBlock includingDeclarations: aBoolean]
! !

!SScriptNode methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionLocals
	scope positionLocals.
	children do: [:b | b positionLocals]
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
realScript
	self subclassResponsibility
! !

!SScriptNode methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
reference: aBinding
	aBinding beReferencedFrom: self
! !

!SScriptNode methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
scope
	^scope
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
statements
	^statements
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaries
	^temporaries
! !

!SScriptNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
temporaries: aCollection
	temporaries := aCollection
! !

!SScriptNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
useSelf
	scope captureSelf
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SScriptNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SScriptNode class
	instanceVariableNames: ''!


SScriptNode initialize!

