'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SParseTreeVisitor category: #'Powerlang-Core-SCompiler'!
Object subclass: #SParseTreeVisitor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visit: aParseNode
	^aParseNode notNil ifTrue: [aParseNode acceptVisitor: self] 
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitAssignment: anAssignmentNode
	^self visitParseNode: anAssignmentNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBlock: aBlockNode
	^self visitParseNode: aBlockNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitBraceNode: aBraceNode
	^self visitParseNode: aBraceNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascade: aCascadeNode
	^self visitParseNode: aCascadeNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitCascadeMessage: aCascadeMessageNode
	^self visitMessage: aCascadeMessageNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitForeignNode: anForeignNode
	self visitLiteral: anForeignNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitIdentifier: anIdentifierNode
	^self visitParseNode: anIdentifierNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitLiteral: aLiteralNode
	^self visitParseNode: aLiteralNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMessage: aMessageNode
	^self visitParseNode: aMessageNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitMethod: aMethodNode
	^self visitParseNode: aMethodNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitNumberNode: aNumberNode
	^self visitLiteral: aNumberNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitParseNode: aParseNode
	^self subclassResponsibility
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitPragma: aPragmaNode
	^self visitParseNode: aPragmaNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitReturn: aReturnNode
	^self visitParseNode: aReturnNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitSelector: aSelectorNode
	^self visitParseNode: aSelectorNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitString: aStringNode
	^self visitLiteral: aStringNode
! !

!SParseTreeVisitor methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
visitSymbolicPragma: aPragmaNode
	^self visitPragma: aPragmaNode
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SParseTreeVisitor class' category: #'Powerlang-Core-SCompiler'!
SParseTreeVisitor class
	instanceVariableNames: ''!


