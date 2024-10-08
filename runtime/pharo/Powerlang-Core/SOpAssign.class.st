Class {
	#name : 'SOpAssign',
	#superclass : 'SOperation',
	#instVars : [
		'assignees'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'accessing' }
SOpAssign >> acceptVisitor: visitor [
	^ visitor visitOpAssign: self
]

{ #category : 'accessing' }
SOpAssign >> assignees [
	^assignees
]

{ #category : 'accessing' }
SOpAssign >> assignees: aCollection [
	assignees := aCollection
]
