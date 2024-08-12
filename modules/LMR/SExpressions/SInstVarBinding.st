Class {
	#name : #SInstVarBinding,
	#superclass : #SBinding,
	#instVars : [
		'index'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #unclassified }
SInstVarBinding class >> decodeUsing: aTreecodeDecoder [
	^aTreecodeDecoder decodeInstVar
]

{ #category : #testing }
SInstVarBinding >> assign: value within: anEvaluationContext [
	anEvaluationContext instanceVarAt: index put: value
]

{ #category : #accessing }
SInstVarBinding >> index [
	^index
]

{ #category : #accessing }
SInstVarBinding >> index: anInteger [
	index := anInteger
]

{ #category : #testing }
SInstVarBinding >> isInstVar [
	^true
]

{ #category : #testing }
SInstVarBinding >> printOn: aStream [
	aStream nextPutAll: 'InstVarId. '; nextPutAll: index printString
]

{ #category : #accessing }
SInstVarBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext instanceVarAt: index
]
