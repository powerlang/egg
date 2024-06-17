Class {
	#name : #StackedEvaluationContext,
	#superclass : #EvaluationContext,
	#instVars : [
		'stack',
		'regSP',
		'regBP',
		'regM',
		'regS',
		'regE',
		'pc'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : #initialization }
StackedEvaluationContext >> argumentAt: anInteger [

	^self argumentAt: anInteger frameIndex: 1 
]

{ #category : #initialization }
StackedEvaluationContext >> argumentAt: anInteger frameIndex: anotherInteger [

	| bp code count |
	bp := self bpForFrameAt: anotherInteger.
	code := stack at: bp - 2.
	count := runtime argumentCountOf: code.
	^ stack at: bp + 1 + (count - anInteger + 1)
]

{ #category : #initialization }
StackedEvaluationContext >> argumentAt: index in: environmentIndex [
	environmentIndex ifNil: [ ^ self argumentAt: index ].
	^self environment: environmentIndex at: index.

]

{ #category : #initialization }
StackedEvaluationContext >> arguments [
	| count |
	count := runtime argumentCountOf: regM.
	^ (count to: 1 by: -1) collect: [ :i | self argumentAt: i ]
]

{ #category : #services }
StackedEvaluationContext >> backtrace [
	| result bp code receiver |
	result := OrderedCollection new.
	bp := regBP.
	[ bp != 0 ]
		whileTrue: [ code := stack at: bp - 2.
			receiver := stack at: bp - 1.
			result add: {code. receiver}.
			bp := stack at: bp ].
	^ result
]

{ #category : #services }
StackedEvaluationContext >> bpForFrameAt: anInteger [

	| bp  |
	bp := regBP.
	anInteger - 1 timesRepeat: [ 
		bp = 0 ifTrue: [ ^ nil ].
		bp := stack at: bp ].
	^ bp
]

{ #category : #initialization }
StackedEvaluationContext >> buildClosureFrameFor: receiver code: code environment: environment [
	| temps |
	temps := runtime blockTempCount: code.
	self buildFrameFor: receiver code: code environment: environment temps: temps
]

{ #category : #initialization }
StackedEvaluationContext >> buildFrameFor: receiver code: code environment: environment temps: temps [
	regS := receiver.
	regM := code.
	self
		push: pc;
		push: regBP.
	regBP := regSP.
	regBP < 100 ifTrue: [ self error: 'stack overflow' ].
	self
		push: receiver;
		push: code;
		push: regE;
		push: environment.
	regE := environment.
	pc := 0.
	temps timesRepeat: [ self push: self nil ]
]

{ #category : #initialization }
StackedEvaluationContext >> buildLaunchFrame [
	| launcher code executable |
	launcher := runtime newCompiledMethod.
	code := runtime newArraySized: 0.
	executable := runtime newExecutableCodeFor: code.
	runtime methodExecutableCode: launcher put: executable.
	self
		buildMethodFrameFor: runtime nil
		code: launcher
		environment: runtime nil
]

{ #category : #initialization }
StackedEvaluationContext >> buildMethodFrameFor: receiver code: code environment: environment [
	| temps |
	temps := runtime methodTempCount: code.
	self
		buildFrameFor: receiver
		code: code
		environment: environment
		temps: temps
]

{ #category : #services }
StackedEvaluationContext >> contextSwitchTo: anotherStack sp: anotherSP environment: env [
	"Only a stack switch is needed (and restoring E), other registers
	are restored upon return from the currently executing method (prev BP, S, M and PC)"
	stack := anotherStack.
	regSP := anotherSP.
	regE := env

]

{ #category : #services }
StackedEvaluationContext >> dropOperands: anInteger [
	regSP := regSP + anInteger
]

{ #category : #initialization }
StackedEvaluationContext >> environment [
	^regE
]

{ #category : #initialization }
StackedEvaluationContext >> environment: array [

	regE := array
]

{ #category : #initialization }
StackedEvaluationContext >> environment: environmentIndex at: index [
	"
	-1: inlined argument.
	 0: current env.
 	>0: index of env in current env. "

	| env |
	environmentIndex = -1
		ifTrue: [ ^ self stackTemporaryAt: index ].
	env := environmentIndex = 0
		ifTrue: [ regE ]
		ifFalse: [ regE at: environmentIndex ].
	^ env at: index
]

{ #category : #initialization }
StackedEvaluationContext >> environment: environmentIndex at: index put: value [
	"
	-1: inlined argument.
	 0: current env.
 	>0: index of env in current env. "

	| env |
	environmentIndex = -1
		ifTrue: [ ^ self stackTemporaryAt: index put: value ].
	env := environmentIndex = 0
		ifTrue: [ regE ]
		ifFalse: [ regE at: environmentIndex ].
	^ env at: index put: value
]

{ #category : #initialization }
StackedEvaluationContext >> firstArgument [
	^ self argumentAt: 1
]

{ #category : #initialization }
StackedEvaluationContext >> fourthArgument [
	^ self argumentAt: 4
]

{ #category : #initialization }
StackedEvaluationContext >> hasFinished [
	^ regBP = 0 and: [ regSP = (stack size + 1) ]
]

{ #category : #initialization }
StackedEvaluationContext >> incRegPC [
	^pc := pc + 1
]

{ #category : #initialization }
StackedEvaluationContext >> initialize [
	super initialize.
	stack := Array new: 64 * 1024.
	regSP := stack size + 1.
	regBP := 0.
	pc := 0
]

{ #category : #initialization }
StackedEvaluationContext >> isBlock [
	^ runtime isBlock: regM
]

{ #category : #initialization }
StackedEvaluationContext >> method [
	^ self isBlock
		ifTrue: [ runtime blockMethod: regM ]
		ifFalse: [ regM ]
]

{ #category : #initialization }
StackedEvaluationContext >> method: aMethod [
	regM := aMethod

]

{ #category : #initialization }
StackedEvaluationContext >> methodArguments [
	| count |
	count := runtime methodArgumentCount: regM.
	^ (count to: 1 by: -1) collect: [ :i | self argumentAt: i ]
]

{ #category : #initialization }
StackedEvaluationContext >> operandAt: anInteger [
	^ stack at: regSP + anInteger
]

{ #category : #initialization }
StackedEvaluationContext >> pop [
	| result |
	result := stack at: regSP.
	regSP := regSP + 1.
	^result

]

{ #category : #initialization }
StackedEvaluationContext >> popFrame [

	regSP := regBP.

	regBP := self pop.
	pc := self pop.
	regE := stack at: regBP - 4.
	regM := stack at: regBP - 2.
	regS := stack at: regBP - 1
]

{ #category : #initialization }
StackedEvaluationContext >> popLaunchFrame [
	regSP := regBP.
	regE := stack at: regBP - 3.
	regBP := self pop.
	pc := self pop.
	regBP = 0
		ifTrue: [ ^ self ].
	regM := stack at: regBP - 2.
	regS := stack at: regBP - 1.

]

{ #category : #initialization }
StackedEvaluationContext >> popOperand [
	^self pop
]

{ #category : #initialization }
StackedEvaluationContext >> popOperands: anInteger [
	| result |
	anInteger = 0
		ifTrue: [ ^ #() ].
	result := Array new: anInteger.
	anInteger to: 1 by: -1 do: [ :i | result at: i put: self pop ].
	^ result
]

{ #category : #initialization }
StackedEvaluationContext >> printOn: aStream [
	| slot |
	regSP to: regBP + 3 do: [ :i | slot := stack at: i. aStream nextPutAll: i hex; nextPutAll: ' -> '; print: slot;cr ].
	aStream nextPutAll: '...'; cr.

super printOn: aStream
]

{ #category : #initialization }
StackedEvaluationContext >> printStack [
	^String
		streamContents: [ :stream | 
			| slot |
			regSP to: stack size do: [ :i | 
				slot := stack at: i.
				stream
					nextPutAll: i hex;
					nextPutAll: ' -> ';
					print: slot;
					cr ] ]
]

{ #category : #initialization }
StackedEvaluationContext >> push: anObject [
	anObject ifNil: [ self halt ].
	regSP := regSP - 1.
	stack at: regSP put: anObject
]

{ #category : #initialization }
StackedEvaluationContext >> pushOperand: anObject [
	anObject ifNil: [ self halt ].
	regSP := regSP - 1.
	stack at: regSP put: anObject
]

{ #category : #initialization }
StackedEvaluationContext >> receiver [
	^ regS
]

{ #category : #initialization }
StackedEvaluationContext >> receiver: object [

	regS := object
]

{ #category : #initialization }
StackedEvaluationContext >> regBP [
	^ regBP
]

{ #category : #initialization }
StackedEvaluationContext >> regBP: integer [

	regBP := integer
]

{ #category : #accessing }
StackedEvaluationContext >> regM [
	^ regM
]

{ #category : #accessing }
StackedEvaluationContext >> regPC [
	^pc
]

{ #category : #accessing }
StackedEvaluationContext >> regPC: anInteger [ 
	pc := anInteger
]

{ #category : #accessing }
StackedEvaluationContext >> regSP [

	^regSP
]

{ #category : #accessing }
StackedEvaluationContext >> regSP: integer [

	regSP := integer
]

{ #category : #services }
StackedEvaluationContext >> reserveStackSlots: anInteger [
	regSP := regSP - anInteger
]

{ #category : #initialization }
StackedEvaluationContext >> restart [
	| nilObj |
	nilObj := runtime nil.
	regBP - self tempOffset to: regSP by: -1 do: [ :i | stack at: i put: nilObj ].
	pc := 1
]

{ #category : #initialization }
StackedEvaluationContext >> runtime: anEggRuntime [
	super runtime: anEggRuntime.
	regE := regS := runtime nil
]

{ #category : #initialization }
StackedEvaluationContext >> secondArgument [
	^ self argumentAt: 2
]

{ #category : #initialization }
StackedEvaluationContext >> self [
	^ regS
]

{ #category : #services }
StackedEvaluationContext >> signalSuspension [

	EggProcessSuspended new
		process: self firstArgument;
		exception: self secondArgument;
		signal
]

{ #category : #services }
StackedEvaluationContext >> stack [

	^stack
]

{ #category : #services }
StackedEvaluationContext >> stack: array [
	stack := array
]

{ #category : #services }
StackedEvaluationContext >> stackSize [

	^stack size
]

{ #category : #initialization }
StackedEvaluationContext >> stackTemporaryAt: anInteger [

	^ self stackTemporaryAt: anInteger frameIndex: 1 
]

{ #category : #initialization }
StackedEvaluationContext >> stackTemporaryAt: anInteger frameIndex: anotherInteger [
	| bp |
	bp := self bpForFrameAt: anotherInteger.
	^ stack at: bp - self tempOffset - anInteger
]

{ #category : #initialization }
StackedEvaluationContext >> stackTemporaryAt: anInteger frameIndex: anotherInteger put: anObject [
	| bp |
	bp := self bpForFrameAt: anotherInteger.
	^ stack at: bp - self tempOffset - anInteger put: anObject
]

{ #category : #initialization }
StackedEvaluationContext >> stackTemporaryAt: anInteger put: anObject [

	^ self stackTemporaryAt: anInteger frameIndex: 1 put: anObject 
]

{ #category : #initialization }
StackedEvaluationContext >> tempOffset [ 
"should be 2 or 4 if we had methods without environment"
	^4
]

{ #category : #initialization }
StackedEvaluationContext >> temporaryAt: index in: environmentIndex [
	environmentIndex ifNil: [ ^ self stackTemporaryAt: index].
	^ self environment: environmentIndex at: index
]

{ #category : #initialization }
StackedEvaluationContext >> temporaryAt: index in: environmentIndex put: value [
	environmentIndex ifNil: [ ^ self stackTemporaryAt: index put: value ].
	^ self environment: environmentIndex at: index put: value
]

{ #category : #initialization }
StackedEvaluationContext >> thirdArgument [
	^ self argumentAt: 3
]

{ #category : #initialization }
StackedEvaluationContext >> unwind [
	| home bp environment |
	home := runtime closureHome: self environment.
	home == runtime nil ifTrue: [ self error: 'cannot return because closure has no home' ].
	bp := regBP.
	[ bp != 0 ]
		whileTrue: [ environment := stack at: bp - 4.
			environment == home
				ifTrue: [ regBP := bp.
					^ self popFrame ].
			bp := stack at: bp ].
	self error: 'cannot return from this closure'
]
