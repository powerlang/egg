Class {
	#name : 'SOpJumpFalse',
	#superclass : 'SOpJump',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SOpJumpFalse >> acceptVisitor: visitor [
	^ visitor visitOpJumpFalse: self
]
