'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SUndeclaredIdentifierError category: #'Powerlang-Core-SCompiler'!
SCompilationError subclass: #SUndeclaredIdentifierError
	instanceVariableNames: 'identifier assigned'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SUndeclaredIdentifierError methodsFor:  'accessing-token' stamp: 'KenD 28/Jun/2026 13:27:40'!
assignment: aBoolean
	assigned := aBoolean
! !

!SUndeclaredIdentifierError methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
identifier
	^ identifier
! !

!SUndeclaredIdentifierError methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isUndeclaredAccess
	^assigned not
! !

!SUndeclaredIdentifierError methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isUndeclaredAssignment
	^assigned
! !

!SUndeclaredIdentifierError methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stretch: aStretch
	super stretch: aStretch.
	identifier := self source
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SUndeclaredIdentifierError class' category: #'Powerlang-Core-SCompiler'!
SUndeclaredIdentifierError class
	instanceVariableNames: ''!


