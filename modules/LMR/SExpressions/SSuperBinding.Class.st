'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SSuperBinding category: 'Powerlang-Core-SExpressions'!
SSelfBinding subclass: #SSuperBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SExpressions'!
!SSuperBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSelf
	^false
! !

!SSuperBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSuper
	^true
! !

!SSuperBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: 'SuperId'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SSuperBinding class' category: 'Powerlang-Core-SExpressions'!
SSuperBinding class
	instanceVariableNames: ''!


