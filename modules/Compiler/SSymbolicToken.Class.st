'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SSymbolicToken category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SToken subclass: #SSymbolicToken
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SSymbolicToken methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
is: anObject
	^value == anObject
! !

!SSymbolicToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^value
! !

!SSymbolicToken methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: anObject
	value := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSymbolicToken class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SSymbolicToken class
	instanceVariableNames: ''!


