"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #Context,
	#superclass : #Object,
	#instVars : [
		'caller',
		'callee',
		'code',
		'pc',
		'receiver',
		'stack',
		'environment'
	],
	#category : #Kernel
}

{ #category : #accessing }
Context >> arguments [
	size := code argumentCount.
	size = 0 ifTrue: [^#()].
	^caller stackTop: size 
]

{ #category : #accessing }
Context >> callee [
	^callee
]

{ #category : #accessing }
Context >> callee: aContext [
	callee := aContext
]

{ #category : #accessing }
Context >> caller [
	^caller
]


{ #category : #accessing }
Context >> caller: aContext [
	caller := aContext
]

{ #category : #accessing }
Context >> code [
	^code
]

{ #category : #accessing }
Context >> code: anExecutableCode method: aCompiledMethod [
	| temps |
"	code := anExecutableCode."
	code := aCompiledMethod.
	temps := aCompiledMethod tempCount.
	stack := OrderedCollection new: temps + 5.
	stack stretchTo: temps.
	aCompiledMethod hasEnvironment 
		ifTrue: [environment := Array new: aCompiledMethod environmentCount].
	pc := 0.
]

{ #category : #services }
Context >> copyAllTo: aProcessStack [
	| start offset |
	start := parent copyAllTo: aProcessStack.
	^self copyTo: aProcessStack at: start
]

{ #category : #private }
Context >> copyEnvironmentTo: aProcessStack at: start [
	"environment ifNil: [^2]."
	aProcessStack
		at: start - 2 put: self previousEnvironment;
		at: start - 3 put: environment.
	^4
]

{ #category : #private }
Context >> copyTo: aProcessStack at: start [
	| delta |
	aProcessStack
		at: start put: receiver;
		at: start - 1 put: code.

	delta := self copyEnvironmentTo: aProcessStack at: start.

	stack do: [:temp |
		aProcessStack at: start - delta put: temp.
		delta := delta + 1 ].
	
	aProcessStack
		pcAt: start - delta put: pc of: code;
		bpAt: start - delta - 1 put: start + 1.

	^start - delta - 2
]

{ #category : #accessing }
Context >> environment [
	^environment
]

{ #category : #accessing }
Context >> environment: anObject [
	"The environment can be either nil (default), an array or a closure"
	environment := anObject
]

{ #category : #services }
Context >> lastEnvironment [
	"environment ifNotNil: [^environment].
	^caller ifNotNil: [caller lastEnvironment]"
	^environment
]

{ #category : #private }
Context >> previousEnvironment [
	^caller lastEnvironment
]

{ #category : #accessing }
Context >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
Context >> stack [
	^stack
]

{ #category : #services }
Context >> stackTop: anInteger [
	^stack last: anInteger
]

{ #category : #accessing }
Context >> tempAt: anInteger [
	^stack at: anInteger
]

{ #category : #accessing }
Context >> tempAt: anInteger put: anObject [
	^stack at: anInteger put: anObject
]
