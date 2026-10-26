'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingInstructionFragmenter category: #OCompiler!
Object subclass: #OptimizingInstructionFragmenter
	instanceVariableNames: 'method messages firstBlock abi'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingInstructionFragmenter commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anAbi
	abi := anAbi
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
activationRecord
	^firstBlock firstInstruction
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: aBasicBlock
	firstBlock := aBasicBlock
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentActivationRecordDeclarationIn: aBasicBlock
	| declaration implicit |
	declaration := aBasicBlock firstInstruction.
	implicit := OActivationContext named: #activationRecord.
	implicit source: abi regFP.
	declaration dissolveReplacingWith: implicit
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentArgumentsIn: aBasicBlock with: aCompiledMethod
	method := aCompiledMethod.
	self
		fragmentActivationRecordDeclarationIn: aBasicBlock;
		fragmentSelfDeclarationIn: aBasicBlock;
		fragmentSpecialABIArgumentsIn: aBasicBlock;
		fragmentNormalArgumentsIn: aBasicBlock
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentBinaryCommutative: instruction
	| left right |
	left := instruction receiver.
	right := instruction arguments first.
	right isConstant
		ifTrue: [^self replace: instruction withBinary: left withConstant: right].
	left isConstant
		ifTrue: [^self replace: instruction withBinary: right withConstant: left].
	self replace: instruction withVariable: left with: right
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentBinaryCompare: instruction
	| left right new |
	left := instruction receiver.
	right := instruction arguments first.
	right isConstant
		ifTrue: [^self replace: instruction withBinary: left withConstant: right].
	left isConstant ifTrue: [
		new := self replace: instruction withBinary: right withConstant: left.
		^new invertOperation].
	self replace: instruction withVariable: left with: right
! !

!OptimizingInstructionFragmenter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentBinaryNonCommutative: instruction
	| left right |
	left := instruction receiver.
	right := instruction arguments first.
	right isConstant
		ifTrue: [^self replace: instruction withBinary: left withConstant: right].
	self replace: instruction withVariable: left with: right
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentCallSite: instruction
	| callsite |
	callsite := OBinaryConstantOperation
		left: self activationRecord
		right: 2
		name: #_basicAt:.
	self activationRecord addUse: callsite at: #left.
	instruction dissolveReplacingWith: callsite
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentGenericMessage: instruction
	| arguments new |
	arguments := instruction arguments.
	new := arguments
		collect: [:argument | self insertPush: argument before: instruction].
	instruction arguments: new.
	arguments
		do: [:argument | argument removeUse: instruction; dissolveIfUnused].
	firstBlock activationRecord haveFrame
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentInstructionsFrom: aBasicBlock
	self firstBlock: aBasicBlock.
	aBasicBlock
		reversePostOrderDo: [:block | self fragmentInstructionsOf: block]
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentInstructionsOf: block
	block firstInstruction acceptVisitor: self
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentNormalArgumentsIn: aBasicBlock
	| count argument position context |
	count := 0.
	context := aBasicBlock firstInstruction.
	argument := context next next.
	[argument isDefineArgument] whileTrue: [
		argument := argument next.
		count := count + 1].
	argument := argument prev.
	position := 0.
	[position < count] whileTrue: [| new next |
		argument isUsed
			ifTrue: [
				new := OBinaryConstantOperation
					left: context
					right: position + 3
					name: #_basicAt:.
				context addUse: new at: #left.
				argument dissolveReplacingWith: new.
				argument := new prev]
			ifFalse: [
				next := argument prev.
				argument dissolve.
				argument := next].
		position := position + 1]
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentNot: instruction
	| negated |
	negated := instruction receiver halt shallowCopy.
	negated negateOperation.
	negated left addUse: negated at: #left.
	negated right addUse: negated at: #right.
	instruction dissolveReplacingWith: negated.
	instruction receiver dissolveIfUnused
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentPatchIndirectCallSiteTo: instruction
	| nativeCode callsite patch |
	nativeCode := instruction arguments first.
	callsite := OBinaryConstantOperation
		left: self activationRecord
		right: 2
		name: #_basicAt:.
	patch := OTernaryOperation
		receiver: callsite
		left: 0
		right: nativeCode
		name: #_basicAt:put:.
	self activationRecord addUse: callsite at: #left.
	callsite addUse: patch at: #receiver.
	nativeCode addUse: patch at: #right.
	instruction dissolveReplacingWith: patch.
	patch beforeInsert: callsite
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentSelfDeclarationIn: aBasicBlock
	| declaration implicit |
	declaration := aBasicBlock firstInstruction next.
	implicit := OLoadImplicit named: #self.
	declaration dissolveReplacingWith: implicit
! !

