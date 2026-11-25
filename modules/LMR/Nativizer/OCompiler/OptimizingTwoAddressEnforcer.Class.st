'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingTwoAddressEnforcer category: #OCompiler!
Object subclass: #OptimizingTwoAddressEnforcer
	instanceVariableNames: 'allocation firstBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingTwoAddressEnforcer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocation: aDictionary
	allocation := aDictionary
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
convert: instruction copyingLeftInto: dest
	| load |
	load := OUnaryOperation receiver: instruction left name: #copy.
	instruction left addUse: load at: #receiver.
	instruction beforeInsert: load; left: load.
	allocation at: load put: dest
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
convert: instruction copyingReceiverInto: dest
	| load |
	load := OUnaryOperation receiver: instruction receiver name: #copy.
	instruction receiver
		addUse: load at: #receiver;
		removeUse: instruction.
	instruction beforeInsert: load; receiver: load.
	allocation at: load put: dest
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
doEnforce
	firstBlock
		withSuccessorsDo: [:block | block firstInstruction acceptVisitor: self]
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: block
	firstBlock := block
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopy: instruction rightInto: dest
	| load |
	load := OUnaryOperation receiver: instruction right name: #copy.
	instruction addUse: load at: #receiver.
	instruction afterInsert: load.
	allocation at: load put: dest
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
invertMinus: minus with: left with: right
	| negate |
	negate := OUnaryOperation receiver: minus right name: #negate.
	minus beforeInsert: negate.
	allocation at: negate put: right.
	minus right
		removeUse: minus;
		addUse: negate at: #receiver.
	negate addUse: minus at: #right.
	minus right: negate; name: #'+'; swapOperands
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	| left dest |
	(#(_basicAt: _smallSize:) includes: instruction name) ifTrue: [^self].
	left := allocation at: instruction left.
	dest := allocation at: instruction.
	left == dest ifTrue: [^self].
	self convert: instruction copyingLeftInto: dest
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	| left right dest temp |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	dest := allocation at: instruction ifAbsent: [^self].
	left == dest ifTrue: [^self].
	right == dest ifTrue: [
		(#(< <= = == > >= _transferControlTo: _basicAt: _byteAt: _basicFlags: _smallSize: _extendedFlags:)
			includes: instruction name)
			ifTrue: [^self].
		instruction name == #'-'
			ifTrue: [^self invertMinus: instruction with: left with: right].
		(#(+ bitAnd: bitOr: &  ) includes: instruction name)
			ifTrue: [
				temp := instruction left.
				instruction left: instruction right.
				^instruction right: temp]
			ifFalse: [self halt]].
	self convert: instruction copyingLeftInto: dest
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitNullary: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: instruction
	
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	| receiver left right dest |
	(#(_basicAt:put: _basicULongAt:put: _byteAt:put: _objectAtOffset:put:)
		includes: instruction name)
		ifTrue: [^self].
	receiver := allocation at: instruction receiver.
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	dest := allocation at: instruction.
	right == dest ifTrue: [^self halt].
	self insertCopy: instruction rightInto: dest
! !

!OptimizingTwoAddressEnforcer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	| receiver dest |
	(#(_asNative _asObject _asPointer _asSmallInteger)
		includes: instruction name)
		ifFalse: [^self].
	receiver := allocation at: instruction receiver.
	dest := allocation at: instruction.
	receiver == dest ifTrue: [^self].
	self convert: instruction copyingReceiverInto: dest
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingTwoAddressEnforcer class' category: #OCompiler!
OptimizingTwoAddressEnforcer class
	instanceVariableNames: ''!


