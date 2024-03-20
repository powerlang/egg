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
		'pc'
		'receiver',
		'stack',
		'environment',
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
Context >> code: anExecutableCode [
	| temps |
	code := anExecutableCode.
	temps := code compiledCode tempCount.
	stack := OrderedCollection new: temps + 5.
	stack stretchTo: temps.
	pc := 1.
]

{ #category : #services }
Context >> copyAllTo: aProcessStack [
	| start offset |

	parent
		ifNil: [
			aProcessStack
				pcAt: 0 put: 0 of: nil;
				fpAt: 1 put: 0.
			start := 3]
		ifNotNil: [ start := parent copyAllTo: aProcessStack].

	aProcessStack
		at: start put: receiver;
		at: start + 1 put: code.

	environment ifNil: [offset := 0] ifNotNil: [
		aProcessStack
			at: start + 2 put: caller lastEnvironment;
			at: start + 3 put: environment.
		offset := 2.
	].

	stack do: [:temp | aProcessStack at: start + offset put: temp. offset := offset + 1 ].
	aProcessStack
		pcAt: start + offset put: pc of: code;
		fpAt: start + offset + 1 put: start - 1.

	^start + offset + 2
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
	environment ifNotNil: [^environment].
	^caller ifNotNil: [caller lastEnvironment]
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
