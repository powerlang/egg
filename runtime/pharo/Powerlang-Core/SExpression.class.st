"
I am a Smalltalk expression, the minimal unit of Smalltalk semantics, expressed as a tree
"
Class {
	#name : 'SExpression',
	#superclass : 'Object',
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'visiting' }
SExpression >> acceptVisitor: visitor [
	^self subclassResponsibility
]

{ #category : 'visiting' }
SExpression >> isAssignment [
	^false
]

{ #category : 'visiting' }
SExpression >> isCascade [
	^false
]

{ #category : 'visiting' }
SExpression >> isCascadeMessage [
	^false
]

{ #category : 'visiting' }
SExpression >> isIdentifier [
	^false
]

{ #category : 'testing' }
SExpression >> isInstVar [
	^false
]

{ #category : 'visiting' }
SExpression >> isLiteral [
	^false
]

{ #category : 'visiting' }
SExpression >> isMessage [
	^false
]

{ #category : 'testing' }
SExpression >> isMethod [
	^false
]

{ #category : 'visiting' }
SExpression >> isReturn [
	^false
]

{ #category : 'visiting' }
SExpression >> isSuper [
	^ false
]

{ #category : 'testing' }
SExpression >> printOn: aStream [
	self printOn: aStream indent: 0
]

{ #category : 'testing' }
SExpression >> printOn: aStream indent: anInteger [
	super printOn: aStream
]
