Class {
	#name : #SOpLoadRfromStack,
	#superclass : #SOperation,
	#instVars : [
		'index'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #accessing }
SOpLoadRfromStack >> acceptVisitor: visitor [
	^ visitor visitOpLoadRfromStack: self
]

{ #category : #accessing }
SOpLoadRfromStack >> index [
	^index
]

{ #category : #accessing }
SOpLoadRfromStack >> index: anInteger [
	index := anInteger
]
