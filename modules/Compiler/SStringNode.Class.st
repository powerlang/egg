'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SStringNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SLiteralNode subclass: #SStringNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SStringNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitString: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SStringNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SStringNode class
	instanceVariableNames: ''!


