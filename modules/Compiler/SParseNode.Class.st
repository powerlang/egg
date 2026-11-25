'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #SParseNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SParseNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SParseNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:41'!
acceptVisitor: visitor
	^visitor visitParseNode: self
! !

!SParseNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
allNodesDo: aBlock
	self nodesDo: aBlock includingDeclarations: true
! !

!SParseNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
ast
	^compiler ast
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
hasAssign
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isAssign
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isBraceNode
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isCascade
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isCascadeMessage
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isEvaluable
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isImmediate
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isMessageNode
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isMethod
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isMethodArgument
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isMethodTemporary
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isReturn
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isSelector
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isSelf
	^false
! !

!SParseNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isSuper
	^false
! !

!SParseNode methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:41'!
moveCommentsFrom: aParseNode
	aParseNode moveCommentsTo: self
! !

!SParseNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
nodeWithLiteral: anObject
	^self nodesDetect: [:n | (n isLiteral or: [n isSelector]) and: [n value = anObject]] ifAbsent: nil

! !

!SParseNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
nodesDetect: aBlock ifAbsent: absentBlock
	self nodesDo: [:node | (aBlock value: node) ifTrue: [ ^node ] ] includingDeclarations: false.
	^absentBlock value
! !

!SParseNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
nodesDo: aBlock
	self nodesDo: aBlock includingDeclarations: false
! !

!SParseNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:41'!
nodesDo: aBlock includingDeclarations: aBoolean
	aBlock value: self
! !

!SParseNode methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:41'!
variableNamed: aString
	self
		allNodesDo: [:node | (node isIdentifier and: [node name = aString])
			ifTrue: [^node]].
	^nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SParseNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode class
	instanceVariableNames: ''!


