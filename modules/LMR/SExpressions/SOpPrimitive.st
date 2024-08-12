Class {
	#name : #SOpPrimitive,
	#superclass : #SOperation,
	#instVars : [
		'block'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #visiting }
SOpPrimitive >> acceptVisitor: visitor [
	^ visitor visitOpPrimitive: self
]

{ #category : #accessing }
SOpPrimitive >> block [
	^block
]

{ #category : #accessing }
SOpPrimitive >> block: aBlockClosure [ 
	block := aBlockClosure
]
