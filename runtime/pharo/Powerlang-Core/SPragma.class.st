Class {
	#name : 'SPragma',
	#superclass : 'SExpression',
	#instVars : [
		'name'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'accessing' }
SPragma >> name [
	^ name
]

{ #category : 'accessing' }
SPragma >> name: aString [
	name := aString
]
