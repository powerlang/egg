'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SEndToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SEndToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SEndToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isEnd
	^true
! !

!SEndToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
position: aNumber
	super position: aNumber - 1
! !

!SEndToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
prevPosition
	^stretch start
! !

!SEndToken methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: aString
	''
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SEndToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SEndToken class
	instanceVariableNames: ''!


