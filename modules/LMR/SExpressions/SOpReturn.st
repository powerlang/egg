Class {
	#name : #SOpReturn,
	#superclass : #SOperation,
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #visiting }
SOpReturn >> acceptVisitor: visitor [
	^ visitor visitOpReturn: self
]
