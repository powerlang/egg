'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SDelimiterToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSymbolicToken subclass: #SDelimiterToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SDelimiterToken methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:40'!
asSelectorNode
	^compiler selectorNode symbol: value asString; stretch: stretch
! !

!SDelimiterToken methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
beCharacter
	value := value isCharacter ifTrue: [value] ifFalse: [value first]
! !

!SDelimiterToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
endsExpression
	^value = $. or: [value = $]] or: [value = $)] or: [value = $}]
! !

!SDelimiterToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isAssignment
	^self is: #':='
! !

!SDelimiterToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDelimiter
	^true
! !

!SDelimiterToken methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: aString
	super value: aString asSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SDelimiterToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SDelimiterToken class
	instanceVariableNames: ''!


