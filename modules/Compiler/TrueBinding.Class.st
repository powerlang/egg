'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TrueBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding subclass: #TrueBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!TrueBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeTrue
! !

!TrueBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^'true'
! !

!TrueBinding methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:40'!
value
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TrueBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
TrueBinding class
	instanceVariableNames: ''!


