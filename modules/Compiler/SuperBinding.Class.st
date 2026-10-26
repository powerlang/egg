'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SuperBinding category: #'Powerlang-Core-SCompiler-Bindings'!
SelfBinding subclass: #SuperBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!SuperBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeSuper
! !

!SuperBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSelf
	^false
! !

!SuperBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSuper
	^true
! !

!SuperBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^'super'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SuperBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
SuperBinding class
	instanceVariableNames: ''!


