Class {
	#name : #BlockArithmetic,
	#superclass : #Object,
	#instVars : [
		'blockSize'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #accessing }
BlockArithmetic >> alignedFrom: first to: last do: aBlock [
	| nextEnd remaining |
	
	nextEnd := last min: (self lastPositionInSameBlockOf: first).
	aBlock value: first value: nextEnd.
	remaining := last - nextEnd.
	[remaining > 0] whileTrue: [ | nextStart |
		nextStart := nextEnd + 1.
		nextEnd := nextEnd + (remaining min: blockSize).
		aBlock value: nextStart value: nextEnd.
		remaining := remaining - blockSize.
	].
	
]

{ #category : #accessing }
BlockArithmetic >> alignedStart: first end: last with: aBlock [
	aBlock value: (self firstPositionInSameBlockOf: first) value: (self lastPositionInSameBlockOf: last).
]

{ #category : #accessing }
BlockArithmetic >> blockNumberOf: anInteger [
	^anInteger - 1 // self blockSize + 1.
]

{ #category : #accessing }
BlockArithmetic >> blockSize [
	"Answer the value of blockSize"

	^ blockSize
]

{ #category : #accessing }
BlockArithmetic >> blockSize: anObject [
	"Set the value of blockSize"

	blockSize := anObject
]

{ #category : #accessing }
BlockArithmetic >> firstPositionInSameBlockOf: position [
	^position - (position - 1 \\ blockSize)
]

{ #category : #accessing }
BlockArithmetic >> from: first to: last do: aBlock [
	first to: last by: blockSize do: [ :next | aBlock value: next ].
]

{ #category : #accessing }
BlockArithmetic >> lastPositionInSameBlockOf: position [
	^(self firstPositionInSameBlockOf: position) + blockSize - 1.
]

{ #category : #accessing }
BlockArithmetic >> positionInBlockOf: position [
	^ position - 1 \\ blockSize + 1.
]

{ #category : #accessing }
BlockArithmetic >> size [
	"Answer the value of blockSize"

	^ blockSize
]

{ #category : #accessing }
BlockArithmetic >> size: anObject [
	"Set the value of blockSize"

	blockSize := anObject
]
