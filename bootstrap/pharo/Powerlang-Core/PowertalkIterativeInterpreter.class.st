Class {
	#name : #PowertalkIterativeInterpreter,
	#superclass : #PowertalkEvaluator,
	#instVars : [
		'regR'
	],
	#category : #'Powerlang-Core-Execution'
}

{ #category : #accessing }
PowertalkIterativeInterpreter >> evaluate [
	^self subclassResponsibility

]

{ #category : #accessing }
PowertalkIterativeInterpreter >> hasFinished [
	^ context hasFinished
]

{ #category : #initializing }
PowertalkIterativeInterpreter >> initializeUndermessages [
	super initializeUndermessages.
	undermessages 		at: #_restart put: self underprimitiveRestart
	
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> prepareDispatch: dispatch [
	self subclassResponsibility
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> prepareForBlock: sblock [
	^self subclassResponsibility	
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> regR: anObject [ 
	regR := anObject
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> unboundAssignment: aBinding with: assignees [
			assignees size > 1 ifTrue: [ 
				self error:
					'unbound name with multiple assignments not yet supported' ].
			self doesNotKnow: aBinding name assigned: regR
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> underprimitiveRestart [
	^ self subclassResponsibility 
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitBlock: anSBlock [
	regR := context captureClosure: anSBlock
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitIdentifier: anSIdentifier [
	| binding |
	binding := anSIdentifier binding.
	regR := binding valueWithin: context ifUnbound: [ ^self doesNotKnow: binding name ]
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitLiteral: anSLiteral [
	regR := runtime literalFor: anSLiteral value
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpAssign: anSOpAssign [

	| assignees binding |
	assignees := anSOpAssign assignees.
	assignees do: [ :identifier | 
		binding := identifier binding.
		binding
			assign: regR
			within: context
			ifUnbound: [ self unboundAssignment: binding with: assignees ] ]
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpDropToS: anSOpDropToS [
	context dropOperands: anSOpDropToS count
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpLoadRfromFrame: anSOpLoadRfromFrame [
	regR := context stackTemporaryAt: anSOpLoadRfromFrame index
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpLoadRfromStack: anSOpLoadRfromStack [
	regR := context operandAt: anSOpLoadRfromStack index
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpLoadRwithNil: anSOpLoadRwithNil [
	regR := nilObj
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpLoadRwithSelf: anSOpLoadRwithSelf [
	regR := context self
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpPushR: anSOpPushR [
	context pushOperand: regR
]

{ #category : #accessing }
PowertalkIterativeInterpreter >> visitOpStoreRintoFrame: anSOpStoreRintoFrame [
	context stackTemporaryAt: anSOpStoreRintoFrame index put: regR
]
