'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OInstruction category: #IR!
OValue subclass: #OInstruction
	instanceVariableNames: 'prev next firstUse'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OInstruction commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: aVisitor
	| following current |
	current := self.
	[
		following := current next.
		current isEnd]
		whileFalse: [
			current basicAcceptVisitor: aVisitor.
			current := current next ifNil: [following]]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addLast: anInstruction
	next addLast: anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addNext: anInstruction
	^self afterInsert: anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addUse: new
	firstUse ifNil: [firstUse := new] ifNotNil: [firstUse addUse: new]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addUse: user at: name
	| operand |
	operand := OOperand at: user named: name.
	self addUse: operand
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
afterInsert: anInstruction
	anInstruction next: next.
	anInstruction prev: self.
	next prev: anInstruction.
	next := anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
afterInsertAll: anInstruction
	| last |
	last := anInstruction last.
	last next: next.
	anInstruction prev: self.
	next prev: last.
	next := anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allUses
	| result following |
	result := OrderedCollection new.
	following := firstUse.
	[following notNil] whileTrue: [
		result add: following.
		following := following nextUse].
	^result
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureBoundBy: binder
	
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name
	^self subclassResponsibility
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: operandName put: instruction
	^self subclassResponsibility
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^self primitivePrintString
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
beforeInsert: anInstruction
	anInstruction next: self.
	anInstruction prev: prev.
	prev next: anInstruction.
	prev := anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
beforeInsertAll: anInstruction
	| last |
	last := anInstruction "last".
	last next: self.
	anInstruction prev: prev.
	prev next: anInstruction.
	prev := last.
	self shouldBeImplemented
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
cutFollowing
	| end |
	end := OEndInstruction new.
	end prev: self.
	next := end.
	^end
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
cutPrevious
	| begin |
	begin := OBeginInstruction new.
	begin next: self.
	prev := begin.
	^begin
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
detect: aBlock
	^self detect: aBlock ifNone: [self errorAbsentObject]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
detect: aBlock ifNone: absentBlock
	(aBlock value: self)
		ifTrue: [^self]
		ifFalse: [^next detect: aBlock ifNone: absentBlock]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dissolve
	self untie; operandsDo: [:instruction | instruction removeUse: self]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dissolveIfUnused
	self isUsed ifFalse: [self dissolve]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dissolveReplacingWith: anInstruction
	prev next: anInstruction.
	next prev: anInstruction.
	anInstruction prev: prev.
	anInstruction next: next.
	prev := next := nil.
	self operandsDo: [:instruction | instruction removeUse: self].
	self replaceAllUsesWith: anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dissolveReplacingWithAll: instructions
	| last |
	last := instructions last.
	prev next: instructions.
	instructions prev: prev.
	last next: next.
	next prev: last.
	prev := next := nil.
	self operandsDo: [:instruction | instruction removeUse: self].
	self replaceAllUsesWith: last
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
do: aBlock
	| following |
	following := next.
	aBlock value: self.
	next ifNil: [following do: aBlock] ifNotNil: [next do: aBlock]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstNonPhi
	| current |
	current := self.
	[current isPhi] whileTrue: [current := current next].
	^current
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstUse
	^firstUse
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasNext
	^true
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasPrev
	^true
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopyBefore: anInstruction
	| copy |
	copy := self newCopy.
	anInstruction beforeInsert: copy.
	^copy
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPushBefore: anInstruction
	| push |
	push := OUnaryOperation receiver: self name: #push.
	self addUse: push at: #receiver.
	anInstruction beforeInsert: push.
	^push
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isBlockStart
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isConditionalJump
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isConstant
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isDefineArgument
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isDefinedAt: aBlock
	aBlock instructionsDo: [:instruction | instruction == self ifTrue: [^true]].
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEnd
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isGenericMessage
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isInstruction
	^true
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJump
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLoadImplicit
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMessageSend
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPhi
	^false
! !

!OInstruction methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPrimitiveOperation
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isReturn
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStoreVariable
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUnconditionalJump
	^self isJump andNot: [self isConditionalJump]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUsed
	^firstUse notNil
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUsedJustOnce
	^firstUse notNil and: [firstUse nextUse isNil]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUsedOnlyBy: instruction
	^self isUsedJustOnce and: [firstUse user == instruction]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
last
	^next last
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastPhi
	| current |
	current := self.
	[current next isPhi] whileTrue: [current := current next].
	^current
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastValue
	| last |
	last := self last.
	^last isJump ifTrue: [last prev] ifFalse: [last]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
