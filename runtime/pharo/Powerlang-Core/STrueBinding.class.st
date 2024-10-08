Class {
	#name : 'STrueBinding',
	#superclass : 'SLiteralBinding',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'printing' }
STrueBinding >> printOn: aStream [
	aStream nextPutAll: 'TrueId'
]

{ #category : 'printing' }
STrueBinding >> value [
	^true
]

{ #category : 'printing' }
STrueBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext true
]
