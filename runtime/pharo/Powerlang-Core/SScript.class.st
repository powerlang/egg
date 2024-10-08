Class {
	#name : 'SScript',
	#superclass : 'SExpression',
	#instVars : [
		'statements',
		'compiledCode'
	],
	#category : 'Powerlang-Core-SExpressions',
	#package : 'Powerlang-Core',
	#tag : 'SExpressions'
}

{ #category : 'instance creation' }
SScript class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'printing' }
SScript >> argumentCount [
	^compiledCode argumentCount
]

{ #category : 'printing' }
SScript >> compiledCode [
	^compiledCode
]

{ #category : 'printing' }
SScript >> compiledCode: anObject [
	compiledCode := anObject
]

{ #category : 'printing' }
SScript >> initialize [
	statements := #()
]

{ #category : 'accessing' }
SScript >> optimizedCode: anObject [
	^ self compiledCode optimizedCode: anObject
]

{ #category : 'printing' }
SScript >> printOn: aStream indent: anInteger [
	statements
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'; cr]
]

{ #category : 'printing' }
SScript >> statements [
	^statements
]

{ #category : 'printing' }
SScript >> statements: aCollection [
	statements := aCollection
]

{ #category : 'printing' }
SScript >> tempCount [
	^compiledCode tempCount
]
