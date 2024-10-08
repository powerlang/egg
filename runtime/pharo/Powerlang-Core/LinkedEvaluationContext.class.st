Class {
	#name : 'LinkedEvaluationContext',
	#superclass : 'EvaluationContext',
	#instVars : [
		'parent',
		'method',
		'arguments',
		'temporaries',
		'environment',
		'isBlock',
		'_self'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : 'instance creation' }
LinkedEvaluationContext class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'visiting' }
LinkedEvaluationContext >> argumentAt: anInteger [
	^arguments at: anInteger
]

{ #category : 'visiting' }
LinkedEvaluationContext >> argumentAt: index in: environmentIndex [
	| env | 
	environmentIndex ifNil: [ ^ arguments at: index ].
	env := self environmentFor: environmentIndex.
	^ env at: index
]

{ #category : 'visiting' }
LinkedEvaluationContext >> arguments [
	^arguments
]

{ #category : 'visiting' }
LinkedEvaluationContext >> arguments: aCollection [
	arguments := aCollection
]

{ #category : 'services' }
LinkedEvaluationContext >> backtrace [
	| bt next |
	bt := OrderedCollection new.
	next := self.
	[ next notNil and: [ next method notNil ] ]
		whileTrue: [ bt
				add:
					{next method signature.
					next self} , next arguments.
			next := next parent ].
	^ bt
]

{ #category : 'visiting' }
LinkedEvaluationContext >> beBlock [
	isBlock := true
]

{ #category : 'accessing' }
LinkedEvaluationContext >> environment [
	^ environment
]

{ #category : 'visiting' }
LinkedEvaluationContext >> environment: anObject [
	environment := anObject
]

{ #category : 'visiting' }
LinkedEvaluationContext >> environmentFor: anInteger [
	"
	-1: inlined argument.
	 0: current env.
 	>0: index of env in current env. "

	anInteger = 0
		ifTrue: [ ^ environment ].
	anInteger = -1
		ifTrue: [ ^ temporaries ].
	^ environment at: anInteger
]

{ #category : 'accessing' }
LinkedEvaluationContext >> firstArgument [
	^arguments at: 1
]

{ #category : 'accessing' }
LinkedEvaluationContext >> fourthArgument [
	^ arguments at: 4
]

{ #category : 'accessing' }
LinkedEvaluationContext >> framesCount [
	| current result |
	current := self.
	result := 0.
	[ current notNil ]
		whileTrue: [ result := result + 1.
			current := current parent ].
	^ result
]

{ #category : 'visiting' }
LinkedEvaluationContext >> homeContext [
	| frame searched |
	isBlock
		ifFalse: [ ^ self ].
	frame := parent.
	searched := runtime closureHome: environment.
	[ frame notNil ]
		whileTrue: [ frame environment == searched
				ifTrue: [ ^ frame ].
			frame := frame parent ].
	self error: 'home context not found'
]

{ #category : 'visiting' }
LinkedEvaluationContext >> initialize [
	isBlock := false
]

{ #category : 'visiting' }
LinkedEvaluationContext >> initializeForBlock: sblock args: anArray closure: closure [
	"When the block is not inlined, closure becomes the environment of the new context.
	But when it is inlined, the environment is the one of the builder, which is already
	set because we copied from the builder frame."


	sblock isInlined
		ifTrue: [ anArray
				with: sblock inlinedArgs
				do: [ :arg :i | temporaries at: i put: arg ] ]
		ifFalse: [ temporaries := Array new: sblock tempCount.
			arguments := anArray.
			environment := closure. ]
]

{ #category : 'visiting' }
LinkedEvaluationContext >> isBlock [
	^isBlock
	
]

{ #category : 'visiting' }
LinkedEvaluationContext >> isHomeOf: env [
	^ environment == env andNot: [ isBlock ]
]

{ #category : 'visiting' }
LinkedEvaluationContext >> method [
	^method
]

{ #category : 'accessing' }
LinkedEvaluationContext >> method: aMethod [
	| count |
	method := aMethod.
	count := runtime methodTempCount: aMethod.
	temporaries := Array new: count
]

{ #category : 'visiting' }
LinkedEvaluationContext >> methodArguments [
	^ arguments
]

{ #category : 'visiting' }
LinkedEvaluationContext >> parent [
	^parent
]

{ #category : 'visiting' }
LinkedEvaluationContext >> parent: anEvaluationContext [
	parent := anEvaluationContext.
	(isBlock not and: [self framesCount > 1000])
		ifTrue: [ self halt ].
]

{ #category : 'visiting' }
LinkedEvaluationContext >> receiver [
	^_self
]

{ #category : 'accessing' }
LinkedEvaluationContext >> secondArgument [
	^ arguments at: 2
]

{ #category : 'visiting' }
LinkedEvaluationContext >> self [
	^ _self
]

{ #category : 'visiting' }
LinkedEvaluationContext >> self: anObject [
	_self := anObject
]

{ #category : 'visiting' }
LinkedEvaluationContext >> stackTemporaryAt: index [
	^ temporaries at: index
]

{ #category : 'visiting' }
LinkedEvaluationContext >> stackTemporaryAt: index put: value [
	^temporaries at: index put: value
	
]

{ #category : 'visiting' }
LinkedEvaluationContext >> temporaryAt: index in: environmentIndex [
	| env |
	environmentIndex ifNil: [ ^ self stackTemporaryAt: index ].
	env := self environmentFor: environmentIndex.
	^ env at: index
]

{ #category : 'visiting' }
LinkedEvaluationContext >> temporaryAt: index in: environmentIndex put: value [
	| env |
	environmentIndex ifNil: [ ^ self stackTemporaryAt: index put: value ].
	env := self environmentFor: environmentIndex.
	^ env at: index put: value
]

{ #category : 'accessing' }
LinkedEvaluationContext >> thirdArgument [
	^ arguments at: 3
]
