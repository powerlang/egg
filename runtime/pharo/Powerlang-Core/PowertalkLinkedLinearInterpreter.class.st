Class {
	#name : #PowertalkLinkedLinearInterpreter,
	#superclass : #PowertalkIterativeLinkedInterpreter,
	#instVars : [
		'linearizer'
	],
	#category : #'Powerlang-Core-Execution'
}

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> evaluate [
	| operation |
	[ operation := context nextOperation. operation notNil]
		whileTrue: [ 			operation acceptVisitor: self ].
	Transcript print: 'MessageCount: ' , messageCount asString; cr.
	^ regR
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> evaluationContextClass [
	^ LinkedLinearEvaluationContext
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> initialize [
	super initialize.
	linearizer := SExpressionLinearizer new.

]

{ #category : #private }
PowertalkLinkedLinearInterpreter >> initializeExecutableCodeOf: method [

	^ self initializeLinearExecutableCodeOf: method
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> initializePrimitives [
	super initializePrimitives.
	linearizer primitives: primitives
]

{ #category : #private }
PowertalkLinkedLinearInterpreter >> linearizer [
	^linearizer
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> prepareDispatch: dispatch [
	context work:  {dispatch}
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> prepareForBlock: sblock [
	| operations |
	operations := sblock optimizedCode.
	context work: operations; restart .
	^ nilObj
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> prepareForExecuting: method [
| work |
work := self prepareForExecuting: method.
	context work: work
]

{ #category : #initializing }
PowertalkLinkedLinearInterpreter >> runtime: aPowertalkRuntime [
	super runtime: aPowertalkRuntime.
	linearizer runtime: aPowertalkRuntime
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> underprimitiveRestart [
	^ [ :receiver :arguments | 
	context
		restart]
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> visitOpJump: anSOpJump [
	context regPC: anSOpJump target + 1
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> visitOpJumpFalse: anSOpJumpFalse [
	regR == falseObj
		ifTrue: [ context regPC: anSOpJumpFalse target+1 ]
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> visitOpJumpTrue: anSOpJumpTrue [
	regR == trueObj
		ifTrue: [ context regPC: anSOpJumpTrue target +1]
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> visitOpPopR: anSOpPopR [
	regR := context popOperand
]

{ #category : #visiting }
PowertalkLinkedLinearInterpreter >> visitOpPrimitive: anSOpPrimtive [
	regR := anSOpPrimtive block value
]
