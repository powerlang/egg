"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingTwoAddressEnforcer',
	#superclass : 'Object',
	#instVars : [
		'allocation',
		'firstBlock'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core-Main'
}

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> allocation: aDictionary [
	allocation := aDictionary
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> convert: instruction copyingLeftInto: dest [
	| load |
	load := instruction left newCopy.
	instruction beforeInsert: load; left: load.
	allocation at: load put: dest
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> convert: instruction copyingReceiverInto: dest [
	| load |
	load := instruction receiver newCopy.
	instruction receiver removeUseBy: instruction.
	instruction beforeInsert: load; receiver: load.
	allocation at: load put: dest
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> doEnforce [
	firstBlock
		withSuccessorsDo: [:block | block firstInstruction acceptVisitor: self]
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> firstBlock: block [
	firstBlock := block
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> invertMinus: minus with: left with: right [
	| negate |
	negate := OUnaryOperation receiver: minus right name: #negate.
	minus beforeInsert: negate.
	allocation at: negate put: right.
	minus right removeUseBy: minus.
	minus right: negate; name: #'+'; swapOperands
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitBinaryWithConstant: instruction [
	| left dest |
	left := allocation at: instruction left.
	dest := allocation at: instruction.
	left == dest ifTrue: [^self].
	self convert: instruction copyingLeftInto: dest
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitBinaryWithVariable: instruction [
	| left right dest temp |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	dest := allocation at: instruction ifAbsent: [^self].
	left == dest ifTrue: [^self].
	right == dest ifTrue: [
		instruction isComparison ifTrue: [^self].
		#_transferControlTo: = instruction name ifTrue: [^self].
		instruction name == #'-'
			ifTrue: [^self invertMinus: instruction with: left with: right].
		(#(+ bitAnd: bitOr: &  ) includes: instruction name)
			ifTrue: [
				temp := instruction left.
				instruction left: instruction right.
				^instruction right: temp]
			ifFalse: [self halt]].
	self convert: instruction copyingLeftInto: dest
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitJump: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitJumpFalse: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitJumpTrue: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingTwoAddressEnforcer >> visitLoad: load [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitLoadConstant: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitLoadImplicit: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitMessageSend: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitNullary: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitPhi: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitReturn: instruction [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitStore: store [
	
]

{ #category : 'unclassified' }
OptimizingTwoAddressEnforcer >> visitUnary: instruction [
	| receiver dest |
	(#(_asNative _asObject _asPointer _asSmallInteger)
		includes: instruction name)
		ifFalse: [^self].
	receiver := allocation at: instruction receiver.
	dest := allocation at: instruction.
	receiver == dest ifTrue: [^self].
	self convert: instruction copyingReceiverInto: dest
]
