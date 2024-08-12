Class {
	#name : #SLiteralBinding,
	#superclass : #SBinding,
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #unclassified }
SLiteralBinding class >> decodeUsing: aTreecodeDecoder [
	^self new
]

{ #category : #testing }
SLiteralBinding >> isLiteral [
	^true
]
