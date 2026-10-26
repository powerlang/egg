'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SelfBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #SelfBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!SelfBinding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
beReferencedFrom: aScriptNode
	aScriptNode useSelf
! !

!SelfBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canBeAssigned
	^false
! !

!SelfBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeSelf
! !

!SelfBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isSelf
	^true
! !

!SelfBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^'self'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SelfBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
SelfBinding class
	instanceVariableNames: ''!


