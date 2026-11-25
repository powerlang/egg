'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SAssignmentNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SAssignmentNode
	instanceVariableNames: 'assignees expression operators'
	classVariableNames: 'Token'
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SAssignmentNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitAssignment: self
! !

!SAssignmentNode methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:40'!
assign: anIdentifierNode operator: aDelimiterToken
	assignees add: anIdentifierNode.
	operators add: aDelimiterToken
! !

!SAssignmentNode methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:40'!
assign: anIdentifierNode with: aParseNode operator: aDelimiterToken
	assignees add: anIdentifierNode.
	operators add: aDelimiterToken.
	expression := aParseNode
! !

!SAssignmentNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
assignees
	^assignees
! !

!SAssignmentNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
expression
	^expression
! !

!SAssignmentNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasAssign
	^true
! !

!SAssignmentNode methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	assignees := OrderedCollection new: 1.
	operators := OrderedCollection new: 1
! !

!SAssignmentNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isAssign
	^true
! !

!SAssignmentNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	assignees do: [:v | v nodesDo: aBlock includingDeclarations: aBoolean].
	expression nodesDo: aBlock includingDeclarations: aBoolean
! !

!SAssignmentNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
operators
	^operators
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SAssignmentNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SAssignmentNode class
	instanceVariableNames: 'Token'!


SAssignmentNode initialize!

