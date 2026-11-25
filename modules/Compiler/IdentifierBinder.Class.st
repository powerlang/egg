'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #IdentifierBinder category: #'Powerlang-Core-SCompiler'!
Object subclass: #IdentifierBinder
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!IdentifierBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
contents
	^contents
! !

!IdentifierBinder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
keyFor: aString
	^self subclassResponsibility
! !

!IdentifierBinder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	self printOn: aStream indent: 0
! !

!IdentifierBinder methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream indent: anInteger
	self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IdentifierBinder class' category: #'Powerlang-Core-SCompiler'!
IdentifierBinder class
	instanceVariableNames: ''!


