'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPExpressionParser category: #Tools!
PPDelegateParser subclass: #PPExpressionParser
	instanceVariableNames: 'operators'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools'!
!PPExpressionParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
build: aParser left: aChoiceParser
	^ (aParser separatedBy: aChoiceParser) foldLeft: [ :a :op :b | op first value: a value: op second value: b ]
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
build: aParser postfix: aChoiceParser
	^ aParser , aChoiceParser star map: [ :term :ops | ops inject: term into: [ :result :operator | operator first value: result value: operator second ] ]
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
build: aParser prefix: aChoiceParser
	^ aChoiceParser star , aParser map: [ :ops :term | ops reversed inject: term into: [ :result :operator | operator first value: operator second value: result ] ]
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
build: aParser right: aChoiceParser
	^ (aParser separatedBy: aChoiceParser) foldRight: [ :a :op :b | op first value: a value: op second value: b ]
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
buildOn: aParser
	^self buildSelectors
		inject: aParser
		into: [:term :selector | self buildTerm: term selector: selector]
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
buildSelectors
	^ #(build:prefix: build:postfix: build:right: build:left:)
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
buildTerm: term selector: selector
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
! !

!PPExpressionParser methodsFor:  'specifying' stamp: 'KenD 28/Jun/2026 13:27:39'!
group: aOneArgumentBlock
	"Defines a priority group by evaluating aOneArgumentBlock."
	
	operators := Dictionary new.
	parser := [ 
		aOneArgumentBlock value: self.
		self buildOn: parser ]
			ensure: [ operators := nil ]
! !

!PPExpressionParser methodsFor:  'specifying' stamp: 'KenD 28/Jun/2026 13:27:39'!
left: aParser do: aThreeArgumentBlock
	"Define an operator aParser that is left-associative. Evaluate aThreeArgumentBlock with the first term, the operator, and the second term."
	
	self operator: #build:left: parser: aParser do: aThreeArgumentBlock
! !

!PPExpressionParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
operator: aSymbol parser: aParser do: aBlock
	parser isNil
		ifTrue: [^self
			error: 'You did not specify a term when creating the receiver.'].
	operators isNil
		ifTrue: [^self
			error: 'Use #group: to define precedence groups in descending order.'].
	(operators at: aSymbol ifAbsentPut: [OrderedCollection new])
		addLast: {aParser asParser. aBlock}
! !

!PPExpressionParser methodsFor:  'specifying' stamp: 'KenD 28/Jun/2026 13:27:39'!
postfix: aParser do: aTwoArgumentBlock
	"Define a postfix operator aParser. Evaluate aTwoArgumentBlock with the term and the operator."

	self operator: #build:postfix: parser: aParser do: aTwoArgumentBlock
! !

!PPExpressionParser methodsFor:  'specifying' stamp: 'KenD 28/Jun/2026 13:27:39'!
prefix: aParser do: aTwoArgumentBlock
	"Define a prefix operator aParser. Evaluate aTwoArgumentBlock with the operator and the term."

	self operator: #build:prefix: parser: aParser do: aTwoArgumentBlock
! !

!PPExpressionParser methodsFor:  'specifying' stamp: 'KenD 28/Jun/2026 13:27:39'!
right: aParser do: aThreeArgumentBlock
	"Define an operator aParser that is right-associative. Evaluate aThreeArgumentBlock with the first term, the operator, and the second term."
	
	self operator: #build:right: parser: aParser do: aThreeArgumentBlock
! !

!PPExpressionParser methodsFor:  'specifying' stamp: 'KenD 28/Jun/2026 13:27:39'!
term: aParser
	"Defines the initial term aParser of the receiver."
	
	parser isNil
		ifTrue: [ parser := aParser ]
		ifFalse: [ self error: 'Unable to redefine the term.' ]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPExpressionParser class' category: #Tools!
PPExpressionParser class
	instanceVariableNames: ''!


