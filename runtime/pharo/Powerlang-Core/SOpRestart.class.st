Class {
	#name : 'SOpRestart',
	#superclass : 'SOperation',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SOpRestart >> acceptVisitor: visitor [
	^ visitor visitOpRestart: self
]
