'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SReturn category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SReturn
	instanceVariableNames: 'local expression'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitReturn: self
! !

!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
expression
	^expression
! !

!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
expression: anSExpression
	expression := anSExpression
! !

!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isReturn
	^true
! !

!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
local
	^local
! !

!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
local: aBoolean
	local := aBoolean
! !

!SReturn methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream tab: anInteger; nextPutAll: '{ReturnId.'; cr.
	expression printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '}'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SReturn class' category: 'Powerlang-Core-SExpressions'!
SReturn class
	instanceVariableNames: ''!

!SReturn class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeReturn
! !


