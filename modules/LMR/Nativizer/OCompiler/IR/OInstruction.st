"
    Copyright (c) 2020 Aucerna.
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
	#category : #IR
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
OInstruction >> afterInsert: start to: last [
	last afterConnect: next.
	self afterConnect: start
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

{ #category : #accessing }
OInstruction >> basicBlock [
	^prev basicBlock
]

{ #category : #unclassified }
OInstruction >> beforeInsert: anInstruction [
	prev afterConnect: anInstruction.
	anInstruction afterConnect: self
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

{ #category : #unclassified }
OInstruction >> detect: aBlock [
	^self detect: aBlock ifNone: [self errorAbsentObject]
]

{ #category : #unclassified }
OInstruction >> detect: aBlock ifNone: absentBlock [
	(aBlock value: self)
		ifTrue: [^self]
		ifFalse: [^next detect: aBlock ifNone: absentBlock]
]

{ #category : #unclassified }
OInstruction >> dissolve [
	self remove; operandsDo: [:instruction | instruction removeUseBy: self]
]

{ #category : #unclassified }
OInstruction >> dissolveIfUnused [
	self isUsed ifFalse: [self dissolve]
]

{ #category : #unclassified }
OInstruction >> dissolveReplacingWith: anInstruction [
	anInstruction afterConnect: next.
	prev afterConnect: anInstruction.
	prev := next := nil.
	self operandsDo: [:instruction | instruction removeUseBy: self].
	self replaceAllUsesWith: anInstruction
]

{ #category : #unclassified }
OInstruction >> do: aBlock [
	| following |
	following := next.
	aBlock value: self.
	next ifNil: [following do: aBlock] ifNotNil: [next do: aBlock]
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
	self addUse: push at: #receiver.
	anInstruction beforeInsert: push.
	^push
]

{ #category : #unclassified }
OInstruction >> isBlockParameter [
	^false
]

{ #category : #unclassified }
OInstruction >> isBlockStart [
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
OInstruction >> isDefineArgument [
	^false
]

{ #category : #unclassified }
OInstruction >> isDefinedAt: aBlock [
	aBlock instructionsDo: [:instruction | instruction == self ifTrue: [^true]].
	^false
]

{ #category : #unclassified }
OInstruction >> isEnd [
	^false
]

{ #category : #unclassified }
OInstruction >> isFrame [
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
OInstruction >> isLoadImplicit [
	^false
]

{ #category : #unclassified }
OInstruction >> isMessageSend [
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
OInstruction >> isStoreVariable [
	^false
]

{ #category : #unclassified }
OInstruction >> isUnconditionalJump [
	^self isJump andNot: [self isConditionalJump]
]

{ #category : #testing }
OInstruction >> isUntied [
	^prev isNil
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
OInstruction >> last [
	^next last
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
	| copy |
	copy := OUnaryOperation receiver: self name: #copy.
	self addUse: copy at: #receiver.
	^copy
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

{ #category : #unclassified }
OInstruction >> printForwardOn: aStream using: names [
	aStream size > 100000 ifTrue: [
		aStream nextPutAll: '...'.
		^self].
	aStream
		nextPutAll: (names at: self) , ' := ' , (self printStringUsing: names);
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
	firstUse == anOperand
		ifTrue: [
			firstUse := anOperand nextUse.
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
	firstUse ifNotNil: [
		firstUse replaceAllUsesWith: anInstruction.
		anInstruction addUse: firstUse.
		firstUse := nil]
]

{ #category : #unclassified }
OInstruction >> replaceOperand: name with: instruction [
	| previous |
	previous := self atOperand: name.
	previous removeUse: self at: name.
	self atOperand: name put: instruction.
	instruction addUse: self at: name
]

{ #category : #unclassified }
OInstruction >> replaceUsesBy: user with: instruction [
	firstUse ifNotNil: [firstUse replaceUsesBy: user with: instruction]
]

{ #category : #unclassified }
OInstruction >> replaceWithCopyOf: value [
	| instruction |
	instruction := ((value isUsedOnlyBy: self) andNot: [value isBlockParameter])
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

{ #category : #unclassified }
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

