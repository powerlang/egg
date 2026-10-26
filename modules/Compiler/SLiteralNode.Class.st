'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #SLiteralNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SLiteralNode
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SLiteralNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
acceptVisitor: visitor
	^visitor visitLiteral: self
! !

!SLiteralNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:41'!
beSymbol
	value := value asSymbol
! !

!SLiteralNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
hasSymbol
	^value isSymbol
! !

!SLiteralNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isEvaluable
	^true
! !

!SLiteralNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isImmediate
	^true
! !

!SLiteralNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isLiteral
	^true
! !

!SLiteralNode methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:41'!
value
	^value
! !

!SLiteralNode methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:41'!
value: anObject
	value := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SLiteralNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SLiteralNode class
	instanceVariableNames: ''!


