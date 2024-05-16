"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OInstruction,
	#superclass : #OValue,
	#instVars : [
		'prev',
		'next',
		'firstUse'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OInstruction >> acceptVisitor: aVisitor [
	| following current |
	current := self.
	[
		following := current next.
		current isEnd]
		whileFalse: [
			current basicAcceptVisitor: aVisitor.
			current := current next ifNil: [following]]
]

{ #category : #unclassified }
OInstruction >> addLast: anInstruction [
	next addLast: anInstruction
]

{ #category : #unclassified }
OInstruction >> addNext: anInstruction [
	^self afterInsert: anInstruction
]

{ #category : #unclassified }
OInstruction >> addUse: new [
	firstUse ifNil: [firstUse := new] ifNotNil: [firstUse addUse: new]
]

{ #category : #unclassified }
OInstruction >> addUse: user at: name [
	| operand |
	operand := OOperand at: user named: name.
	self addUse: operand
]

{ #category : #unclassified }
OInstruction >> afterConnect: anInstruction [
	anInstruction prev: self.
	next := anInstruction
]

{ #category : #unclassified }
OInstruction >> afterInsert: anInstruction [
	anInstruction afterConnect: next.
	self afterConnect: anInstruction
]

{ #category : #unclassified }
OInstruction >> afterInsert: start to: end [
	end afterConnect: next.
	self afterConnect: start
]

{ #category : #unclassified }
OInstruction >> afterInsertAll: anInstruction [
	self afterInsert: anInstruction to: anInstruction last
]

{ #category : #unclassified }
OInstruction >> allUses [
	| result following |
	result := OrderedCollection new.
	following := firstUse.
	[following notNil] whileTrue: [
		result add: following.
		following := following nextUse].
	^result
]

{ #category : #unclassified }
OInstruction >> assureBoundBy: binder [
	
]

{ #category : #unclassified }
OInstruction >> atOperand: name [
	^self subclassResponsibility
]

{ #category : #unclassified }
OInstruction >> atOperand: operandName put: instruction [
	^self subclassResponsibility
]

{ #category : #unclassified }
OInstruction >> basicPrintString [
	^self primitivePrintString
]

{ #category : #unclassified }
OInstruction >> beforeInsert: anInstruction [
	prev afterConnect: anInstruction.
	^anInstruction afterConnect: self
]

{ #category : #unclassified }
OInstruction >> beforeInsertAll: anInstruction [
	| last |
	last := anInstruction "last".
	last next: self.
	anInstruction prev: prev.
	prev next: anInstruction.
	prev := last.
	self shouldBeImplemented
]

{ #category : #testing }
OInstruction >> canHaveSideEffects [
	^true
]

{ #category : #unclassified }
OInstruction >> changeUseFrom: anInstruction to: anotherInstruction at: operand [
	anotherInstruction addUse: self at: operand.
	anInstruction removeUse: self at: operand
]

{ #category : #private }
OInstruction >> copyTo: copy with: map [
	
]

{ #category : #unclassified }
OInstruction >> detect: aBlock [
	^self detect: aBlock ifNone: [self errorAbsentObject]
]

{ #category : #unclassified }
OInstruction >> detect: aBlock ifNone: absentBlock [
	^(aBlock value: self)
		ifTrue: [self]
		ifFalse: [next detect: aBlock ifNone: absentBlock]
]

{ #category : #unclassified }
OInstruction >> dissolve [
	self remove; operandsDo: [:instruction | instruction removeUseBy: self]
]

{ #category : #unclassified }
OInstruction >> dissolveDeep [
	prev ifNil: [^self].
	self
		remove;
		operandsDo: [:instruction | instruction
			removeUseBy: self;
			dissolveIfUseless]
]

{ #category : #unclassified }
OInstruction >> dissolveIfUnused [
	self isUsed ifFalse: [self dissolve]
]

{ #category : #unclassified }
OInstruction >> dissolveIfUseless [
	self isUseless ifTrue: [self dissolveDeep]
]

{ #category : #unclassified }
OInstruction >> dissolveReplacingWith: anInstruction [
	anInstruction afterConnect: next.
	prev afterConnect: anInstruction.
	prev := next := nil.
	self
		operandsDo: [:instruction | instruction
			removeUseBy: self;
			dissolveIfUseless];
		replaceAllUsesWith: anInstruction
]

{ #category : #unclassified }
OInstruction >> do: aBlock [
	| following |
	following := next.
	aBlock value: self.
	next ifNil: [following do: aBlock] ifNotNil: [next do: aBlock]
]

{ #category : #unclassified }
OInstruction >> duplicateWith: map [
	| copy |
	map at: self ifPresent: [:c | ^c].
	copy := self class new.
	map at: self put: copy.
	prev ifNotNil: [copy prev: (prev duplicateWith: map)].
	next ifNotNil: [copy next: (next duplicateWith: map)].
	self copyTo: copy with: map.
	^copy
]

{ #category : #unclassified }
OInstruction >> firstNonPhi [
	| current |
	current := self.
	[current isPhi] whileTrue: [current := current next].
	^current
]

{ #category : #unclassified }
OInstruction >> firstUse [
	^firstUse
]

{ #category : #unclassified }
OInstruction >> hasNext [
	^true
]

{ #category : #unclassified }
OInstruction >> hasPrev [
	^true
]

{ #category : #unclassified }
OInstruction >> insertCopyBefore: anInstruction [
	| copy |
	copy := self newCopy.
	anInstruction beforeInsert: copy.
	^copy
]

{ #category : #unclassified }
OInstruction >> insertPushBefore: anInstruction [
	| push |
	push := OUnaryOperation receiver: self name: #push.
	anInstruction beforeInsert: push.
	^push
]

{ #category : #unclassified }
OInstruction >> isActivation [
	^false
]

{ #category : #unclassified }
OInstruction >> isBlockClosure [
	^false
]

{ #category : #unclassified }
OInstruction >> isBlockStart [
	^false
]

{ #category : #unclassified }
OInstruction >> isBoolean [
	^false
]

{ #category : #unclassified }
OInstruction >> isComparison [
	^false
]

{ #category : #unclassified }
OInstruction >> isConditionalJump [
	^false
]

{ #category : #unclassified }
OInstruction >> isConstant [
	^false
]

{ #category : #unclassified }
OInstruction >> isEnd [
	^false
]

{ #category : #unclassified }
OInstruction >> isGenericMessage [
	^false
]

{ #category : #unclassified }
OInstruction >> isInstruction [
	^true
]

{ #category : #unclassified }
OInstruction >> isJump [
	^false
]

{ #category : #unclassified }
OInstruction >> isLoad [
	^false
]

{ #category : #unclassified }
OInstruction >> isLoadImplicit [
	^false
]

{ #category : #unclassified }
OInstruction >> isMemoryOperation [
	^false
]

{ #category : #unclassified }
OInstruction >> isMessageSend [
	^false
]

{ #category : #unclassified }
OInstruction >> isPhi [
	^false
]

{ #category : #testing }
OInstruction >> isPrimitiveOperation [
	^false
]

{ #category : #unclassified }
OInstruction >> isReturn [
	^false
]

{ #category : #unclassified }
OInstruction >> isStore [
	^false
]

{ #category : #unclassified }
OInstruction >> isStoreVariable [
	^false
]

{ #category : #unclassified }
OInstruction >> isUnconditionalJump [
	^self isJump andNot: [self isConditionalJump]
]

{ #category : #unclassified }
OInstruction >> isUsed [
	^firstUse notNil
]

{ #category : #unclassified }
OInstruction >> isUsedJustOnce [
	^firstUse notNil and: [firstUse nextUse isNil]
]

{ #category : #unclassified }
OInstruction >> isUsedOnlyBy: instruction [
	^self isUsedJustOnce and: [firstUse user == instruction]
]

{ #category : #unclassified }
OInstruction >> isUseless [
	^firstUse isNil andNot: [self canHaveSideEffects]
]

{ #category : #unclassified }
OInstruction >> last [
	^next last
]

{ #category : #unclassified }
OInstruction >> lastPhi [
	| current |
	current := self.
	[current next isPhi] whileTrue: [current := current next].
	^current
]

{ #category : #unclassified }
OInstruction >> lastValue [
	| last |
	last := self last.
	^last isJump ifTrue: [last prev] ifFalse: [last]
]

{ #category : #unclassified }
OInstruction >> livesAfter: anInstruction [
	anInstruction
		nextDetect: [:instruction | instruction usesResultOf: self]
		ifNone: [^false].
	^true
]

{ #category : #unclassified }
OInstruction >> livesAfter: anInstruction orOutOf: aBasicBlock [
	^(self livesAfter: anInstruction) or: [self livesOutOfBlock: aBasicBlock]
]

{ #category : #unclassified }
OInstruction >> livesOutOfBlock: aBasicBlock [
	aBasicBlock successorsPostOrder
		reverseDo: [:block | (block usesResultOf: self) ifTrue: [^true]].
	^false
]

{ #category : #unclassified }
OInstruction >> newCopy [
	^OUnaryOperation receiver: self name: #copy
]

{ #category : #unclassified }
OInstruction >> next [
	^next
]

{ #category : #unclassified }
OInstruction >> next: anInstruction [
	self DENY: (self isJump and: [anInstruction isEnd not]).
	next := anInstruction
]

{ #category : #unclassified }
OInstruction >> nextDetect: aBlock ifNone: absentBlock [
	^next detect: aBlock ifNone: absentBlock
]

{ #category : #unclassified }
OInstruction >> operands [
	| result |
	result := OrderedCollection new.
	self operandsDo: [:o | result add: o].
	^result select: #isInstruction
]

{ #category : #unclassified }
OInstruction >> operandsDo: aBlock [
	self subclassResponsibility
]

{ #category : #unclassified }
OInstruction >> prev [
	^prev
]

{ #category : #unclassified }
OInstruction >> prev: anInstruction [
	prev := anInstruction
]

{ #category : #unclassified }
OInstruction >> primitivePrintString [
	^self class name
]

{ #category : #unclassified }
OInstruction >> printBackwardOn: aStream [
	aStream size > 1000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	prev printBackwardOn: aStream.
	aStream nextPutAll: self basicPrintString; cr
]

{ #category : #unclassified }
OInstruction >> printForwardOn: aStream [
	aStream size > 100000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream nextPutAll: self basicPrintString; cr.
	next printForwardOn: aStream
]

{ #category : #printing }
OInstruction >> printForwardOn: aStream using: names [
	aStream size > 10000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream
		nextPutAll: (names at: self ifAbsent: '?');
		nextPutAll: ' := ';
		nextPutAll: (self printStringUsing: names);
		cr.
	next printForwardOn: aStream using: names
]

{ #category : #unclassified }
OInstruction >> printOn: aStream [
	"
	prev printBackwardOn: aStream.
	aStrem nextPutAll: '-> '
	"
	aStream
		nextPutAll: self basicPrintString
	"	next printForwardOn: aStream cr"
]

{ #category : #unclassified }
OInstruction >> printStringUsing: names [
	^names at: self ifAbsent: ['?']
]

{ #category : #unclassified }
OInstruction >> realReverseDo: aBlock [
	| following |
	following := prev.
	aBlock value: self.
	prev
		ifNil: [following realReverseDo: aBlock]
		ifNotNil: [prev realReverseDo: aBlock]
]

{ #category : #unclassified }
OInstruction >> remove [
	prev afterConnect: next.
	prev := next := nil
]

{ #category : #unclassified }
OInstruction >> removeUse: anOperand [
	self _ASSERT: anOperand class == OOperand.
	firstUse == anOperand
		ifTrue: [
			firstUse := firstUse nextUse.
			anOperand nextUse: nil]
		ifFalse: [firstUse removeUse: anOperand]
]

{ #category : #unclassified }
OInstruction >> removeUse: instruction at: name [
	(firstUse instruction == instruction and: [firstUse name = name])
		ifTrue: [firstUse := firstUse nextUse]
		ifFalse: [firstUse removeUse: instruction at: name]
]

{ #category : #unclassified }
OInstruction >> removeUseBy: instruction [
	firstUse instruction == instruction
		ifTrue: [firstUse := firstUse nextUse]
		ifFalse: [firstUse removeUseBy: instruction]
]

{ #category : #unclassified }
OInstruction >> replaceAllUsesWith: anInstruction [
	self == anInstruction ifTrue: [^self].
	firstUse ifNil: [^self].
	firstUse replaceAllUsesWith: anInstruction.
	self _ASSERT: firstUse isNil
]

{ #category : #unclassified }
OInstruction >> replaceUsesBy: anInstruction with: anotherInstruction [
	firstUse
		ifNotNil: [firstUse replaceUsesBy: anInstruction with: anotherInstruction].
	^anotherInstruction
]

{ #category : #unclassified }
OInstruction >> replaceUsesOf: anInstruction with: anotherInstruction [
	self operandsDo: [:inst | 
		inst = anInstruction
			ifTrue: [inst replaceUsesBy: self with: anotherInstruction]]
]

{ #category : #unclassified }
OInstruction >> replaceWithCopyOf: value [
	| instruction |
	instruction := ((value isUsedOnlyBy: self) andNot: [value isPhi])
		ifTrue: [value remove]
		ifFalse: [value newCopy].
	self dissolveReplacingWith: instruction.
	^instruction
]

{ #category : #unclassified }
OInstruction >> reverseDo: aBlock [
	| following |
	following := prev.
	aBlock value: self.
	prev
		ifNil: [following reverseDo: aBlock]
		ifNotNil: [prev reverseDo: aBlock]
]

{ #category : #private }
OInstruction >> successorsDo: aBlock [
	
]

{ #category : #unclassified }
OInstruction >> targets [
	^OrderedCollection new
]

{ #category : #unclassified }
OInstruction >> updateUser: instruction named: oldName with: newName [
	self usesDo: [:use | 
		(use instruction == instruction and: [use name == oldName])
			ifTrue: [use name: newName]]
]

{ #category : #unclassified }
OInstruction >> useDistanceTo: value [
	| count |
	count := 0.
	self do: [:instruction | 
		(instruction usesResultOf: value) ifTrue: [^count].
		count := count + 1].
	^Number infinity
]

{ #category : #unclassified }
OInstruction >> usesDo: aBlock [
	firstUse ifNotNil: [firstUse usesDo: aBlock]
]

{ #category : #unclassified }
OInstruction >> validateUses [
	| found |
	found := Set new.
	self allUses do: [:use | 
		self _ASSERT: use definition == self.
		self _DENY: (found includes: use instruction -> use name).
		found add: use instruction -> use name]
]
