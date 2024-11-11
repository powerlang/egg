Class {
	#name : #SOpPopR,
	#superclass : #SInlinerOperation,
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #visiting }
SOpPopR >> acceptVisitor: visitor [
	^ visitor visitOpPopR: self
]
