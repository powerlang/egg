'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #DynamicBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #DynamicBinding
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!DynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beReferencedFrom: aScriptNode
	"a dynamic binding could refer to an ivar, so we have to be conservative"
	aScriptNode useSelf
! !

!DynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeDynamicVar: name
! !

!DynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isDynamic
	^true
! !

!DynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
literal
	^name asSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DynamicBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
DynamicBinding class
	instanceVariableNames: 'Default'!

!DynamicBinding class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
default
	^Default ifNil: [Default := self new name: '<unresolved>']
! !

!DynamicBinding class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
named: aString
	| index first second |
	index := aString indexOf: $..
	index = 0 ifTrue: [ ^self new name: aString ].
	first := aString copyFrom: 1 to: index - 1.
	second := aString copyFrom: index + 1 to: aString size.
	^NestedDynamicBinding new name: { first. second }
! !


