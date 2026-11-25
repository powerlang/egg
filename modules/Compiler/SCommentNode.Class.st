'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SCommentNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SCommentNode
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SCommentNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isComment
	^true
! !

!SCommentNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^value
! !

!SCommentNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
value: aString
	value := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCommentNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SCommentNode class
	instanceVariableNames: ''!


