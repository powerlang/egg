"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OActivationContext',
	#superclass : 'OLoadImplicit',
	#instVars : [
		'hasFrame',
		'temporaries',
		'storesPreviousSelf'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'accessing' }
OActivationContext >> arguments [
	| result |
	result := OrderedCollection new.
	self usesDo: [:use | | user |
		user := use user.
		(user isLoad and: [user index > 0]) ifTrue: [result add: user]].
	^result
]

{ #category : 'accessing' }
OActivationContext >> doSavePreviousSelf [
	storesPreviousSelf := true
]

{ #category : 'accessing' }
OActivationContext >> hasFrame [
	^hasFrame
]

{ #category : 'accessing' }
OActivationContext >> haveFrame [
	hasFrame := true
]

{ #category : 'accessing' }
OActivationContext >> implicitLoads [
	| result |
	result := OrderedCollection new.
	next
		do: [:inst | inst isLoadImplicit
			ifTrue: [result add: inst]
			ifFalse: [^result]].
	^result
]

{ #category : 'accessing' }
OActivationContext >> initialize [
	hasFrame := false.
	storesPreviousSelf := false
]

{ #category : 'accessing' }
OActivationContext >> isActivation [
	^true
]

{ #category : 'accessing' }
OActivationContext >> receiver [
	self _ASSERT: (next isLoadImplicit and: [next name = #self]).
	^next
]

{ #category : 'accessing' }
OActivationContext >> savesPreviousSelf [
	^storesPreviousSelf
]

{ #category : 'accessing' }
OActivationContext >> temporaries [
	^temporaries
]

{ #category : 'accessing' }
OActivationContext >> temporaries: aNumber [
	temporaries := aNumber.
	aNumber > 0 ifTrue: [self haveFrame]
]

{ #category : 'accessing' }
OActivationContext >> uninitializedTemporariesIn: aBasicBlock [
	| uninitialized |
	uninitialized := Set new: temporaries.
	1 to: temporaries do: [:i | uninitialized add: -1 - i].
	aBasicBlock instructionsDo: [:inst | | base index |
		inst isMessageSend ifTrue: [^uninitialized].
		inst isStore ifTrue: [
			base := inst base.
			(base == self and: [
				index := inst index.
				index isInteger])
				ifTrue: [uninitialized remove: index ifAbsent: nil]]].
	^uninitialized
]
