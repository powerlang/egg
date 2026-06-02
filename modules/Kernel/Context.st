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

{ #category : #reifying }
Context class >> fromStack: aStack [
	^self fromStack: aStack frameAt: aStack bp pc: aStack pc top: aStack sp callee: nil
]

{ #category : #reifying }
Context class >> fromStack: aStack frameAt: bp pc: pc top: top callee: callee [
	| receiver code env first temps context next nextpc caller |
	receiver := aStack at: bp - 1.
	code := aStack at: bp - 2.
	env := aStack at: bp - 4.
	first := bp - 5.
	temps := aStack copyFrom: first to: top.
	context := self new
		receiver: receiver;
		code: code;
		environment: env;
		pc: pc;
		stack: temps;
		callee: callee;
		yourself.
	next := aStack bpAt: bp.
	next > 0 ifTrue: [
		nextpc := aStack pcAt: bp + 1.
		caller := self fromStack: aStack frameAt: next pc: nextpc top: bp + 2 callee: context.
		context caller: caller].
	^context
]

{ #category : #accessing }
Context >> arguments [
	| size |
	caller isNil ifTrue: [^#()].
	size := code argumentCount.
	size = 0 ifTrue: [^#()].
	^caller stackTop: size
]

{ #category : #printing }
Context >> backtrace [
	| result context depth |
	result := ''.
	context := self.
	depth := 0.
	[context notNil and: [depth < 64]] whileTrue: [
		result := result, context frameDescription, String cr.
		context := context caller.
		depth := depth + 1].
	context notNil ifTrue: [result := result, '... (truncated)', String cr].
	^result
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
Context >> code: aCompiledCode [
	code := aCompiledCode
]

{ #category : #accessing }
Context >> pc [
	^pc
]

{ #category : #accessing }
Context >> pc: anInteger [
	pc := anInteger
]

{ #category : #accessing }
Context >> stack: aCollection [
	stack := aCollection
]

{ #category : #accessing }
Context >> code: anExecutableCode method: aCompiledMethod [
	| temps |
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
	| start |
	start := caller copyAllTo: aProcessStack.
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

{ #category : #printing }
Context >> frameDescription [
	^String streamContents: [:s |
		s nextPutAll: ([self frameHeader] on: Error do: ['<bad frame>']).
		code isBlock ifTrue: [
			s crtab; nextPutAll: 'args: '; nextPutAll: ([self arguments printString] on: Error do: ['<?>'])].
		s crtab; nextPutAll: 'receiver: '; nextPutAll: ([receiver printString] on: Error do: ['<?>']).
		s crtab; nextPutAll: 'temps: '; nextPutAll: ([self temps printString] on: Error do: ['<?>']).
		s crtab; nextPutAll: 'env: '; nextPutAll: ([environment printString] on: Error do: ['<?>']).
		s cr]
]

{ #category : #printing }
Context >> frameHeader [
	code isBlock ifTrue: [^code printString].
	^String streamContents: [:s |
		s print: code classBinding; nextPutAll: '>>'; nextPutAll: self selectorWithArguments]
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
Context >> receiver [
	^receiver
]

{ #category : #accessing }
Context >> receiver: anObject [
	receiver := anObject
]

{ #category : #printing }
Context >> selectorWithArguments [
	| keywords args |
	keywords := code selector keywords.
	args := self arguments.
	^String streamContents: [:s |
		1 to: keywords size do: [:i |
			i > 1 ifTrue: [s space].
			s nextPutAll: (keywords at: i) asString.
			i <= args size ifTrue: [s space; print: (args at: i)]]]
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

{ #category : #accessing }
Context >> temps [
	| count|
	count := code tempCount min: stack size.
	^stack copyFrom: 1 to: count
]
