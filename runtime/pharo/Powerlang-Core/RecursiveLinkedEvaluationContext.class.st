Class {
	#name : 'RecursiveLinkedEvaluationContext',
	#superclass : 'LinkedEvaluationContext',
	#instVars : [
		'nonLocalReturn'
	],
	#category : 'Powerlang-Core-Execution',
	#package : 'Powerlang-Core',
	#tag : 'Execution'
}

{ #category : 'as yet unclassified' }
RecursiveLinkedEvaluationContext >> evaluateFor: interpreter [

	| sexpressions result |
	nonLocalReturn := [ :value | 
	                  interpreter context: self homeContext parent.
	                  ^ value ].
	sexpressions := interpreter prepareForExecuting: method.
	result := interpreter visitMethod: sexpressions.
	interpreter context: self parent.
	^ result
]

{ #category : 'as yet unclassified' }
RecursiveLinkedEvaluationContext >> return: anObject [
	^self isBlock
		ifTrue: [ nonLocalReturn value: anObject ]
		ifFalse: [ anObject ]
]
