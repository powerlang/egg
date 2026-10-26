'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SStringToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSymbolicToken subclass: #SStringToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SStringToken methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:40'!
asIdentifierNode
	^compiler identifierNode
		name: value;
		stretch: stretch;
		comments: comments
! !

!SStringToken methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:40'!
asSelectorNode
	^compiler selectorNode symbol: value; stretch: stretch
! !

!SStringToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasSymbol
	^value isSymbol
! !

!SStringToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isBinary
	^value isSymbol
! !

!SStringToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDelimitedIdentifier
	^value first = ${
! !

!SStringToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isKeyword
	^value last = $:
! !

!SStringToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isNameToken
	^(self isKeyword or: [self isBinary]) not
! !

!SStringToken methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:40'!
isStringToken
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SStringToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SStringToken class
	instanceVariableNames: ''!