!OptimizingInstructionFragmenter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentSpecialABIArgumentsIn: aBasicBlock
	| literals i actual next load |
	literals := method literals.
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #savePreviousSelf ifTrue: [
		aBasicBlock activationRecord doSavePreviousSelf.
		load := aBasicBlock firstInstruction detect: [:inst | inst isConstant].
		load dissolve.
		literals := literals copyFrom: 2].
	literals size = 0 ifTrue: [^self].
	(literals at: 1) == #specialABIBegin ifFalse: [^self].
	i := 2.
	[(literals at: i) == #specialABIEnd]
		whileFalse: [| name register implicit argument receiver regname |
			name := literals at: i.
			regname := literals at: i + 1.
			register := self registerNamed: regname.
			name = #self
				ifTrue: [
					receiver := aBasicBlock firstInstruction
						detect: [:instruction | instruction isLoadImplicit
							and: [instruction name = #self]].
					receiver source: register]
				ifFalse: [
					implicit := (OLoadImplicit named: name) source: register.
					argument := aBasicBlock firstInstruction
						detect: [:instruction | instruction isDefineArgument
							and: [instruction name = name]].
					argument dissolveReplacingWith: implicit].
			i := i + 2].
	actual := aBasicBlock firstInstruction detect: [:inst | inst isConstant].
	[
		next := actual next.
		actual dissolve.
		actual isConstant and: [actual value == #specialABIEnd]]
		whileFalse: [actual := next]
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentTernary: instruction
	| receiver left right new |
	receiver := instruction receiver.
	left := instruction arguments first.
	right := instruction arguments second.
	new := OTernaryOperation
		receiver: receiver
		left: left
		right: right
		name: instruction selector.
	receiver addUse: new at: #receiver.
	left addUse: new at: #left.
	right addUse: new at: #right.
	self
		ASSERT: (#(_basicAt:put: _basicULongAt:put:	_byteAt:put: _objectAtOffset:put:)
			includes: new name).
	instruction replaceAllUsesWith: right; dissolveReplacingWith: new
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentTransferControlTo: instruction
	| receiver machine |
	receiver := instruction receiver.
	machine := instruction arguments first.
	self replace: instruction withVariable: receiver with: machine
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentUnary: instruction
	| receiver new |
	receiver := instruction receiver.
	"	receiver isConstant ifTrue: [self halt]."
	new := OUnaryOperation new receiver: receiver; name: instruction selector.
	receiver addUse: new at: #receiver.
	instruction dissolveReplacingWith: new
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	self initializeMessages
! !

!OptimizingInstructionFragmenter methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeMessages
	messages := Dictionary new
		at: #'+' put: #BinaryCommutative:;
		at: #'-' put: #BinaryNonCommutative:;
		at: #'*' put: #BinaryCommutative:;
		at: #'<' put: #BinaryCompare:;
		at: #'<=' put: #BinaryCompare:;
		at: #'=' put: #BinaryCompare:;
		at: #'==' put: #BinaryCompare:;
		at: #'~=' put: #BinaryCompare:;
		at: #'!!=' put: #BinaryCompare:;
		at: #'>=' put: #BinaryCompare:;
		at: #'>' put: #BinaryCompare:;
		at: #'&' put: #BinaryCommutative:;
		at: #_asNative put: #Unary:;
		at: #_asObject put: #Unary:;
		at: #_asPointer put: #Unary:;
		at: #_asSmallInteger put: #Unary:;
		at: #bitAnd: put: #BinaryCommutative:;
		at: #bitOr: put: #BinaryCommutative:;
		at: #bitShift: put: #BinaryNonCommutative:;
		at: #_byteAt: put: #BinaryNonCommutative:;
		at: #_basicAt: put: #BinaryNonCommutative:;
		at: #_basicULongAt: put: #BinaryNonCommutative:;
		at: #_byteAt:put: put: #Ternary:;
		at: #_basicAt:put: put: #Ternary:;
		at: #_basicULongAt:put: put: #Ternary:;
		at: #_objectAtOffset:put: put: #Ternary:;
		at: #_basicFlags put: #Unary:;
		at: #_basicFlags: put: #BinaryNonCommutative:;
		at: #_smallSize put: #Unary:;
		at: #_smallSize: put: #BinaryNonCommutative:;
		at: #_largeSize put: #Unary:;
		at: #_largeSize: put: #BinaryNonCommutative:;
		at: #_isSmallInteger put: #Unary:;
		at: #_transferControlTo: put: #TransferControlTo:;
		at: #_callSite put: #CallSite:;
		at: #_patchIndirectCallSiteTo: put: #PatchIndirectCallSiteTo:;
		at: #not put: #Not:;
		yourself
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopyResultAfter: anInstruction
	| copy |
	copy := OUnaryOperation receiver: anInstruction name: #copyResult.
	anInstruction
		afterInsert: copy;
		replaceAllUsesWith: copy;
		addUse: copy at: #receiver
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPush: anInstruction before: instruction
	| push |
	push := OUnaryOperation receiver: anInstruction name: #push.
	anInstruction addUse: push at: #receiver.
	instruction beforeInsert: push.
	^push
! !

!OptimizingInstructionFragmenter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
registerNamed: regname
	^abi perform: regname
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replace: instruction withBinary: left withConstant: right
	| constant new |
	constant := right value.
	new := OBinaryConstantOperation
		left: left
		right: constant
		name: instruction selector.
	left addUse: new at: #left.
	instruction dissolveReplacingWith: new.
	right dissolveIfUnused.
	^new
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replace: instruction withVariable: left with: right
	| new |
	new := OBinaryVariableOperation
		left: left
		right: right
		name: instruction selector.
	left addUse: new at: #left.
	right addUse: new at: #right.
	instruction dissolveReplacingWith: new.
	^new
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selectorFor: name
	^(#fragment , (messages at: name ifAbsent: [#GenericMessage:])) asSymbol
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitDefineArgument: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: instruction
	| selector |
	selector := self selectorFor: instruction selector.
	self perform: selector with: instruction
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	
! !

!OptimizingInstructionFragmenter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingInstructionFragmenter class' category: #OCompiler!
OptimizingInstructionFragmenter class
	instanceVariableNames: ''!

!OptimizingInstructionFragmenter class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingInstructionFragmenter initialize!

