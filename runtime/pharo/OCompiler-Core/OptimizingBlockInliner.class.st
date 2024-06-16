"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingBlockInliner',
	#superclass : 'Object',
	#instVars : [
		'inlinerActivation'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core-Main'
}

{ #category : 'accessing' }
OptimizingBlockInliner >> canBeInlined [
	^true
]

{ #category : 'private' }
OptimizingBlockInliner >> closureArgumentsIn: aBasicBlock count: anInteger [
	| result remaining |
	result := OrderedCollection new.
	remaining := anInteger.
	aBasicBlock instructionsDo: [:i | 
		remaining = 0 ifTrue: [^result].
		result add: i.
		remaining := remaining - 1].
	^result
]

{ #category : 'accessing' }
OptimizingBlockInliner >> duplicateClosure: anOCompiledBlock [
	| closure activation implicits |
	closure := anOCompiledBlock firstBlock duplicate.
	activation := closure activationRecord.
	implicits := inlinerActivation implicitLoads.
	activation implicitLoads do: [:load | | replacement |
		replacement := implicits detect: [:candidate | candidate name = load name].
		load replaceAllUsesWith: replacement; dissolve].
	activation replaceAllUsesWith: inlinerActivation; dissolve.
	^closure
]

{ #category : 'unclassified' }
OptimizingBlockInliner >> inline: anOMessageSend in: block [
	| selector inliner |
	selector := anOMessageSend selector asString copy replace: $: with: $_.
	inliner := #inline , selector capitalized , ':in:'.
	^self perform: inliner asSymbol with: anOMessageSend with: block
]

{ #category : 'accessing' }
OptimizingBlockInliner >> inlineValue: message in: block [
	| closure entry exit after result |
	closure := message receiver.
	closure isBlockClosure ifFalse: [^block].
	entry := self duplicateClosure: closure.
	exit := entry lastBlock.
	after := block splitAfter: message.
	block endWithJumpTo: entry.
	exit endWithJumpTo: after.
	result := exit lastValue.
	message replaceAllUsesWith: result; dissolve.
	closure isUseless ifTrue: [closure firstBlock dissolveAllInstructions].
	^result -> after
]

{ #category : 'accessing' }
OptimizingBlockInliner >> inlineValue_: message in: block [
	| closure args arg1 entry exit after closureArgs result |
	closure := message receiver.
	closure isBlockClosure ifFalse: [^block].
	args := message arguments.
	arg1 := args first.
	entry := self duplicateClosure: closure.
	exit := entry lastBlock.
	closureArgs := self closureArgumentsIn: entry count: 1.
	closureArgs first replaceAllUsesWith: arg1; dissolve.
	after := block splitAfter: message.
	block endWithJumpTo: entry.
	exit endWithJumpTo: after.
	result := exit lastValue.
	message replaceAllUsesWith: result; dissolve.
	closure isUseless ifTrue: [closure firstBlock dissolveAllInstructions].
	^result -> after
]

{ #category : 'accessing' }
OptimizingBlockInliner >> inlineWhileTrue_: message in: block [
	| antecedent consequent firstAntecedent firstConsequent lastAntecedent lastConsequent join |
	antecedent := message receiver.
	consequent := message arguments first.
	firstAntecedent := antecedent firstBlock.
	firstConsequent := consequent firstBlock.
	lastAntecedent := firstAntecedent lastBlock.
	lastConsequent := firstConsequent lastBlock.
	join := block splitAfter: message.
	block endWithJumpTo: firstAntecedent.
	lastAntecedent
		endWithJumpFalseTo: join
		skipping: firstConsequent
		if: lastAntecedent lastValue.
	lastConsequent endWithJumpTo: firstAntecedent.
	message dissolve.
	^antecedent -> join
]

{ #category : 'accessing' }
OptimizingBlockInliner >> inlinerActivation: anOActivationRecord [
	inlinerActivation := anOActivationRecord
]

{ #category : 'accessing' }
OptimizingBlockInliner >> inliners [
	^#(#value #value: #whileTrue:)
]
