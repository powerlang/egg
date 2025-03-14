"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPParser,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPParser class >> named: aString [
	^ self new name: aString
]

{ #category : #parsing }
PPParser class >> parse: anObject for: requestor [
	^self parse: anObject
]

{ #category : #operations }
PPParser >> & aParser [
	^PPSequencedChoiceParser with: self with: aParser
]

{ #category : #operations }
PPParser >> , aParser [
	"Answer a new parser that parses the receiver followed by aParser."

	^ PPSequenceParser with: self with: aParser
]

{ #category : #operations }
PPParser >> / aParser [
	"Answer a new parser that parses the receiver, if the receiver fails try with aParser (ordered-choice)."

	^ PPChoiceParser with: self with: aParser
]

{ #category : #operations }
PPParser >> | aParser [
	"Answer a new parser that either parses the receiver or aParser. Fail if both pass or fail (exclusive choice, unordered choice)."

	^ (self not , aParser) / (aParser not , self) ==> #second
]

{ #category : #'operations-mapping' }
PPParser >> ==> aBlock [
	"Answer a new parser that performs aBlock as action handler on success."

	^ PPActionParser on: self block: aBlock
]

{ #category : #'operations-mapping' }
PPParser >> >=> aBlock [
	"Answer a new parser that wraps the receiving parser with a two argument block. The first argument is the parsed stream, the second argument a continuation block on the delegate parser."

	^ PPWrappingParser on: self block: aBlock
]

{ #category : #operations }
PPParser >> and [
	"Answer a new parser (logical and-predicate) that succeeds whenever the receiver does, but never consumes input."

	^ PPAndParser on: self
]

{ #category : #'operations-mapping' }
PPParser >> answer: anObject [
	"Answer a new parser that always returns anObject from a successful parse."

	^ self ==> [ :nodes | anObject ]
]

{ #category : #converting }
PPParser >> asParser [
	^ self
]

{ #category : #accessing }
PPParser >> children [
	"Answer a set of child parsers that could follow the receiver."

	^ #()
]

{ #category : #operations }
PPParser >> def: aParser [
	"Redefine the receiver as the argument aParser. This method is useful when defining recursive parsers: instantiate a PPParser and later redefine it with another one."

	^ self become: (aParser name: self name)
]

{ #category : #'operations-convenience' }
PPParser >> delimitedBy: aParser [
	"Answer a new parser that parses the receiver one or more times, separated and possibly ended by aParser."
	
	^ (self separatedBy: aParser) , (aParser optional) ==> [ :node |
		node second isNil
			ifTrue: [ node first ]
			ifFalse: [ node first copyWith: node second ] ]
]

{ #category : #operations }
PPParser >> end [
	"Answer a new parser that succeeds at the end of the input and return the result of the receiver."

	^ PPEndOfInputParser on: self
]

{ #category : #'operations-mapping' }
PPParser >> flatten [
	"Answer a new parser that flattens the underlying collection."

	^ PPFlattenParser on: self
]

{ #category : #'operations-mapping' }
PPParser >> foldLeft: aBlock [
	"Answer a new parser that that folds the result of the receiver from left-to-right into aBlock. The argument aBlock must take two or more arguments."
	
	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: 1 put: (nodes at: 1).
		2 to: nodes size by: size - 1 do: [ :index |
			args
				replaceFrom: 2 to: size with: nodes startingAt: index;
				at: 1 put: (aBlock valueWithArguments: args) ].
		args at: 1 ]
]

{ #category : #'operations-mapping' }
PPParser >> foldRight: aBlock [
	"Answer a new parser that that folds the result of the receiver from right-to-left into aBlock. The argument aBlock must take two or more arguments."

	| size args |
	size := aBlock numArgs.
	args := Array new: size.
	^ self ==> [ :nodes |
		args at: size put: (nodes at: nodes size).
		nodes size - size + 1 to: 1 by: 1 - size do: [ :index |
			args
				replaceFrom: 1 to: size - 1 with: nodes startingAt: index;
				at: size put: (aBlock valueWithArguments: args) ].
		args at: size ]
]

{ #category : #'accessing-properties' }
PPParser >> hasProperty: aKey [
	"Test if the property aKey is present."

	^ properties notNil and: [ properties includesKey: aKey ]
]

{ #category : #initialization }
PPParser >> initialize [

]

{ #category : #testing }
PPParser >> isPetitParser [
	^ true
]

{ #category : #testing }
PPParser >> isUnresolved [
	^ false
]

{ #category : #'operations-mapping' }
PPParser >> map: aBlock [
	"Answer a new parser that works on the receiving sequence an passes in each element as a block argument."
	
	^ self ==> aBlock
]

{ #category : #parsing }
PPParser >> matches: anObject [
	"Answer if anObject can be parsed by the receiver."

	^ (self parse: anObject) isPetitFailure not
]

{ #category : #parsing }
PPParser >> matchesIn: anObject [
	"Search anObject repeatedly for the matches of the receiver."

	| result |
	result := OrderedCollection new.
	self
		matchesIn: anObject
		do: [ :each | result addLast: each ].
	^ result
]

{ #category : #parsing }
PPParser >> matchesIn: anObject do: aBlock [
	"Search anObject repeatedly for the matches of the receiver. Evaluate aBlock for each match with the matched parse-tree as the argument. Make sure to always consume exactly one character with each step, to not miss any match."

	((self and ==> aBlock , #any asParser) / #any asParser) star parse: anObject
]

{ #category : #parsing }
PPParser >> matchingRangesIn: anObject [
	"Search anObject repeatedly for the matches of the receiver.  Answer an OrderedCollection of ranges of each match (index of first character to: index of last character)."

	| result |
	result := OrderedCollection new.
	[ :stream | stream position + 1 ] asParser , self , [ :stream | stream position ] asParser
		matchesIn: anObject
		do: [ :value | result addLast: (value first to: value last) ].
	^ result
]

{ #category : #operations }
PPParser >> max: anInteger [
	"Answer a new parser that parses the receiver at most anInteger times."

	^ PPRepeatingParser on: self max: anInteger
]

{ #category : #operations }
PPParser >> memoized [
	"Answer a new memoized parser, for refraining redundant computations. This ensures polynomial time O(n^4) for left-recursive grammars and O(n^3) for non left-recursive grammars in the worst case. Not necessary for most grammars that are carefully written and in O(n) anyway."

	^ PPMemoizedParser on: self
]

{ #category : #operations }
PPParser >> min: anInteger [
	"Answer a new parser that parses the receiver at least anInteger times."

	^ PPRepeatingParser on: self min: anInteger
]

{ #category : #operations }
PPParser >> min: aMinInteger max: aMaxInteger [
	"Answer a new parser that parses the receiver at least aMinInteger and at most aMaxInteger times."

	^ PPRepeatingParser on: self min: aMinInteger max: aMaxInteger
]

{ #category : #accessing }
PPParser >> name [
	"Answer the production name of the receiver."

	^ self propertyAt: #name ifAbsent: [ nil ]
]

{ #category : #accessing }
PPParser >> name: aString [
	self propertyAt: #name put: aString
]

{ #category : #operations }
PPParser >> negate [
	"Answer a new parser consumes any input token but the receiver."
	
	^ self not , #any asParser ==> #second
]

{ #category : #operations }
PPParser >> newline [
	^Character lf asParser
		/ (Character cr asParser , Character lf asParser optional)
		==> [:nodes | 
			(nodes size = 2 and: [nodes last isNil])
				ifTrue: [nodes first]
				ifFalse: [nodes]]
]

{ #category : #operations }
PPParser >> not [
	"Answer a new parser (logical not-predicate) that succeeds whenever the receiver fails, but never consumes input."

	^ PPNotParser on: self
]

{ #category : #operations }
PPParser >> optional [
	"Answer a new parser that parses the receiver, if possible."

	^ PPOptionalParser on: self
]

{ #category : #parsing }
PPParser >> parse: anObject [
	| stream result |
	stream := anObject asPetitStream.
	result := self parseOn: stream.
	result isPetitFailure ifTrue: [^stream failure ifNil: [result]].
	^result
]

{ #category : #parsing }
PPParser >> parse: anObject onError: aBlock [
	"Parse anObject with the receiving parser and answer the parse-result or answer the result of evaluating aBlock. Depending on the number of arguments of the block it is simply evaluated, evaluated with the failure object, or evaluated with the error message and position."

	| result |
	result := self parseOn: anObject asPetitStream.
	result isPetitFailure
		ifFalse: [ ^ result ].
	aBlock numArgs = 0
		ifTrue: [ ^ aBlock value ].
	aBlock numArgs = 1
		ifTrue: [ ^ aBlock value: result ].
	^ aBlock value: result message value: result position
]

{ #category : #parsing }
PPParser >> parseOn: aStream [
	"Parse aStream with the receiving parser and answer the parse-result or an instance of PPFailure. Override this method in subclasses to specify custom parse behavior. Do not call this method from outside, instead use #parse:."

	self subclassResponsibility
]

{ #category : #operations }
PPParser >> plus [
	"Answer a new parser that parses the receiver one or more times."

	^ self min: 1
]

{ #category : #operations }
PPParser >> plusGreedy: aParser [
	"Answer a new parser that parses the receiver one or more times until it reaches aParser. This is a greedy non-blind implementation of the star operator. aParser is not consumed."

	^ self , (self starGreedy: aParser) map: [ :first :rest | rest copyWithFirst: first ]
]

{ #category : #operations }
PPParser >> plusLazy: aParser [
	"Answer a new parser that parses the receiver one or more times until it reaches aParser. This is a lazy non-blind implementation of the star operator. aParser is not consumed."

	^ self , (self starLazy: aParser) map: [ :first :rest | rest copyWithFirst: first ]
]

{ #category : #copying }
PPParser >> postCopy [
	super postCopy.
	properties := properties copy
]

{ #category : #printing }
PPParser >> printNameOn: aStream [
	self name isNil
		ifTrue: [ aStream print: self hash ]
		ifFalse: [ aStream nextPutAll: self name ]
]

{ #category : #printing }
PPParser >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printNameOn: aStream.
	aStream nextPut: $)
]

{ #category : #printing }
PPParser >> printSmalltalkReceiverOn: rtf [
	| text ast |
	text := Rtf new.
	self printTextOn: text.
	ast := SmalltalkParser new parseSnippet: '(' , text asString , ') msg'.
	(ast isNil or: [ast format trimBlanks first = $(])
		ifTrue: [
			rtf nextPut: $(.
			self printTextOn: rtf.
			rtf nextPut: $)]
		ifFalse: [self printTextOn: rtf]
]

{ #category : #printing }
PPParser >> printTextOn: rtf [
	| signature class |
	signature := self signature ifNil: [^super printTextOn: rtf].
	class := signature key classImplementing: signature value.
	class >> signature value printTextOn: rtf
]

{ #category : #'accessing-properties' }
PPParser >> propertyAt: aKey [
	"Answer the property value associated with aKey."

	^ self propertyAt: aKey ifAbsent: [ self error: 'Property not found' ]
]

{ #category : #'accessing-properties' }
PPParser >> propertyAt: aKey ifAbsent: aBlock [
	"Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."

	^ properties isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ properties at: aKey ifAbsent: aBlock ]
]

{ #category : #'accessing-properties' }
PPParser >> propertyAt: aKey ifAbsentPut: aBlock [
	"Answer the property associated with aKey or, if aKey isn't found store the result of evaluating aBlock as new value."

	^ self propertyAt: aKey ifAbsent: [ self propertyAt: aKey put: aBlock value ]
]

{ #category : #'accessing-properties' }
PPParser >> propertyAt: aKey put: anObject [
	"Set the property at aKey to be anObject. If aKey is not found, create a new entry for aKey and set is value to anObject. Answer anObject."

	^ (properties ifNil: [ properties := Dictionary new: 1 ])
		at: aKey put: anObject
]

{ #category : #'accessing-properties' }
PPParser >> removeProperty: aKey [
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."

	^ self removeProperty: aKey ifAbsent: [ self error: 'Property not found' ]
]

{ #category : #'accessing-properties' }
PPParser >> removeProperty: aKey ifAbsent: aBlock [
	"
	Remove the property with aKey. Answer the value or, if aKey isn't found, answer
	the result of evaluating aBlock.
	"
	| assoc |
	properties isNil ifTrue: [^aBlock value].
	assoc := properties associationAt: aKey ifAbsent: [^aBlock value].
	properties removeKey: aKey.
	properties isEmpty ifTrue: [properties := nil].
	^assoc value
]

{ #category : #'operations-convenience' }
PPParser >> separatedBy: aParser [
	"Answer a new parser that parses the receiver one or more times, separated by aParser."
	
	^ (PPSequenceParser with: self with: (PPSequenceParser with: aParser with: self) star) ==> [ :nodes |
		| result |
		result := Array new: 2 * nodes second size + 1.
		result at: 1 put: nodes first.
		nodes second 
			keysAndValuesDo: [ :index :pair | result replaceFrom: 2 * index to: 2 * index + 1 with: pair startingAt: 1 ].
		result ]
]

{ #category : #printing }
PPParser >> signature [
	^self propertyAt: #signature ifAbsent: nil
]

{ #category : #printing }
PPParser >> signature: anAssociation [
	self
		propertyAt: #signature put: anAssociation;
		name: anAssociation value
]

{ #category : #operations }
PPParser >> star [
	"Answer a new parser that parses the receiver zero or more times. This is a greedy and blind implementation that tries to consume as much input as possible and it does not consider what comes afterwards."

	^ PPRepeatingParser on: self
]

{ #category : #operations }
PPParser >> starGreedy: aParser [
	"
	Answer a new parser that parses the receiver zero or more times until it reaches aParser. This is a greedy non-blind implementation of the star operator. aParser is not consumed.
	"
	| parser |
	parser := PPChoiceParser new.
	parser
		setParsers: {self , parser
			map: [:each :rest | rest addFirst: each; yourself].
			aParser and ==> [:each | OrderedCollection new]}.
	^parser ==> [:rest | rest asArray]
]

{ #category : #operations }
PPParser >> starLazy: aParser [
	"
	Answer a new parser that parses the receiver zero or more times until it reaches aParser. This is a lazy non-blind implementation of the star operator. aParser is not consumed.
	"
	| parser |
	parser := PPChoiceParser new.
	parser
		setParsers: {aParser and ==> [:each | OrderedCollection new].
			self , parser map: [:each :rest | rest addFirst: each; yourself]}.
	^parser ==> [:rest | rest asArray]
]

{ #category : #operations }
PPParser >> times: anInteger [
	"Answer a new parser that parses the receiver exactly anInteger times."

	^ self min: anInteger max: anInteger
]

{ #category : #'operations-mapping' }
PPParser >> token [
	"Answer a new parser that transforms the input to a token."

	^ PPTokenParser on: self
]

{ #category : #'operations-mapping' }
PPParser >> token: aTokenClass [
	"Answer a new parser that transforms the input to a token of class aTokenClass."

	^ self token tokenClass: aTokenClass
]

{ #category : #'operations-mapping' }
PPParser >> trim [
	"Answer a new parser that consumes spaces before and after the receiving parser."

	^ self trimSpaces
]

{ #category : #'operations-mapping' }
PPParser >> trimBlanks [
	"Answer a new parser that consumes blanks before and after the receiving parser."

	^ PPTrimmingParser on: self trimmer: #blank asParser
]

{ #category : #'operations-mapping' }
PPParser >> trimSpaces [
	"Answer a new parser that consumes spaces before and after the receiving parser."

	^ PPTrimmingParser on: self trimmer: #space asParser
]

{ #category : #operations }
PPParser >> wrapped [
	"Answer a new parser that is simply wrapped."

	^ PPDelegateParser on: self
]

