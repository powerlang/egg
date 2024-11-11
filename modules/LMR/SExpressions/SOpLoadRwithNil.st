Class {
	#name : #SOpLoadRwithNil,
	#superclass : #SOperation,
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #visiting }
SOpLoadRwithNil >> acceptVisitor: visitor [
	^ visitor visitOpLoadRwithNil: self
]
