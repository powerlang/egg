'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ArgParser category: #ArgParser!
Object subclass: #ArgParser
	instanceVariableNames: 'name description commands globalOptions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArgParser'!
!ArgParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!ArgParser methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:27:37'!
addCommand: aCommand
	commands at: aCommand name put: aCommand
! !

!ArgParser methodsFor:  'options' stamp: 'KenD 28/Jun/2026 13:27:37'!
addGlobalOption: anOption
	globalOptions add: anOption
! !

!ArgParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description
	^description
! !

!ArgParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description: aString
	description := aString
! !

!ArgParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
extractGlobalArgs: args
	| remaining i |
	remaining := OrderedCollection new.
	i := 1.
	[i <= args size] whileTrue: [
		| arg match rest |
		arg := args at: i.
		match := globalOptions detect: [:opt | opt matches: arg] ifNone: [nil].
		match ifNotNil: [
			match hasValue ifTrue: [i := i + 1]
		] ifNil: [
			rest := args copyFrom: i to: args size.
			^remaining addAll: rest; yourself].
		i := i + 1].
	^remaining
! !

!ArgParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	commands := OrderedDictionary new.
	globalOptions := OrderedCollection new
! !

!ArgParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name
	^name
! !

!ArgParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name: aString
	name := aString
! !

!ArgParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:37'!
parse: args
	| remaining key command result tail |
	remaining := self extractGlobalArgs: args.
	remaining isEmpty ifTrue: [self printHelp. ^nil].
	key := remaining first.
	command := commands at: key ifAbsent: [
		self error: 'Unknown command: ', key, '. Run with no args for help.'].
	result := ParseResult new.
	result command: key.
	tail := remaining copyFrom: 2 to: remaining size.
	command parse: tail into: result.
	command action ifNotNil: [:act | act value: result].
	^result
! !

!ArgParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printHelp
	| text |
	text := name ifNil: ['command'].
	description ifNotNil: [
		text := text , ' - ' , description].
	text := text , String cr , String cr , 'Commands:' , String cr.
	commands keysAndValuesDo: [:key :cmd |
		text := text , '  ' , key.
		cmd description ifNotNil: [:d |
			text := text , '  - ' , d].
		text := text , String cr].
	Kernel log: text
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ArgParser class' category: #ArgParser!
ArgParser class
	instanceVariableNames: ''!


ArgParser initialize!

