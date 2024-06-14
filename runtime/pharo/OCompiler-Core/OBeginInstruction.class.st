"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OBeginInstruction',
	#superclass : 'OControlInstruction',
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core-IR'
}

{ #category : 'unclassified' }
OBeginInstruction >> basicAcceptVisitor: aVisitor [
	
]

{ #category : 'unclassified' }
OBeginInstruction >> detect: aBlock ifNone: absentBlock [
	^next detect: aBlock ifNone: absentBlock
]

{ #category : 'unclassified' }
OBeginInstruction >> do: aBlock [
	next do: aBlock
]

{ #category : 'unclassified' }
OBeginInstruction >> printBackwardOn: aStream [
	
]

{ #category : 'printing' }
OBeginInstruction >> printStringUsing: names [
	| stream |
	stream := '' writeStream.
	next printForwardOn: stream using: names.
	^stream contents
]

{ #category : 'enumerating' }
OBeginInstruction >> realReverseDo: aBlock [
	
]

{ #category : 'enumerating' }
OBeginInstruction >> reverseDo: aBlock [
	
]
