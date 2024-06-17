Class {
	#name : #EggIterativeInterpreter,
	#superclass : #EggEvaluator,
	#instVars : [
		'regR'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : #accessing }
EggIterativeInterpreter >> evaluate [
	^self subclassResponsibility

]

{ #category : #accessing }
EggIterativeInterpreter >> hasFinished [
	^ context hasFinished
]

{ #category : #initializing }
EggIterativeInterpreter >> initializeUndermessages [
	super initializeUndermessages.
	undermessages 		at: #_restart put: self underprimitiveRestart
	
]

{ #category : #accessing }
EggIterativeInterpreter >> prepareDispatch: dispatch [
	self subclassResponsibility
]

{ #category : #accessing }
EggIterativeInterpreter >> prepareForBlock: sblock [
	^self subclassResponsibility	
]

{ #category : #accessing }
EggIterativeInterpreter >> regR: anObject [ 
	regR := anObject
]

{ #category : #accessing }
EggIterativeInterpreter >> unboundAssignment: aBinding with: assignees [
			assignees size > 1 ifTrue: [ 
				self error:
					'unbound name with multiple assignments not yet supported' ].
			self doesNotKnow: aBinding name assigned: regR
]

{ #category : #accessing }
EggIterativeInterpreter >> underprimitiveRestart [
	^ self subclassResponsibility 
]

{ #category : #accessing }
EggIterativeInterpreter >> visitBlock: anSBlock [
	regR := context captureClosure: anSBlock
]

{ #category : #accessing }
EggIterativeInterpreter >> visitIdentifier: anSIdentifier [
	| binding |
	binding := anSIdentifier binding.
	regR := binding valueWithin: context ifUnbound: [ ^self doesNotKnow: binding name ]
]

{ #category : #accessing }
EggIterativeInterpreter >> visitLiteral: anSLiteral [
	regR := runtime literalFor: anSLiteral value
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpAssign: anSOpAssign [

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
EggIterativeInterpreter >> visitOpDropToS: anSOpDropToS [
	context dropOperands: anSOpDropToS count
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpLoadRfromFrame: anSOpLoadRfromFrame [
	regR := context stackTemporaryAt: anSOpLoadRfromFrame index
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpLoadRfromStack: anSOpLoadRfromStack [
	regR := context operandAt: anSOpLoadRfromStack index
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpLoadRwithNil: anSOpLoadRwithNil [
	regR := nilObj
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpLoadRwithSelf: anSOpLoadRwithSelf [
	regR := context self
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpPushR: anSOpPushR [
	context pushOperand: regR
]

{ #category : #accessing }
EggIterativeInterpreter >> visitOpStoreRintoFrame: anSOpStoreRintoFrame [
	context stackTemporaryAt: anSOpStoreRintoFrame index put: regR
]
