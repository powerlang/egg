"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OOperand,
	#superclass : #Object,
	#instVars : [
		'instruction',
		'name',
		'nextUse'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OOperand class >> at: anInstruction named: operandName [
	^self new instruction: anInstruction; name: operandName
]

{ #category : #unclassified }
OOperand class >> valued: anInstruction [
	^self new value: anInstruction
]

{ #category : #unclassified }
OOperand class >> valued: anInstruction in: containingInstruction [
	^self new value: anInstruction; instruction: containingInstruction
]

{ #category : #unclassified }
OOperand >> addUse: anOperand [
	self DENY: self == anOperand.
	nextUse ifNil: [nextUse := anOperand] ifNotNil: [nextUse addUse: anOperand]
]

{ #category : #unclassified }
OOperand >> asOperand [
	self halt
]

{ #category : #unclassified }
OOperand >> definition [
	^instruction atOperand: name
]

{ #category : #unclassified }
OOperand >> duplicateWith: map [
	| copy |
	map at: self ifPresent: [:i | ^i].
	copy := self class new.
	map at: self put: copy.
	instruction ifNotNil: [copy instruction: (instruction duplicateWith: map)].
	copy name: name.
	nextUse ifNotNil: [copy nextUse: (nextUse duplicateWith: map)].
	^copy
]

{ #category : #unclassified }
OOperand >> instruction [
	^instruction
]

{ #category : #unclassified }
OOperand >> instruction: anInstruction [
	instruction := anInstruction
]

{ #category : #unclassified }
OOperand >> name [
	^name
]

{ #category : #unclassified }
OOperand >> name: operandName [
	name := operandName
]

{ #category : #unclassified }
OOperand >> nextUse [
	^nextUse
]

{ #category : #unclassified }
OOperand >> nextUse: anOOperand [
	nextUse := anOOperand
]

{ #category : #unclassified }
OOperand >> printOn: aStream [
	aStream
		nextPutAll: '[op #' , name printString , '@' , instruction printString
			, ']'
]

{ #category : #unclassified }
OOperand >> removeUse: anOperand [
	nextUse instruction == anOperand
		ifTrue: [
			nextUse := nextUse nextUse.
			anOperand nextUse: nil]
		ifFalse: [nextUse removeUse: anOperand]
]

{ #category : #unclassified }
OOperand >> removeUse: anInstruction at: aName [
	(nextUse instruction == anInstruction and: [nextUse name = aName])
		ifTrue: [nextUse := nextUse nextUse]
		ifFalse: [nextUse removeUse: anInstruction at: aName]
]

{ #category : #unclassified }
OOperand >> removeUseBy: anInstruction [
	nextUse instruction == anInstruction
		ifTrue: [nextUse := nextUse nextUse]
		ifFalse: [nextUse removeUseBy: anInstruction]
]

{ #category : #unclassified }
OOperand >> replaceAllUsesWith: otherInstruction [
	| following |
	following := nextUse.
	self transferUseTo: otherInstruction.
	following ifNotNil: [following replaceAllUsesWith: otherInstruction]
]

{ #category : #unclassified }
OOperand >> replaceUsesBy: user with: otherInstruction [
	| following |
	following := nextUse.
	instruction == user ifTrue: [self transferUseTo: otherInstruction].
	following ifNotNil: [following replaceUsesBy: user with: otherInstruction]
]

{ #category : #unclassified }
OOperand >> transferUseTo: otherInstruction [
	self DENY: otherInstruction class == OOperand.
	self definition removeUse: self.
	instruction atOperand: name put: otherInstruction.
	otherInstruction addUse: self
]

{ #category : #unclassified }
OOperand >> user [
	^instruction
]

{ #category : #unclassified }
OOperand >> usesDo: aBlock [
	aBlock value: self.
	nextUse ifNotNil: [nextUse usesDo: aBlock]
]

{ #category : #unclassified }
OOperand >> validate [
	| set op |
	set := IdentitySet new.
	op := self.
	[op notNil] whileTrue: [
		(set includes: op) ifTrue: [self error: 'invalid operand'].
		set add: op.
		op := op nextUse]
]
