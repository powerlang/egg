'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #CommandLine category: #Kernel!
Object subclass: #CommandLine
	instanceVariableNames: 'input rules tokens command options'
	classVariableNames: ''
	poolDictionaries: 'CharacterConstants'
	category: 'Kernel'!
!CommandLine commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
actionFor: option
	^rules at: option ifAbsent: nil
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
addOption: option
	^self addOption: option with: #()
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
addOption: option with: arguments
	| op args |
	op := self canonize: option.
	args := (arguments isCollection andNot: [arguments isString])
		ifTrue: [arguments asArray]
		ifFalse: [{arguments}].
	args := args collect: #asString.
	^options at: op put: args
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentAt: option
	| arguments |
	arguments := self argumentsAt: option.
	arguments ifNil: [^nil].
	^arguments size = 1
		ifTrue: [arguments first]
		ifFalse: [self error: 'The option has a different number of arguments']
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentsAt: option
	| op |
	op := self canonize: option.
	^options at: op ifAbsent: nil
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
booleanAt: option
	| arguments value |
	arguments := self argumentsAt: option.
	arguments ifNil: [^false].
	arguments size = 0 ifTrue: [^true].
	arguments size = 1 ifTrue: [
		value := arguments first.
		^(value = '0' or: [value = 'false' or: [value = 'no']]) not].
	self error: 'The option has a different number of arguments'
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
canonize: option
	^(((option trimPrefix: '--') trimPrefix: '-') trimTail: ':') trimTail: '='
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
command
	^command
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
command: aString
	command := aString
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
formatArgument: argument
	^(argument includes: Space)
		ifTrue: [argument doubleQuoted]
		ifFalse: [argument]
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
formatOption: option
	| prefix string |
	prefix := option size = 1 ifTrue: ['-'] ifFalse: ['--'].
	string := (option includes: Space)
		ifTrue: [option doubleQuoted]
		ifFalse: [option].
	^prefix , string
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	self on: aString; parse
! !

!CommandLine methodsFor:  'processing' stamp: 'KenD 28/Jun/2026 13:27:38'!
getArguments: anInteger for: option
	| args |
	args := self nextTokens: anInteger.
	args size < anInteger ifTrue: [
		args := anInteger = 1 ifTrue: [' argument'] ifFalse: [' arguments'].
		self error: 'Option ' , option , ' expects ' , anInteger asString , args].
	^args
! !

!CommandLine methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesOption: aString
	| option |
	option := self canonize: aString.
	^options includesKey: option
! !

!CommandLine methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	options := OrderedDictionary new.
	rules := OrderedDictionary new
! !

!CommandLine methodsFor:  'processing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextArgumentTokens
	^tokens untilAnySatisfying: [:t | self seemsOption: t]
! !

!CommandLine methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextToken
	^tokens next
! !

!CommandLine methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextTokens: anInteger
	| max |
	max := anInteger min: tokens size - tokens position.
	^(tokens next: max) asArray
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aString
	input := aString
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
options
	^options keys
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
parameters
	^self options
! !

!CommandLine methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
parse
	self tokenize
! !

!CommandLine methodsFor:  'processing' stamp: 'KenD 28/Jun/2026 13:27:38'!
process
	tokens isNil ifTrue: [self parse].
	tokens := tokens readStream.
	command := tokens next.
	[tokens atEnd] whileFalse: [| option arguments token |
		token := self nextToken.
		(self seemsOption: token) ifTrue: [self processOption: token] ifFalse: [
			option := self canonize: token.
			arguments := self nextArgumentTokens.
			self addOption: option with: arguments]]
! !

!CommandLine methodsFor:  'processing' stamp: 'KenD 28/Jun/2026 13:27:38'!
processOption: token
	| action option |
	option := self canonize: token.
	action := self actionFor: option.
	(action isNil and: [self seemsMultipleOption: token])
		ifTrue: [option do: [:char | self processOption: char asString]]
		ifFalse: [self processOption: option action: action]
! !

!CommandLine methodsFor:  'processing' stamp: 'KenD 28/Jun/2026 13:27:38'!
processOption: option action: action
	| arguments |
	arguments := action notNil
		ifTrue: [self getArguments: action arity for: option]
		ifFalse: [self nextArgumentTokens].
	action notNil ifTrue: [action evaluateWithArguments: arguments].
	self addOption: option with: arguments
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
readTokenFrom: aStream
	^String streamContents: [:strm | | next end t |
		next := aStream next.
		end := next = $" ifTrue: [$"] ifFalse: [
			strm nextPut: next.
			Space].
		t := aStream upTo: end.
		strm nextPutAll: t]
! !

!CommandLine methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reset
	command := tokens := nil.
	options removeAll
! !

!CommandLine methodsFor:  'processing' stamp: 'KenD 28/Jun/2026 13:27:38'!
seemsMultipleOption: token
	| option |
	(token beginsWith: '--') ifTrue: [^false].
	option := self canonize: token.
	^option size > 1
		and: [option conform: [:char | rules includesKey: char asString]]
! !

!CommandLine methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
seemsOption: aString
	^aString first = $-
! !

!CommandLine methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tokenize
	| stream |
	tokens := OrderedCollection new.
	stream := input readStream.
	[stream skipSeparators; atEnd] whileFalse: [| token |
		token := self readTokenFrom: stream.
		tokens add: token]
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
withOption: aString do: aBlock
	| option |
	option := self canonize: aString.
	rules at: option put: aBlock.
	self reset
! !

!CommandLine methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
withOption: short or: long do: aBlock
	| s l |
	s := self canonize: short.
	l := self canonize: long.
	rules
		at: s put: aBlock;
		at: l put: aBlock.
	self reset
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CommandLine class' category: #Kernel!
CommandLine class
	instanceVariableNames: ''!

!CommandLine class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	^self new fromString: aString; process
! !

!CommandLine class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aString
	^self new on: aString
! !


CommandLine initialize!

