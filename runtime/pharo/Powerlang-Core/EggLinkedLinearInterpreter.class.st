Class {
	#name : 'EggLinkedLinearInterpreter',
	#superclass : 'EggIterativeLinkedInterpreter',
	#instVars : [
		'linearizer'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> evaluate [
	| operation |
	[ operation := context nextOperation. operation notNil]
		whileTrue: [ 			operation acceptVisitor: self ].
	Transcript print: 'MessageCount: ' , messageCount asString; cr.
	^ regR
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> evaluationContextClass [
	^ LinkedLinearEvaluationContext
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> initialize [
	super initialize.
	linearizer := SExpressionLinearizer new.

]

{ #category : 'private' }
EggLinkedLinearInterpreter >> initializeExecutableCodeOf: method [

	^ self initializeLinearExecutableCodeOf: method
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> initializePrimitives [
	super initializePrimitives.
	linearizer primitives: primitives
]

{ #category : 'private' }
EggLinkedLinearInterpreter >> linearizer [
	^linearizer
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> prepareDispatch: dispatch [
	context work:  {dispatch}
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> prepareForBlock: sblock [
	| operations |
	operations := sblock optimizedCode.
	context work: operations; restart .
	^ nilObj
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> prepareForExecuting: method [
| work |
work := self prepareForExecuting: method.
	context work: work
]

{ #category : 'initializing' }
EggLinkedLinearInterpreter >> runtime: anEggRuntime [
	super runtime: anEggRuntime.
	linearizer runtime: anEggRuntime
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> underprimitiveRestart [
	^ [ :receiver :arguments | 
	context
		restart]
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> visitOpJump: anSOpJump [
	context regPC: anSOpJump target + 1
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> visitOpJumpFalse: anSOpJumpFalse [
	regR == falseObj
		ifTrue: [ context regPC: anSOpJumpFalse target+1 ]
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> visitOpJumpTrue: anSOpJumpTrue [
	regR == trueObj
		ifTrue: [ context regPC: anSOpJumpTrue target +1]
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> visitOpPopR: anSOpPopR [
	regR := context popOperand
]

{ #category : 'visiting' }
EggLinkedLinearInterpreter >> visitOpPrimitive: anSOpPrimtive [
	regR := anSOpPrimtive block value
]
