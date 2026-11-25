'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TemporaryBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LocalBinding subclass: #TemporaryBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!TemporaryBinding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
description
	^'temporary ' , name
! !

!TemporaryBinding methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEncoder
	aTreecodeEncoder encodeTemporary: index env: environment
! !

!TemporaryBinding methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	environment := StackEnvironment new
! !

!TemporaryBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isTemporary
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TemporaryBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
TemporaryBinding class
	instanceVariableNames: ''!


TemporaryBinding initialize!

