Class {
	#name : 'SLiteral',
	#superclass : 'SLiteralVar',
	#instVars : [
		'value'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'initialization' }
SLiteral class >> decodeUsing: aTreecodeDecoder [
	^aTreecodeDecoder decodeLiteral
]

{ #category : 'visiting' }
SLiteral >> acceptVisitor: visitor [
	^ visitor visitLiteral: self
]

{ #category : 'visiting' }
SLiteral >> isLiteral [
	^true
]

{ #category : 'testing' }
SLiteral >> printOn: aStream indent: anInteger [
	aStream
		tab: anInteger;
		nextPutAll: '{LiteralId. ';
		print: value;
		nextPutAll: '}'
]

{ #category : 'visiting' }
SLiteral >> value [
	^value
]

{ #category : 'visiting' }
SLiteral >> value: anObject [
	value := anObject
]
