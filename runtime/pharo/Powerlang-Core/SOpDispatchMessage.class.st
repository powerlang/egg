Class {
	#name : 'SOpDispatchMessage',
	#superclass : 'SOperation',
	#instVars : [
		'message'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'accessing' }
SOpDispatchMessage >> acceptVisitor: visitor [
	^ visitor visitOpDispatchMessage: self
]

{ #category : 'accessing' }
SOpDispatchMessage >> message [
	^ message
]

{ #category : 'accessing' }
SOpDispatchMessage >> message: anSMessage [
	message := anSMessage
]
