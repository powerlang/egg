Class {
	#name : 'SPragma',
	#superclass : 'SExpression',
	#instVars : [
		'name',
		'descriptor'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'accessing' }
SPragma >> descriptor [
	^descriptor
]

{ #category : 'accessing' }
SPragma >> descriptor: anFFIDescriptor [
	descriptor := anFFIDescriptor
]

{ #category : 'accessing' }
SPragma >> name [
	^ name
]

{ #category : 'accessing' }
SPragma >> name: aString [
	name := aString
]
