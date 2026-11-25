'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #FalseBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding subclass: #FalseBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!FalseBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeFalse
! !

!FalseBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^'false'
! !

!FalseBinding methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FalseBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
FalseBinding class
	instanceVariableNames: ''!


