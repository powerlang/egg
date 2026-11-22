"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingBlockInliner,
	#superclass : #Object,
	#instVars : [
		'firstBlock'
	],
	#category : #OCompiler
}

{ #category : #private }
OptimizingBlockInliner >> bind: value to: closure [
	closure arguments do: [:binding | | write |
		write := OWriteVariable binding: binding valued: value.
		value addUse: write at: #source.
		closure firstBlock afterInsert: write]
]

{ #category : #private }
OptimizingBlockInliner >> closuresOf: message [
	(#(to:do: to:by:do:) includes: message selector)
		ifTrue: [^{message arguments last}].
	^message arguments
]

{ #category : #unclassified }
OptimizingBlockInliner >> doInline [
	self inlineInnerBlocksOf: firstBlock
]

{ #category : #unclassified }
OptimizingBlockInliner >> inline: aMessageSend in: block [
	^self performInlinerFor: aMessageSend in: block
]

{ #category : #unclassified }
OptimizingBlockInliner >> inline: message in: block if: condition then: positive else: negative [
	| firstTrue firstFalse lastTrue lastFalse join |
	firstTrue := positive firstBlock.
	firstFalse := negative firstBlock.
	self inlineInnerBlocksOf: firstTrue and: firstFalse.
	lastTrue := firstTrue lastBlock.
	lastFalse := firstFalse lastBlock.
	join := block splitAfter: message.
	block endWithJumpFalseTo: firstFalse skipping: firstTrue if: condition.
	lastTrue endWithJumpTo: join.
	lastFalse endWithJumpTo: join.
	firstTrue addPredecessor: block.
	firstFalse addPredecessor: block.
	join addPredecessor: lastTrue; addPredecessor: lastFalse.
	join insertParameterOf: lastTrue and: lastFalse replacing: message.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineAnd: message in: block [
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	block endWithJumpFalseTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	join
		insertParameterOf: message receiver
		at: block
		and: lastSkipped
		replacing: message.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfFalse: message in: block [
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	block endWithJumpTrueTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: lastSkipped; addPredecessor: block.
	self insertParameterAt: join of: lastSkipped orNilFrom: block replacing: message.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfFalseifTrue: message in: block [
	^self
		inline: message
		in: block
		if: message receiver
		then: message arguments second
		else: message arguments first
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfNil: message in: block [
	^self inlineNilCheck: message in: block skippingWith: OJumpFalse
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfNilifNotNil: message in: block [
	| receiver compare |
	receiver := message receiver.
	compare := self nilCheckOf: receiver before: message.
	self bind: receiver to: message arguments second.
	^self
		inline: message
		in: block
		if: compare
		then: message arguments first
		else: message arguments second
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfNotNil: message in: block [
	^self inlineNilCheck: message in: block skippingWith: OJumpTrue
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfNotNilifNil: message in: block [
	| receiver compare |
	receiver := message receiver.
	compare := self nilCheckOf: receiver before: message.
	self bind: receiver to: message arguments first.
	^self
		inline: message
		in: block
		if: compare
		then: message arguments second
		else: message arguments first
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfTrue: message in: block [
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	block endWithJumpFalseTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: lastSkipped; addPredecessor: block.
	self insertParameterAt: join of: lastSkipped orNilFrom: block replacing: message.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineIfTrueifFalse: message in: block [
	^self
		inline: message
		in: block
		if: message receiver
		then: message arguments first
		else: message arguments second
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineInnerBlocksOf: basicBlock [
	| currentBlock |
	currentBlock := basicBlock.
	basicBlock instructionsDo: [:instruction | 
		(self shouldInline: instruction)
			ifTrue: [currentBlock := self inline: instruction in: currentBlock]]
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineInnerBlocksOf: basicBlock1 and: basicBlock2 [
	self inlineInnerBlocksOf: basicBlock1; inlineInnerBlocksOf: basicBlock2
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineInnerBlocksOf: basicBlock1 and: basicBlock2 and: basicBlock3 [
	self
		inlineInnerBlocksOf: basicBlock1;
		inlineInnerBlocksOf: basicBlock2;
		inlineInnerBlocksOf: basicBlock3
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineLoop: message in: block from: start to: limit by: step [
	| closure body last exit header counter test increment next |
	closure := message arguments last.
	body := closure firstBlock.
	self inlineInnerBlocksOf: body.
	last := body lastBlock.
	exit := block splitAfter: message.
	header := OBasicBlock new.
	block endWithJumpTo: header.
	last endWithJumpTo: header.
	header addPredecessor: block; addPredecessor: last.
	counter := header newParameter.
	test := step > 0
		ifTrue: [self send: #<= to: counter with: limit]
		ifFalse: [self send: #<= to: limit with: counter].
	header add: test.
	header endWithJumpFalseTo: exit skipping: body if: test.
	body addPredecessor: header.
	exit addPredecessor: header.
	increment := OLoadConstant valued: step.
	next := self send: #+ to: counter with: increment.
	last lastInstruction beforeInsert: increment; beforeInsert: next.
	counter addVariable: start from: block; addVariable: next from: last.
	self bind: counter to: closure.
	message replaceAllUsesWith: message receiver; dissolve.
	^exit
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineNilCheck: message in: block skippingWith: jumpType [
	| receiver closure firstSkipped lastSkipped compare join |
	receiver := message receiver.
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self bind: receiver to: closure; inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	compare := self nilCheckOf: receiver before: message.
	join := block splitAfter: message.
	block
		endWith: jumpType
		to: join
		skipping: firstSkipped
		if: compare.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	join
		insertParameterOf: receiver
		at: block
		and: lastSkipped
		replacing: message.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineOr: message in: block [
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	block endWithJumpTrueTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	join
		insertParameterOf: message receiver
		at: block
		and: lastSkipped
		replacing: message.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inliners [
	^#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue: and: or: to:do: to:by:do: whileTrue: whileFalse: ifNil: ifNotNil: ifNil:ifNotNil: ifNotNil:ifNil:)
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineTobydo: message in: block [
	| step |
	step := message arguments second value.
	^self
		inlineLoop: message
		in: block
		from: message receiver
		to: message arguments first
		by: step
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineTodo: message in: block [
	^self
		inlineLoop: message
		in: block
		from: message receiver
		to: message arguments first
		by: 1
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineWhile: message in: block exitingWith: jumpType [
	| antecedent consequent firstAntecedent firstConsequent lastAntecedent lastConsequent join constant |
	antecedent := message receiver.
	consequent := message arguments first.
	firstAntecedent := antecedent firstBlock.
	firstConsequent := consequent firstBlock.
	self inlineInnerBlocksOf: firstAntecedent and: firstConsequent.
	lastAntecedent := firstAntecedent lastBlock.
	lastConsequent := firstConsequent lastBlock.
	join := block splitAfter: message.
	block endWithJumpTo: firstAntecedent.
	lastAntecedent
		endWith: jumpType
		to: join
		skipping: firstConsequent
		if: lastAntecedent lastValue.
	lastConsequent endWithJumpTo: firstAntecedent.
	constant := OLoadConstant valued: nil.
	message isUsed
		ifTrue: [message dissolveReplacingWith: constant]
		ifFalse: [message dissolve].
	firstAntecedent addPredecessor: block; addPredecessor: lastConsequent.
	firstConsequent addPredecessor: lastAntecedent.
	join addPredecessor: lastAntecedent.
	^join
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineWhileFalse: message in: block [
	^self inlineWhile: message in: block exitingWith: OJumpTrue
]

{ #category : #unclassified }
OptimizingBlockInliner >> inlineWhileTrue: message in: block [
	^self inlineWhile: message in: block exitingWith: OJumpFalse
]

{ #category : #unclassified }
OptimizingBlockInliner >> insertParameterAt: join of: lastSkipped orNilFrom: block replacing: message [
	| constant |
	message isUsed ifFalse: [^message dissolve].
	constant := OLoadConstant valued: nil.
	block lastInstruction beforeInsert: constant.
	join insertParameterOf: constant at: block and: lastSkipped replacing: message
]

{ #category : #private }
OptimizingBlockInliner >> nilCheckOf: receiver before: message [
	| constant compare |
	constant := OLoadConstant valued: nil.
	compare := self send: #== to: receiver with: constant.
	message beforeInsert: constant; beforeInsert: compare.
	^compare
]

{ #category : #unclassified }
OptimizingBlockInliner >> on: block [
	firstBlock := block
]

{ #category : #private }
OptimizingBlockInliner >> performInlinerFor: messageSend in: block [
	| selector inliner |
	selector := messageSend selector asString copyWithout: $:.
	inliner := #inline , selector capitalized , ':in:'.
	^self perform: inliner asSymbol with: messageSend with: block
]

{ #category : #private }
OptimizingBlockInliner >> send: selector to: receiver with: argument [
	| send |
	send := OMessageSend receiver: receiver selector: selector arguments: {argument}.
	receiver addUse: send at: #receiver.
	argument addUse: send at: 1.
	^send
]

{ #category : #unclassified }
OptimizingBlockInliner >> shouldInline: anInstruction [
	^anInstruction isMessageSend
		and: [anInstruction isSuper not
			and: [(self inliners includes: anInstruction selector)
				and: [(self closuresOf: anInstruction) conform: [:closure | closure isBlockClosure]]]]
]

