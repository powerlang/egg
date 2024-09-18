Class {
	#name : 'SOpPushR',
	#superclass : 'SOperation',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SOpPushR >> acceptVisitor: visitor [
	^ visitor visitOpPushR: self
]
