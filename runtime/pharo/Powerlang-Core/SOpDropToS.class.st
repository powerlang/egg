Class {
	#name : 'SOpDropToS',
	#superclass : 'SOperation',
	#instVars : [
		'count'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SOpDropToS >> acceptVisitor: visitor [
	^ visitor visitOpDropToS: self
]

{ #category : 'visiting' }
SOpDropToS >> count [
	^count
]

{ #category : 'visiting' }
SOpDropToS >> count: anInteger [
	count := anInteger 
]
