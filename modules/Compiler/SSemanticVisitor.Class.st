'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SSemanticVisitor category: #'Powerlang-Core-SCompiler'!
SParseTreeVisitor subclass: #SSemanticVisitor
	instanceVariableNames: 'inliner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeAssignment: anAssignmentNode
	anAssignmentNode assignees
		do: [:v | self analyzeIdentifier: v assignee: true]
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeBlock: aBlockNode while: aBlock
	aBlockNode isInlined
		ifFalse: [aBlockNode index: aBlockNode compiler blockIndex].
	self analyzeScript: aBlockNode while: aBlock
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeIdentifier: anIdentifierNode
	self analyzeIdentifier: anIdentifierNode assignee: false
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeIdentifier: anIdentifierNode assignee: aBoolean
	| script binding |
	anIdentifierNode resolveAssigning: aBoolean.
	aBoolean ifTrue: [anIdentifierNode beAssigned].
	script := anIdentifierNode compiler activeScript.
	binding := anIdentifierNode binding.
	script reference: binding.
	binding isLocal ifTrue: [binding := script scope captureLocal: binding].
	anIdentifierNode binding: binding
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeMessage: aMessageNode
	inliner inline: aMessageNode.
	aMessageNode isInlined ifFalse: [aMessageNode compiler noticeSend]
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeMethod: aMethodNode while: aBlock
	self analyzeScript: aMethodNode while: aBlock
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeReturn: aReturnNode
	aReturnNode compiler activeScript realScript captureHome
! !

!SSemanticVisitor methodsFor:  'analizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
analyzeScript: aScriptNode while: aBlock
	aScriptNode compiler activate: aScriptNode while: aBlock
! !

!SSemanticVisitor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	inliner := MessageInliner new
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitAssignment: anAssignmentNode
	self analyzeAssignment: anAssignmentNode.
	anAssignmentNode expression acceptVisitor: self
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBlock: aBlockNode
	self
		analyzeBlock: aBlockNode
		while: [aBlockNode statements do: [:node | node acceptVisitor: self]]
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBraceNode: aBraceNode
	aBraceNode isLiteral
		ifFalse: [aBraceNode asMessageNode acceptVisitor: self]
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascade: aCascadeNode
	aCascadeNode receiver acceptVisitor: self.
	aCascadeNode messages do: [:msg | msg acceptVisitor: self]
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitIdentifier: anIdentifierNode
	self analyzeIdentifier: anIdentifierNode
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMessage: aMessageNode
	self analyzeMessage: aMessageNode.
	aMessageNode receiver acceptVisitor: self.
	aMessageNode arguments do: [:arg | arg acceptVisitor: self]
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMethod: aMethodNode
	self analyzeMethod: aMethodNode while: [
		aMethodNode bindLocals.
		aMethodNode statements do: [:s | s acceptVisitor: self].
		aMethodNode positionLocals]
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitParseNode: aParseNode
	"
	do nothing
	"
	
! !

!SSemanticVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitReturn: aReturnNode
	aReturnNode expression acceptVisitor: self.
	self analyzeReturn: aReturnNode
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSemanticVisitor class' category: #'Powerlang-Core-SCompiler'!
SSemanticVisitor class
	instanceVariableNames: ''!


SSemanticVisitor initialize!

