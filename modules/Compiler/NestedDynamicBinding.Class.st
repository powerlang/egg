'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #NestedDynamicBinding category: #'Powerlang-Core-SCompiler-Bindings'!
DynamicBinding subclass: #NestedDynamicBinding
	instanceVariableNames: 'parent'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!NestedDynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeUsing: aTreecodeEmitter
	aTreecodeEmitter encodeNestedDynamicVar: name
! !

!NestedDynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
literal
	^name collect: [ :n | n asSymbol]
! !

!NestedDynamicBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printNameOn: aStream
	name do: [ :n | aStream nextPutAll: n ] separatedBy: [ aStream nextPut: $. ]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NestedDynamicBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
NestedDynamicBinding class
	instanceVariableNames: ''!


