'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingMethodInliner category: #OCompiler!
Object subclass: #OptimizingMethodInliner
	instanceVariableNames: 'firstBlock methods abi'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingMethodInliner commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anAbi
	abi := anAbi
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
bindVariablesOf: initialBlock with: aMessageSend
	| values |
	values := OrderedCollection
		with: aMessageSend receiver
		withAll: aMessageSend arguments.
	initialBlock instructionsDo: [:instruction | 
		instruction isDefineArgument ifFalse: [^self].
		instruction name == #activationRecord ifFalse: [
			instruction replaceAllUsesWith: values first.
			values removeFirst].
		instruction dissolve]
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: aBasicBlock
	firstBlock := aBasicBlock
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineAllMessages
	firstBlock withSuccessorsPostOrder do: [:block | | current |
		current := block.
		block instructionsAsCollection do: [:instruction | 
			(self shouldInline: instruction)
				ifTrue: [current := self inlineMethod: instruction in: current]]]
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlinedMethodFor: aMessageSend
	^methods detect: [:m | m selector == aMessageSend selector]
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineMessages
	self inlineMessagesIn: firstBlock
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineMethod: aMessageSend in: block
	| method nativizer initialBlock |
	method := self inlinedMethodFor: aMessageSend.
	nativizer := OptimizingNativizer on: method.
	initialBlock := nativizer
		abi: abi;
		inlinedMethods: methods;
		decompose;
		firstBlock.
	self bindVariablesOf: initialBlock with: aMessageSend.
	^block inline: initialBlock replacing: aMessageSend
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
methods: methodsToInline
	methods := methodsToInline
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selectors
	^methods collect: #selector
! !

!OptimizingMethodInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldInline: instruction
	^instruction isMessageSend
		and: [self selectors includes: instruction selector]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingMethodInliner class' category: #OCompiler!
OptimizingMethodInliner class
	instanceVariableNames: ''!

!OptimizingMethodInliner class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: basicBlock
	^self basicNew firstBlock: basicBlock
! !


