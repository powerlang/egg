'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #Command category: #ArgParser!
Object subclass: #Command
	instanceVariableNames: 'name description options positionalNames action subcommands'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArgParser'!
!Command commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
action
	^action
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
action: aBlock
	action := aBlock
! !

!Command methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:37'!
addOption: anOption
	options add: anOption
! !

!Command methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:37'!
addPositional: aString
	positionalNames add: aString
! !

!Command methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:37'!
addSubcommand: aCommand
	subcommands at: aCommand name put: aCommand
! !

!Command methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
applyDefaults: aResult
	options do: [:opt |
		(aResult hasOption: opt name) ifFalse: [
			opt defaultValue ifNotNil: [:v |
				aResult setOption: opt name to: v]]]
! !

!Command methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
checkRequired: aResult
			options do: [:opt |
		| name |
		name := opt long ifNil: [opt short].
		(opt required and: [(aResult hasOption: opt name) not])
			ifTrue: [self error: 'Required option missing: ', name]]
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description
	^description
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description: aString
	description := aString
! !

!Command methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
findOption: aString
	^options detect: [:opt | opt matches: aString] ifNone: [nil]
! !

!Command methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasSubcommands
	^subcommands notEmpty
! !

!Command methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	options := OrderedCollection new.
	positionalNames := OrderedCollection new.
	subcommands := OrderedDictionary new
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name
	^name
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name: aString
	name := aString
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
options
	^options
! !

!Command methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parse: args into: result
	| i |
	i := 1.
	[i <= args size] whileTrue: [
		| arg |
		arg := args at: i.
		(arg first = $-)
			ifTrue: [i := self parseOption: arg from: args at: i into: result]
			ifFalse: [result addPositional: arg].
		i := i + 1].
	self checkRequired: result.
	self applyDefaults: result
! !

!Command methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parseOption: aString from: anArray at: anInteger into: aResult
	| opt |
	opt := self findOption: aString.
	opt ifNil: [self error: 'Unknown option: ', aString].
	opt hasValue ifTrue: [
		| val next |
		next := anInteger + 1.
		next > anArray size ifTrue: [self error: 'Option ', aString, ' requires a value'].
		val := anArray at: next.
		aResult setOption: opt name to: val.
		^next]
	ifFalse: [
		aResult setOption: opt name to: true].
	^anInteger
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
positionalNames
	^positionalNames
! !

!Command methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printUsageOn: aStream
	aStream nextPutAll: name.
	positionalNames do: [:pname |
		aStream nextPutAll: ' <'; nextPutAll: pname; nextPut: $>].
	options do: [:opt |
		aStream nextPutAll: ' ['.
		opt short ifNotNil: [:s | aStream nextPutAll: s].
		(opt short notNil and: [opt long notNil]) ifTrue: [aStream nextPutAll: '|'].
		opt long ifNotNil: [:l | aStream nextPutAll: l].
		opt hasValue ifTrue: [aStream nextPutAll: ' <value>'].
		aStream nextPut: $]]
! !

!Command methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
subcommands
	^subcommands
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Command class' category: #ArgParser!
Command class
	instanceVariableNames: ''!


Command initialize!

