Class {
	#name : #SOpNonLocalReturn,
	#superclass : #SOpReturn,
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #visiting }
SOpNonLocalReturn >> acceptVisitor: visitor [
	^ visitor visitOpNonLocalReturn: self
]
