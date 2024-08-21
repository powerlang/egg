Class {
	#name : 'SOpJumpTrue',
	#superclass : 'SOpJump',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SOpJumpTrue >> acceptVisitor: visitor [
	^ visitor visitOpJumpTrue: self
]
