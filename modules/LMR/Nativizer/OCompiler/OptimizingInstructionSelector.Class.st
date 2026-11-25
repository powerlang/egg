'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingInstructionSelector category: #OCompiler!
Object subclass: #OptimizingInstructionSelector
	instanceVariableNames: 'firstBlock tiles roots messages'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingInstructionSelector commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
doSelection
	self numberArguments.
	firstBlock reversePostOrderDo: [:block | self generateTilingFor: block].
	self removeUnused
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: aBasicBlock
	firstBlock := aBasicBlock
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
generateTilingFor: block
	block firstInstruction acceptVisitor: self
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	tiles := IdentityDictionary new.
	self initializeMessages
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeMessages
	messages := Dictionary new
		at: #'+' put: #CommutativeBinary:;
		at: #'-' put: #Minus:;
		at: #'*' put: #CommutativeBinary:;
		at: #'<' put: #Compare:;
		at: #'<=' put: #Compare:;
		at: #'=' put: #Compare:;
		at: #'==' put: #Compare:;
		at: #'~=' put: #Compare:;
		at: #'!!=' put: #Compare:;
		at: #'>=' put: #Compare:;
		at: #'>' put: #Compare:;
		at: #'&' put: #CommutativeBinary:;
		at: #bitAnd: put: #CommutativeBinary:;
		at: #_byteAt: put: #Binary:;
		at: #_basicAt: put: #Binary:;
		at: #_byteAt:put: put: #Ternary:;
		at: #_basicAt:put: put: #Ternary:;
		at: #_basicFlags put: #Unary:;
		at: #_smallSize put: #Unary:;
		at: #_largeSize put: #Unary:;
		at: #_isSmallInteger put: #Unary:;
		at: #_transferControlTo: put: #Binary:;
		at: #not put: #Not:;
		yourself
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopyResultAfter: anInstruction
	| copy |
	copy := OUnaryOperation receiver: anInstruction name: #copyResult.
	anInstruction
		afterInsert: copy;
		replaceAllUsesWith: copy;
		addUse: copy at: #receiver
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPush: anInstruction before: instruction
	| push tile |
	push := OUnaryOperation receiver: anInstruction name: #push.
	anInstruction addUse: push at: #receiver.
	instruction beforeInsert: push.
	tile := self newTile: push.
	self tile: push as: tile beUsed.
	^push
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
newTile: instruction
	^OTiling for: instruction
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
numberArguments
	| count instruction i |
	count := 0.
	instruction := firstBlock firstInstruction next.
	[instruction next isLoadImplicit] whileTrue: [
		instruction := instruction next.
		count := count + 1].
	i := 0.
	[i < count] whileTrue: [
		instruction name: i + 3.
		instruction := instruction prev.
		i := i + 1]
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeUnused
	firstBlock instructionsWithSuccessorsDo: [:instruction | | tile |
		tile := self tileOf: instruction.
		(tile instruction == instruction and: [tile isUsed])
			ifFalse: [instruction replaceAllUsesWith: tile instruction; dissolve]]
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selectorFor: name
	^(#send , (messages at: name ifAbsent: [#GenericMessage:])) asSymbol
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
send: instruction left: left commutativeRight: right
	right isConstant
		ifTrue: [^self tile: instruction using: left toConstant: right value].
	left isConstant
		ifTrue: [^self tile: instruction using: right toConstant: left value].
	self tile: instruction using: left to: right
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
send: instruction left: left comparedTo: right
	right isConstant
		ifTrue: [^self tile: instruction using: left toConstant: right value].
	left isConstant
		ifTrue: [^(self tile: instruction using: right toConstant: left value) invertOperation].
	self tile: instruction using: left to: right
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
send: instruction left: left minusRight: right
	right isConstant
		ifTrue: [^self tile: instruction using: left toConstant: right value].
	left isConstant
		ifTrue: [^(self doesntWork
			tile: instruction
			using: right
			toConstant: 0 - left value)
			invert].
	self tile: instruction using: left to: right
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
send: instruction left: left right: right
	right isConstant
		ifTrue: [^self tile: instruction using: left toConstant: right value].
	left isConstant
		ifTrue: [^self tile: instruction using: right toConstant: left value].
	self tile: instruction using: left to: right
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
send: instruction receiver: receiver
	receiver isConstant ifTrue: [^self tile: instruction toConstant: receiver].
	self tile: instruction receiver: receiver
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
send: instruction receiver: receiver left: left right: right
	"
	right isConstant
		ifTrue: [^self tile: instruction using: left toConstant: right value].
	left isConstant
		ifTrue: [^self tile: instruction using: right toConstant: left value].
	"
	self
		tile: instruction
		using: receiver
		left: left
		right: right
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendBinary: instruction
	self
		send: instruction
		left: instruction receiver
		right: instruction arguments first
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendCommutativeBinary: instruction
	self
		send: instruction
		left: instruction receiver
		commutativeRight: instruction arguments first
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendCompare: instruction
	self
		send: instruction
		left: instruction receiver
		comparedTo: instruction arguments first
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendGenericMessage: instruction
	| arguments values tile new |
	arguments := instruction arguments.
	values := Array with: instruction receiver withAll: arguments.
	new := arguments
		collect: [:argument | self insertPush: argument before: instruction].
	instruction arguments: new.
	arguments do: [:argument | argument removeUse: instruction].
	values do: [:value | (self tileOf: value) beUsed].
	tile := self newTile: instruction.
	self
		tile: instruction as: tile beUsed;
		insertCopyResultAfter: instruction
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendMinus: instruction
	self
		send: instruction
		left: instruction receiver
		minusRight: instruction arguments first
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendNot: instruction
	| negated tile |
	negated := (self tileOf: instruction receiver) beUsed.
	negated instruction negateOperation.
	tile := self newTile: instruction.
	self tile: instruction as: tile.
	^instruction
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendTernary: instruction
	self
		send: instruction
		receiver: instruction receiver
		left: instruction arguments first
		right: instruction arguments second
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sendUnary: instruction
	self send: instruction receiver: instruction receiver
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
tile: instruction as: tile
	tiles at: instruction put: tile
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
tile: instruction receiver: receiver
	| receivertile new tile |
	receivertile := (self tileOf: receiver) beUsed.
	new := OUnaryOperation new receiver: receiver; name: instruction selector.
	receiver addUse: new at: #receiver.
	instruction beforeInsert: new.
	tile := self newTile: new.
	self
		tile: new as: tile;
		tile: instruction as: tile.
	^new
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
tile: instruction using: receiver left: left right: right
	| lefttile righttile receivertile tile new |
	receivertile := (self tileOf: receiver) beUsed.
	lefttile := (self tileOf: left) beUsed.
	righttile := (self tileOf: right) beUsed.
	new := OTernaryOperation
		receiver: receiver
		left: left
		right: right
		name: instruction selector.
	receiver addUse: new at: #receiver.
	left addUse: new at: #left.
	right addUse: new at: #right.
	instruction beforeInsert: new.
	tile := self newTile: new.
	self
		tile: new as: tile beUsed;
		tile: instruction as: righttile "for at:put:".
	^new
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
tile: instruction using: left to: right
	| lefttile righttile tile new |
	lefttile := (self tileOf: left) beUsed.
	righttile := (self tileOf: right) beUsed.
	new := OBinaryVariableOperation
		left: left
		right: right
		name: instruction selector.
	left addUse: new at: #left.
	right addUse: new at: #right.
	instruction beforeInsert: new.
	tile := self newTile: new.
	self
		tile: new as: tile;
		tile: instruction as: tile.
	^new
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
tile: instruction using: left toConstant: value
	| lefttile new tile |
	lefttile := (self tileOf: left) beUsed.
	new := OBinaryConstantOperation
		left: left
		right: value
		name: instruction selector.
	left addUse: new at: #left.
	instruction beforeInsert: new.
	tile := self newTile: new.
	self
		tile: new as: tile;
		tile: instruction as: tile.
	^new
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
tileOf: instruction
	^tiles at: instruction
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: instruction
	| new |
	new := self newTile: instruction.
	self tile: instruction as: new beUsed
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: instruction
	| tile new |
	tile := self tileOf: instruction variable.
	tile beUsed.
	new := self newTile: instruction.
	self tile: instruction as: new beUsed
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: instruction
	| tile new |
	tile := self tileOf: instruction variable.
	tile beUsed.
	new := self newTile: instruction.
	self tile: instruction as: new beUsed
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: instruction
	| tile |
	tile := self newTile: instruction.
	self tile: instruction as: tile
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	| tile sourcetile new |
	instruction name isSmallInteger
		ifTrue: [
			sourcetile := (self tileOf: instruction source) beUsed.
			new := OBinaryConstantOperation
				left: instruction source
				right: instruction name
				name: #_basicAt:.
			instruction source addUse: new at: #left.
			instruction beforeInsert: new; replaceAllUsesWith: new; dissolve.
			tile := self newTile: new.
			self tile: new as: tile]
		ifFalse: [
			tile := self newTile: instruction.
			self tile: instruction as: tile.
			instruction name == #activationRecord ifTrue: [tile beUsed]]
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: instruction
	| selector |
	selector := self selectorFor: instruction selector.
	self perform: selector with: instruction
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: instruction
	| tile |
	instruction variables
		collect: [:source | self tileOf: source]
		thenDo: #beUsed.
	tile := self newTile: instruction.
	self tile: instruction as: tile
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: instruction
	| tile new |
	tile := self tileOf: instruction source.
	tile beUsed.
	new := self newTile: instruction.
	self tile: instruction as: new beUsed
! !

!OptimizingInstructionSelector methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	| tile new |
	tile := self tileOf: instruction receiver.
	tile beUsed.
	new := self newTile: instruction.
	self tile: instruction as: new beUsed
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingInstructionSelector class' category: #OCompiler!
OptimizingInstructionSelector class
	instanceVariableNames: ''!

!OptimizingInstructionSelector class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingInstructionSelector initialize!

