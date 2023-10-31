"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CommandLine,
	#superclass : #Object,
	#instVars : [
		'input',
		'rules',
		'tokens',
		'command',
		'options'
	],
	#pools : [
		'CharacterConstants'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
CommandLine class >> fromString: aString [
	^self new fromString: aString; process
]

{ #category : #'instance creation' }
CommandLine class >> on: aString [
	^self new on: aString
]

{ #category : #private }
CommandLine >> actionFor: option [
	^rules at: option ifAbsent: nil
]

{ #category : #accessing }
CommandLine >> addOption: option [
	^self addOption: option with: #()
]

{ #category : #accessing }
CommandLine >> addOption: option with: arguments [
	| op args |
	op := self canonize: option.
	args := (arguments isCollection andNot: [arguments isString])
		ifTrue: [arguments asArray]
		ifFalse: [{arguments}].
	args := args collect: #asString.
	^options at: op put: args
]

{ #category : #accessing }
CommandLine >> argumentAt: option [
	| arguments |
	arguments := self argumentsAt: option.
	arguments ifNil: [^nil].
	^arguments size = 1
		ifTrue: [arguments first]
		ifFalse: [self error: 'The option has a different number of arguments']
]

{ #category : #accessing }
CommandLine >> argumentsAt: option [
	| op |
	op := self canonize: option.
	^options at: op ifAbsent: nil
]

{ #category : #accessing }
CommandLine >> booleanAt: option [
	| arguments value |
	arguments := self argumentsAt: option.
	arguments ifNil: [^false].
	arguments size = 0 ifTrue: [^true].
	arguments size = 1 ifTrue: [
		value := arguments first.
		^(value = '0' or: [value = 'false' or: [value = 'no']]) not].
	self error: 'The option has a different number of arguments'
]

{ #category : #private }
CommandLine >> canonize: option [
	^(((option trimPrefix: '--') trimPrefix: '-') trimTail: ':') trimTail: '='
]

{ #category : #accessing }
CommandLine >> command [
	^command
]

{ #category : #accessing }
CommandLine >> command: aString [
	command := aString
]

{ #category : #private }
CommandLine >> formatArgument: argument [
	^(argument includes: Space)
		ifTrue: [argument doubleQuoted]
		ifFalse: [argument]
]

{ #category : #private }
CommandLine >> formatOption: option [
	| prefix string |
	prefix := option size = 1 ifTrue: ['-'] ifFalse: ['--'].
	string := (option includes: Space)
		ifTrue: [option doubleQuoted]
		ifFalse: [option].
	^prefix , string
]

{ #category : #private }
CommandLine >> fromString: aString [
	self on: aString; parse
]

{ #category : #processing }
CommandLine >> getArguments: anInteger for: option [
	| args |
	args := self nextTokens: anInteger.
	args size < anInteger ifTrue: [
		args := anInteger = 1 ifTrue: [' argument'] ifFalse: [' arguments'].
		self error: 'Option ' , option , ' expects ' , anInteger asString , args].
	^args
]

{ #category : #testing }
CommandLine >> includesOption: aString [
	| option |
	option := self canonize: aString.
	^options includesKey: option
]

{ #category : #initialization }
CommandLine >> initialize [
	super initialize.
	options := OrderedDictionary new.
	rules := OrderedDictionary new
]

{ #category : #processing }
CommandLine >> nextArgumentTokens [
	^tokens untilAnySatisfying: [:t | self seemsOption: t]
]

{ #category : #parsing }
CommandLine >> nextToken [
	^tokens next
]

{ #category : #parsing }
CommandLine >> nextTokens: anInteger [
	| max |
	max := anInteger min: tokens size - tokens position.
	^(tokens next: max) asArray
]

{ #category : #private }
CommandLine >> on: aString [
	input := aString
]

{ #category : #accessing }
CommandLine >> options [
	^options keys
]

{ #category : #accessing }
CommandLine >> parameters [
	^self options
]

{ #category : #parsing }
CommandLine >> parse [
	self tokenize
]

{ #category : #processing }
CommandLine >> process [
	tokens isNil ifTrue: [self parse].
	tokens := tokens readStream.
	command := tokens next.
	[tokens atEnd] whileFalse: [| option arguments token |
		token := self nextToken.
		(self seemsOption: token) ifTrue: [self processOption: token] ifFalse: [
			option := self canonize: token.
			arguments := self nextArgumentTokens.
			self addOption: option with: arguments]]
]

{ #category : #processing }
CommandLine >> processOption: token [
	| action option |
	option := self canonize: token.
	action := self actionFor: option.
	(action isNil and: [self seemsMultipleOption: token])
		ifTrue: [option do: [:char | self processOption: char asString]]
		ifFalse: [self processOption: option action: action]
]

{ #category : #processing }
CommandLine >> processOption: option action: action [
	| arguments |
	arguments := action notNil
		ifTrue: [self getArguments: action arity for: option]
		ifFalse: [self nextArgumentTokens].
	action notNil ifTrue: [action evaluateWithArguments: arguments].
	self addOption: option with: arguments
]

{ #category : #private }
CommandLine >> readTokenFrom: aStream [
	^String streamContents: [:strm | | next end t |
		next := aStream next.
		end := next = $" ifTrue: [$"] ifFalse: [
			strm nextPut: next.
			Space].
		t := aStream upTo: end.
		strm nextPutAll: t]
]

{ #category : #private }
CommandLine >> reset [
	command := tokens := nil.
	options removeAll
]

{ #category : #processing }
CommandLine >> seemsMultipleOption: token [
	| option |
	(token beginsWith: '--') ifTrue: [^false].
	option := self canonize: token.
	^option size > 1
		and: [option conform: [:char | rules includesKey: char asString]]
]

{ #category : #testing }
CommandLine >> seemsOption: aString [
	^aString first = $-
]

{ #category : #parsing }
CommandLine >> tokenize [
	| stream |
	tokens := OrderedCollection new.
	stream := input readStream.
	[stream skipSeparators; atEnd] whileFalse: [| token |
		token := self readTokenFrom: stream.
		tokens add: token]
]

{ #category : #accessing }
CommandLine >> withOption: aString do: aBlock [
	| option |
	option := self canonize: aString.
	rules at: option put: aBlock.
	self reset
]

{ #category : #accessing }
CommandLine >> withOption: short or: long do: aBlock [
	| s l |
	s := self canonize: short.
	l := self canonize: long.
	rules
		at: s put: aBlock;
		at: l put: aBlock.
	self reset
]

