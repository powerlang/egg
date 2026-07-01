'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SCascade category: 'Powerlang-Core-SExpressions'!
SExpression subclass: #SCascade
	instanceVariableNames: 'receiver messages'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SCascade methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^visitor visitCascade: self
! !

!SCascade methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isCascade
	^true
! !

!SCascade methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
messages
	^messages
! !

!SCascade methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
messages: aCollection
	messages := aCollection
! !

!SCascade methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^receiver
! !

!SCascade methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: anSExpression
	receiver := anSExpression
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCascade class' category: 'Powerlang-Core-SExpressions'!
SCascade class
	instanceVariableNames: ''!

!SCascade class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeCascade
! !


