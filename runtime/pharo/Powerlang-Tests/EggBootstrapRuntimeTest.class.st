Class {
	#name : 'EggBootstrapRuntimeTest',
	#superclass : 'TestCase',
	#instVars : [
		'image',
		'runtime'
	],
	#category : 'Powerlang-Tests-Bootstrap',
	#package : 'Powerlang-Tests',
	#tag : 'Bootstrap'
}

{ #category : 'tests' }
EggBootstrapRuntimeTest >> ==> anObject [
	^image transferLiteralDeep: anObject
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> assertNoLeftoverFrames [
	self assert: runtime interpreter hasFinished
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> compile: aString in: classname during: aBlock [
	| class selector method |
	class := image => classname.
	method := SCompiler compile: aString in: class.
	class addReplacingMethod: method.
	self assert: method notNil.
	aBlock 		ensure: [ class removeMethod: method ]
]

{ #category : 'running' }
EggBootstrapRuntimeTest >> setUp [
	image := EggBootstrapImage fromSpec
		wordSize: 8;
		genesis.
	runtime := image runtime
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test100yourself [
	| result |
	result := runtime sendLocal: #yourself to: image nil.
	self assert: result equals: image nil
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test110compute1plus1 [
	| one result |
	one := self ==> 1.
	result := runtime sendLocal: #+ to: one with: {one}.
	self assert: result equals: self ==> 2; assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test111compute1minus1 [
	| one result |
	one := self ==> 1.
	result := runtime sendLocal: #- to: one with: {one}.
	self assert: result equals: self ==> 0
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test112compute3times4 [
	| result |
	result := runtime sendLocal: #* to: self ==> 3 with: {self ==> 4}.
	self assert: result equals: self ==> 12
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test113compute20quotient5 [
	|  result |

	result := runtime sendLocal: #// to: self ==>20 with: {self ==>5}.
	self assert: result equals: self ==>4
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test120sendSizeMinusOne [
	| result |
	self
		compile: 'foo ^#abc _size - 1'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 3 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test121sendCascade [
	| result |
	self
		compile: 'foo ^#abc yourself; size'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 3 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test130sendIfTrueToFalse [
	| result |
	self
		compile: 'foo ^false ifTrue: [#failed]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image nil ].
		
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test131sendIfFalseToTrue [
	| result |
	self
		compile: 'foo ^true ifFalse: [#failed]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image nil ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test132sendIfTrueToTrue [
	| result |
	self
		compile: 'foo ^true ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test133sendIfTrueToTrueAndTrue [
	| result |
	self
		compile: 'foo ^(true and: [true]) ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test134sendIfTrueToTrueAndFalse [
	| result |
	self
		compile: 'foo ^(true and: [false]) ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> nil ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test135sendIfTrueToFalseAndTrue [
	| result |
	self
		compile: 'foo ^(false and: [true]) ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> nil ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test136sendIfTrueToFalseOrTrue [
	| result |
	self
		compile: 'foo ^(false or: [true]) ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test137sendIfTrueToFalseOrFalse [
	| result |
	self
		compile: 'foo ^(false or: [false]) ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> nil ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test138sendIfTrueToTrueOrFalse [
	| result |
	self
		compile: 'foo ^(true or: [false]) ifTrue: [5]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNilIfNotNilToNil [
	| result |
	self
		compile: 'foo ^nil ifNil: [3] ifNotNil: [4]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 3 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNilIfNotNilToNotNil [
	| result |
	self
		compile: 'foo ^#abc ifNil: [3] ifNotNil: [4]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 4 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNilIfNotNilWithArg [
	| result |
	self
		compile: 'foo ^5 ifNil: [3] ifNotNil: [:a | a]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNilIfNotNilWithArgToNil [
	| result |
	self
		compile: 'foo ^nil ifNil: [3] ifNotNil: [:a | a]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 3 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNilToNil [
	| result |
	self
		compile: 'foo ^nil ifNil: [self]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image true ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNilToNotNil [
	| result |
	self
		compile: 'foo ^false ifNil: [self]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image false ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test139sendIfNotNilWithArg [
	| result |
	self
		compile: 'foo ^5 ifNotNil: [:a | a]'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test140evaluateClosure [
	| result |
	self
		compile: 'foo ^[5] value'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test141evaluateClosureFrames [
	| result |
	self
		compile: 'foo [5] value'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image true ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test142evaluateClosureReceiver [
	| result |
	self
		compile: 'foo [self] value'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image true ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test150sendWhileTrue [
	| result |
	self
		compile: 'foo
			 | a |
			a := true.
			[a] whileTrue: [a := false].
			^a'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: image false ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test151sendToDo [
	| result |
	self
		compile:
			'foo
			 | a |
			a := 0.
			3 to: 4 do: [:i | a := a + i].
			^a'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test152compute20dividedBy5 [
	| result |
	result := runtime sendLocal: #/ to: self ==> 20 with: {(self ==> 5)}.
	self 
		assert: result equals: self ==> 4;
		assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test152sendToDoWithInterval [
	| result |
	self
		compile:
			'foo
			 | a |
			a := 0.
			(3 to: 4) do: [:i | a := a + i].
			^a'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test161evaluateClosureWithArgs [
	| result |
	self
		compile: 'foo ^[:a :b | a + b] value: 3 value: 4'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test162evaluateClosureWithArgsAndTemps [
	| result |
	self
		compile: 'foo ^[:a :b | | t | t := a + b. t] value: 3 value: 4'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test163evaluateClosureWithArgsAndMethodTemps [
	| result |
	self
		compile: 'foo | t | ^[:a :b | t := a + b. t] value: 3 value: 4'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test164evaluateClosureWithArgsAndMultipleTemps [
	| result |
	self
		compile:
			'foo 
				| s |
				s := 3.
				^[:a | | t | 
					t := a.
					t := t + s.
					t] value: 4'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test165evaluateClosureNonLocalReturn [
	| result |
	self
		compile:
			'foo 
				| s |
				[s := 3. ^s] value.
				s := 4.
				^s'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 3 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test166evaluateNestedClosure [
	| result |
	self
		compile: 'foo ^[ [ 7 ] value ] value'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test167evaluateNestedClosureWithArgs [
	| result |
	self
		compile: 'foo ^[:a | [:b | a + b ] value: 4 ] value: 3'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test168evaluateNestedClosureNonLocalReturn [
	| result |
	self
		compile: 'foo [ [ ^7 ] value ] value'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test168evaluateNestedClosureWithTemps [
	| result |
	self
		compile:
			'foo 
			| a |
			a := 2.
			^[ | b |
				b := 3.
				[ | c |
				c := 4.
				a + b + c ] value] value'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 9 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test169evaluateInlinedClosureInClosureWithMethodTemps [
	| result |
	self
		compile:
			'foo 
			| a result |
			a := 3.
			[ true ifTrue: [ result := a + 4 ] ] value.
			^result'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7 ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test170evaluateNonInlinedClosureIfTrue [
	| result |
	self
		compile:
			'foo 
			| a result closure |
			a := 3.
			closure := [ a + 4 ].
			result := true ifTrue: closure.
			^result'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result equals: self ==> 7;  assertNoLeftoverFrames ]
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test180evaluateToDo [
	| result |
	self
		compile:
			'foo | result | result := 0. 1 to: 5 do: [:i | result := result + i]. ^result'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result isImmediate;
				assert: result value equals: 1 + 2 + 3 + 4 + 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test181evaluateIntervalSize [
	| result |
	self
		compile:
			'foo ^(1 to: 2) size'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result isImmediate;
				assert: result value equals:  2 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test185evaluateArrayDo [
	| result |
	self
		compile:
			'foo | result a |
				result := 0.
				a := Array new: 5.
				a at: 1 put: 1; at: 2 put: 2; at: 3 put: 3; at: 4 put: 4; at: 5 put: 5.
				a do: [:i | result := result + i].
				^result'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result isImmediate;
				assert: result value equals: 1 + 2 + 3 + 4 + 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test186evaluateOrderedCollectionDo [
	| result |
	self
		compile:
			'foo | result o |
				result := 0.
				o:= OrderedCollection new: 5.
				o add: 1; add: 2; add: 3; add: 4; add: 5.
				o do: [:i | result := result + i].
				^result'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result isImmediate;
				assert: result value equals: 1 + 2 + 3 + 4 + 5 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test187evaluateArrayToDo [
	| result |
	self
		compile:
			'foo | a |
				a := Array new: 2.
				1 to: 2 do: [ :i | a at: i put: i ].
				^a first + a second'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result isImmediate;
				assert: result value equals: 1 + 2 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test188evaluateReplaceFromToWith [
	| result |
	self
		compile: 'foo ^#(1 2) replaceFrom: 1 to: 2 with: #(3 4) startingAt: 1'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result size = 2;
				assert: (result at: 1) value equals: 3;
				assert: (result at: 2) value equals: 4 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test189evaluateArrayConcatenation [
	| result |
	self
		compile: 'foo ^#(3), #(4)'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result size equals: 2; assert: (result at: 1 ) value equals: 3; assert: (result at: 2) value equals: 4 ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test190evaluateStringConcatenation [
	| result |
	self
		compile: 'foo ^''ABC'', ''DE'''
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self assert: result asString equals: 'ABCDE' ].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test191evaluateIntervalCollect [
	| result |
	self
		compile:
			'foo | result |
				result := (1 to: 2) collect: [:i | i].
				^result first + result second'
		in: #ProtoObject
		during: [ result := runtime sendLocal: #foo to: image true.
			self
				assert: result isImmediate;
				assert: result value equals: 1 + 2].
	self assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test200createDictionary [
	| class d |
	class := image classNamed: #Dictionary.
	d := runtime sendLocal: #new to: class with: {}.
	self assert: d spec name equals: 'Dictionary'; assertNoLeftoverFrames
]

{ #category : 'tests' }
EggBootstrapRuntimeTest >> test210addAssociationToDictionary [
	| class d assoc |
	class := image classNamed: #Dictionary.
	assoc := image newAssociation: #foo -> nil.
	d := runtime sendLocal: #new to: class with: {}.
	self assertNoLeftoverFrames.
	runtime sendLocal: #add: to: d with: {assoc}.
	self
		assert: d spec name equals: 'Dictionary';
		assertNoLeftoverFrames
]
