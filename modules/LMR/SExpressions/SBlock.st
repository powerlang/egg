Class {
	#name : #SBlock,
	#superclass : #SScript,
	#instVars : [
		'index',
		'capturedVariables',
		'inlinedArgs',
		'parent'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : #unclassified }
SBlock class >> decodeUsing: aTreecodeDecoder [
	^aTreecodeDecoder decodeBlock
]

{ #category : #visiting }
SBlock >> acceptVisitor: visitor [
	^visitor visitBlock: self
]

{ #category : #accessing }
SBlock >> capturedVariables [
	^capturedVariables
]

{ #category : #accessing }
SBlock >> capturedVariables: aCollection [
	capturedVariables := aCollection
]

{ #category : #accessing }
SBlock >> capturesHome [
	^compiledCode capturesHome
]

{ #category : #accessing }
SBlock >> index [
	^index
]

{ #category : #accessing }
SBlock >> index: anInteger [
	index := anInteger
]

{ #category : #initialization }
SBlock >> initialize [
	capturedVariables := #()
]

{ #category : #accessing }
SBlock >> inlinedArgs [
	^ inlinedArgs
]

{ #category : #accessing }
SBlock >> inlinedArgs: anArray [
	inlinedArgs:= anArray 
]

{ #category : #initialization }
SBlock >> isBlock [
	^true
]

{ #category : #initialization }
SBlock >> isInlined [
	^ compiledCode isNil
]

{ #category : #accessing }
SBlock >> parent [
	^parent
]

{ #category : #accessing }
SBlock >> parent: anSScript [
	parent := anSScript
]

{ #category : #accessing }
SBlock >> offsetOfEnvironment: anInteger [
	| stream count type position |
	stream := capturedVariables readStream.
	count := 0.
	[stream atEnd] whileFalse: [
		type := stream next.
		position := (type = 0 or: [type = 2]) ifFalse: [stream next].
		count := count + 1.
		count = anInteger ifTrue: [
			type = 2 ifTrue: [^parent offsetOfCurrentEnvironment].
			type = 3 ifTrue: [^parent offsetOfEnvironment: position].
			^self error: 'the closure keeps no environment there']].
	^self error: 'the closure keeps no environment there'
]

{ #category : #accessing }
SBlock >> offsetOfCurrentEnvironment [
	^ 2
]

{ #category : #accessing }
SBlock >> optimizedCode [
	^compiledCode optimizedCode
]

{ #category : #unclassified }
SBlock >> printOn: aStream indent: anInteger [
	aStream
		tab: anInteger;
		nextPutAll: '{BlockId. capturedVariables: ';
		print: capturedVariables;
		cr.
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
]
