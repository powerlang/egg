'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #NilBinding category: #'Powerlang-Core-SCompiler-Bindings'!
LiteralBinding subclass: #NilBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!NilBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeNil
! !

!NilBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
name
	^'nil'
! !

!NilBinding methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:41'!
value
	^nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NilBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
NilBinding class
	instanceVariableNames: ''!


