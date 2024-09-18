Class {
	#name : 'SOpLoadRwithSelf',
	#superclass : 'SOperation',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SOpLoadRwithSelf >> acceptVisitor: visitor [
	^ visitor visitOpLoadRwithSelf: self
]
