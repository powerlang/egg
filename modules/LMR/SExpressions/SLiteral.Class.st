'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SLiteral category: 'Powerlang-Core-SExpressions'!
SLiteralVar subclass: #SLiteral
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SLiteral methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: visitor
	^ visitor visitLiteral: self
! !

!SLiteral methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiteral
	^true
! !

!SLiteral methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream indent: anInteger
	aStream
		tab: anInteger;
		nextPutAll: '{LiteralId. ';
		print: value;
		nextPutAll: '}'
! !

!SLiteral methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
value
	^value
! !

!SLiteral methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
value: anObject
	value := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SLiteral class' category: 'Powerlang-Core-SExpressions'!
SLiteral class
	instanceVariableNames: ''!

!SLiteral class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
decodeUsing: aTreecodeDecoder
	^aTreecodeDecoder decodeLiteral
! !


