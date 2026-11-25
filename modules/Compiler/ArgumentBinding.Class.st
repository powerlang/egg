'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ArgumentBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LocalBinding subclass: #ArgumentBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!ArgumentBinding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
beInlined
	environment := InlinedArgEnvironment new
! !

!ArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canBeAssigned
	^false
! !

!ArgumentBinding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
description
	^'argument ' , name
! !

!ArgumentBinding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEncoder
	aTreecodeEncoder encodeArgument: index env: environment
! !

!ArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: aNumber
	index := aNumber.

! !

!ArgumentBinding methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	environment := ArgumentEnvironment new
! !

!ArgumentBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isArgument
	^true
! !

!ArgumentBinding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInlined
	^environment isInlinedArgument
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ArgumentBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
ArgumentBinding class
	instanceVariableNames: ''!


ArgumentBinding initialize!

