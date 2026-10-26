'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SReturnNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SReturnNode
	instanceVariableNames: 'expression return'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SReturnNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitReturn: self
! !

!SReturnNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
expression
	^expression
! !

!SReturnNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
expression: node
	expression := node
! !

!SReturnNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasAssign
	^expression hasAssign
! !

!SReturnNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isReturn
	^true
! !

!SReturnNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	expression nodesDo: aBlock includingDeclarations: aBoolean
! !

!SReturnNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
return: aSmalltalkToken
	return := aSmalltalkToken
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SReturnNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SReturnNode class
	instanceVariableNames: ''!


