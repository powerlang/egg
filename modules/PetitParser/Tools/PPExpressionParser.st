"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPExpressionParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'operators'
	],
	#category : #Tools
}

{ #category : #private }
PPExpressionParser >> build: aParser left: aChoiceParser [
	^ (aParser separatedBy: aChoiceParser) foldLeft: [ :a :op :b | op first value: a value: op second value: b ]
]

{ #category : #private }
PPExpressionParser >> build: aParser postfix: aChoiceParser [
	^ aParser , aChoiceParser star map: [ :term :ops | ops inject: term into: [ :result :operator | operator first value: result value: operator second ] ]
]

{ #category : #private }
PPExpressionParser >> build: aParser prefix: aChoiceParser [
	^ aChoiceParser star , aParser map: [ :ops :term | ops reversed inject: term into: [ :result :operator | operator first value: operator second value: result ] ]
]

{ #category : #private }
PPExpressionParser >> build: aParser right: aChoiceParser [
	^ (aParser separatedBy: aChoiceParser) foldRight: [ :a :op :b | op first value: a value: op second value: b ]
]

{ #category : #private }
PPExpressionParser >> buildOn: aParser [
	^self buildSelectors
		inject: aParser
		into: [:term :selector | self buildTerm: term selector: selector]
]

{ #category : #private }
PPExpressionParser >> buildSelectors [
	^ #(build:prefix: build:postfix: build:right: build:left:)
]

{ #category : #private }
PPExpressionParser >> buildTerm: term selector: selector [
	| list |
	list := operators at: selector ifAbsent: [#()].
	^list isEmpty ifTrue: [term] ifFalse: [
		self perform: selector with: term with: (list size = 1
			ifTrue: [
				list first first ==> [:operator | 
					list isEmpty ifTrue: [self halt].
					{list first second. operator}]]
			ifFalse: [
				list
					inject: PPChoiceParser new
					into: [:choice :each | choice
						/ (each first ==> [:operator | {each second. operator}])]])]
]

{ #category : #specifying }
PPExpressionParser >> group: aOneArgumentBlock [
	"Defines a priority group by evaluating aOneArgumentBlock."
	
	operators := Dictionary new.
	parser := [ 
		aOneArgumentBlock value: self.
		self buildOn: parser ]
			ensure: [ operators := nil ]
]

{ #category : #specifying }
PPExpressionParser >> left: aParser do: aThreeArgumentBlock [
	"Define an operator aParser that is left-associative. Evaluate aThreeArgumentBlock with the first term, the operator, and the second term."
	
	self operator: #build:left: parser: aParser do: aThreeArgumentBlock
]

{ #category : #private }
PPExpressionParser >> operator: aSymbol parser: aParser do: aBlock [
	parser isNil
		ifTrue: [^self
			error: 'You did not specify a term when creating the receiver.'].
	operators isNil
		ifTrue: [^self
			error: 'Use #group: to define precedence groups in descending order.'].
	(operators at: aSymbol ifAbsentPut: [OrderedCollection new])
		addLast: {aParser asParser. aBlock}
]

{ #category : #specifying }
PPExpressionParser >> postfix: aParser do: aTwoArgumentBlock [
	"Define a postfix operator aParser. Evaluate aTwoArgumentBlock with the term and the operator."

	self operator: #build:postfix: parser: aParser do: aTwoArgumentBlock
]

{ #category : #specifying }
PPExpressionParser >> prefix: aParser do: aTwoArgumentBlock [
	"Define a prefix operator aParser. Evaluate aTwoArgumentBlock with the operator and the term."

	self operator: #build:prefix: parser: aParser do: aTwoArgumentBlock
]

{ #category : #specifying }
PPExpressionParser >> right: aParser do: aThreeArgumentBlock [
	"Define an operator aParser that is right-associative. Evaluate aThreeArgumentBlock with the first term, the operator, and the second term."
	
	self operator: #build:right: parser: aParser do: aThreeArgumentBlock
]

{ #category : #specifying }
PPExpressionParser >> term: aParser [
	"Defines the initial term aParser of the receiver."
	
	parser isNil
		ifTrue: [ parser := aParser ]
		ifFalse: [ self error: 'Unable to redefine the term.' ]
]

