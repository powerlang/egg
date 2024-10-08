Class {
	#name : 'SFalseBinding',
	#superclass : 'SLiteralBinding',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'printing' }
SFalseBinding >> printOn: aStream [
	aStream nextPutAll: 'FalseId'
]

{ #category : 'printing' }
SFalseBinding >> value [
	^false
]

{ #category : 'printing' }
SFalseBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext false
]
