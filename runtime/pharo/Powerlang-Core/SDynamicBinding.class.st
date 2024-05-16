Class {
	#name : #SDynamicBinding,
	#superclass : #SBinding,
	#instVars : [
		'name',
		'cache'
	],
	#category : #'Powerlang-Core-SExpressions'
}

{ #category : #unclassified }
SDynamicBinding class >> decodeUsing: anAstcodeDecoder [
	^ anAstcodeDecoder decodeDynamicVar
]

{ #category : #accessing }
SDynamicBinding >> assign: value within: anEvaluationContext ifUnbound: aClosure [

	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache ifNil: [ ^ aClosure value ].
	cache assign: value within: anEvaluationContext
]

{ #category : #accessing }
SDynamicBinding >> isDynamic [
	^true
]

{ #category : #accessing }
SDynamicBinding >> lookupWithin: anEvaluationContext [
	cache := anEvaluationContext staticBindingFor: name
]

{ #category : #accessing }
SDynamicBinding >> name [ ^
	name
]

{ #category : #accessing }
SDynamicBinding >> name: aSymbol [
	name := aSymbol
]

{ #category : #accessing }
SDynamicBinding >> printOn: aStream [
	aStream
		nextPutAll: 'DinamicVarId. ';
		nextPutAll: name printString
]

{ #category : #accessing }
SDynamicBinding >> valueWithin: anEvaluationContext ifUnbound: aClosure [

	cache ifNil: [ self lookupWithin: anEvaluationContext ].
	cache ifNil: [ ^ aClosure value ].
	^ cache valueWithin: anEvaluationContext
]
