'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingBlockInliner category: #OCompiler!
Object subclass: #OptimizingBlockInliner
	instanceVariableNames: 'firstBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingBlockInliner commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
doInline
	self inlineInnerBlocksOf: firstBlock
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inline: aMessageSend in: block
	^self performInlinerFor: aMessageSend in: block
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineAnd: message in: block
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	join
		insertPhiOf: message receiver
		at: block
		and: lastSkipped
		replacing: message.
	block endWithJumpFalseTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	^join
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineIfFalse: message in: block
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
	message dissolve.
	^join
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineIfTrue: message in: block
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
	message dissolve.
	^join
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineIfTrueifFalse: message in: block
	| positive negative firstTrue firstFalse lastTrue lastFalse join |
	positive := message arguments first.
	negative := message arguments second.
	firstTrue := positive firstBlock.
	firstFalse := negative firstBlock.
	self inlineInnerBlocksOf: firstTrue and: firstFalse.
	lastTrue := firstTrue lastBlock.
	lastFalse := firstFalse lastBlock.
	join := block splitAfter: message.
	join insertPhiOf: lastTrue and: lastFalse replacing: message.
	block
		endWithJumpFalseTo: firstFalse
		skipping: firstTrue
		if: message receiver.
	lastTrue endWithJumpTo: join.
	lastFalse endWithJumpTo: join.
	firstTrue addPredecessor: block.
	firstFalse addPredecessor: block.
	join addPredecessor: lastTrue; addPredecessor: lastFalse.
	^join
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineInnerBlocksOf: basicBlock
	| currentBlock |
	currentBlock := basicBlock.
	basicBlock instructionsDo: [:instruction | 
		(self shouldInline: instruction)
			ifTrue: [currentBlock := self inline: instruction in: currentBlock]]
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineInnerBlocksOf: basicBlock1 and: basicBlock2
	self inlineInnerBlocksOf: basicBlock1; inlineInnerBlocksOf: basicBlock2
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineInnerBlocksOf: basicBlock1 and: basicBlock2 and: basicBlock3
	self
		inlineInnerBlocksOf: basicBlock1;
		inlineInnerBlocksOf: basicBlock2;
		inlineInnerBlocksOf: basicBlock3
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineOr: message in: block
	| closure firstSkipped lastSkipped join |
	closure := message arguments first.
	firstSkipped := closure firstBlock.
	self inlineInnerBlocksOf: firstSkipped.
	lastSkipped := firstSkipped lastBlock.
	join := block splitAfter: message.
	join
		insertPhiOf: message receiver
		at: block
		and: lastSkipped
		replacing: message.
	block endWithJumpTrueTo: join skipping: firstSkipped if: message receiver.
	lastSkipped endWithJumpTo: join.
	firstSkipped addPredecessor: block.
	join addPredecessor: block; addPredecessor: lastSkipped.
	^join
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inliners
	^#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue: and: or: to:do: whileTrue:)
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineWhileTrue: message in: block
	| antecedent consequent firstAntecedent firstConsequent lastAntecedent lastConsequent join |
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
		endWithJumpFalseTo: join
		skipping: firstConsequent
		if: lastAntecedent lastValue.
	lastConsequent endWithJumpTo: firstAntecedent.
	message dissolve.
	firstAntecedent addPredecessor: block; addPredecessor: lastConsequent.
	firstConsequent addPredecessor: lastAntecedent.
	join addPredecessor: lastAntecedent.
	^join
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: block
	firstBlock := block
! !

!OptimizingBlockInliner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
performInlinerFor: messageSend in: block
	| selector inliner |
	selector := messageSend selector asString copyWithout: $:.
	inliner := #inline , selector capitalized , ':in:'.
	^self perform: inliner asSymbol with: messageSend with: block
! !

!OptimizingBlockInliner methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldInline: anInstruction
	^anInstruction isMessageSend
		and: [self inliners includes: anInstruction selector]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingBlockInliner class' category: #OCompiler!
OptimizingBlockInliner class
	instanceVariableNames: ''!