livesAfter: anInstruction
	anInstruction
		nextDetect: [:instruction | instruction usesResultOf: self]
		ifNone: [^false].
	^true
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
livesAfter: anInstruction orOutOf: aBasicBlock
	^(self livesAfter: anInstruction) or: [self livesOutOfBlock: aBasicBlock]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
livesOutOfBlock: aBasicBlock
	aBasicBlock successorsPostOrder
		reverseDo: [:block | (block usesResultOf: self) ifTrue: [^true]].
	^false
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
newCopy
	| copy |
	copy := OUnaryOperation receiver: self name: #copy.
	self addUse: copy at: #receiver.
	^copy
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
next
	^next
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
next: anInstruction
	self DENY: (self isJump and: [anInstruction isEnd not]).
	next := anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextDetect: aBlock ifNone: absentBlock
	^next detect: aBlock ifNone: absentBlock
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operands
	| result |
	result := OrderedCollection new.
	self operandsDo: [:o | result add: o].
	^result select: #isInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	self subclassResponsibility
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
prev
	^prev
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
prev: anInstruction
	prev := anInstruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^self class name
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printBackwardOn: aStream
	aStream size > 1000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	prev printBackwardOn: aStream.
	aStream nextPutAll: self basicPrintString; cr
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printForwardOn: aStream
	aStream size > 100000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream nextPutAll: self basicPrintString; cr.
	next printForwardOn: aStream
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printForwardOn: aStream using: names
	aStream size > 100000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream
		nextPutAll: (names at: self) , ' := ' , (self printStringUsing: names);
		cr.
	next printForwardOn: aStream using: names
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	"
	prev printBackwardOn: aStream.
	aStrem nextPutAll: '-> '
	"
	aStream
		nextPutAll: self basicPrintString
	"	next printForwardOn: aStream cr"
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
realReverseDo: aBlock
	| following |
	following := prev.
	aBlock value: self.
	prev
		ifNil: [following realReverseDo: aBlock]
		ifNotNil: [prev realReverseDo: aBlock]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeUse: instruction
	firstUse instruction == instruction
		ifTrue: [firstUse := firstUse nextUse]
		ifFalse: [firstUse removeUse: instruction]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeUse: instruction at: name
	(firstUse instruction == instruction and: [firstUse name = name])
		ifTrue: [firstUse := firstUse nextUse]
		ifFalse: [firstUse removeUse: instruction at: name]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceAllUsesWith: anInstruction
	self == anInstruction ifTrue: [^self].
	firstUse ifNotNil: [
		firstUse replaceAllUsesWith: anInstruction.
		anInstruction addUse: firstUse.
		firstUse := nil]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceOperand: name with: instruction
	| previous |
	previous := self atOperand: name.
	previous removeUse: self.
	self atOperand: name put: instruction.
	instruction addUse: self at: name
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceUsesOf: value with: instruction
	self operandsDo: [:operand | 
		operand = value ifTrue: [
			operand
				usesDo: [:use | use user = self
					ifTrue: [use disolveReplacingWith: instruction]]]]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceWithCopyOf: value
	| instruction |
	instruction := ((value isUsedOnlyBy: self) andNot: [value isPhi])
		ifTrue: [value untie]
		ifFalse: [value newCopy].
	self dissolveReplacingWith: instruction.
	^instruction
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
reverseDo: aBlock
	| following |
	following := prev.
	aBlock value: self.
	prev
		ifNil: [following reverseDo: aBlock]
		ifNotNil: [prev reverseDo: aBlock]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
targets
	^OrderedCollection new
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
untie
	prev next: next.
	next prev: prev.
	prev := next := nil
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateUser: instruction named: oldName with: newName
	self usesDo: [:use | 
		(use instruction == instruction and: [use name == oldName])
			ifTrue: [use name: newName]]
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
useDistanceTo: value
	| count |
	count := 0.
	self do: [:instruction | 
		(instruction usesResultOf: value) ifTrue: [^count].
		count := count + 1].
	^Number infinity
! !

!OInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesDo: aBlock
	firstUse ifNotNil: [firstUse usesDo: aBlock]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OInstruction class' category: #IR!
OInstruction class
	instanceVariableNames: ''!

!OInstruction class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
empty
	| begin last |
	begin := OBeginInstruction new.
	last := OEndInstruction new.
	begin next: last.
	last prev: begin.
	^begin
! !


