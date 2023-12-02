Class {
	#name : #WriteList,
	#superclass : #Object,
	#instVars : [
		'writeQueue',
		'blocksList'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
WriteList >> areIntersected: firstA to: lastA and: firstB to: lastB [
	firstA > lastB ifTrue: [^false].
	lastA < firstB ifTrue: [^false].
	^true.
]

{ #category : #'as yet unclassified' }
WriteList >> at: aPosition wrote: someData [
	self reserve: someData size at: aPosition.
	writeQueue add: { aPosition. someData }
]

{ #category : #'as yet unclassified' }
WriteList >> blocks [
	^ blocksList
]

{ #category : #'as yet unclassified' }
WriteList >> clear [
	
	writeQueue := OrderedCollection new.
	blocksList := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
WriteList >> do: aBlock [
	blocksList do: [ :block | aBlock value: (block at: 1) value: (block at: 2) - 1 value:
		 (writeQueue select: [ :write | (block at: 1) <= (write at: 1) and: [(block at: 2) > (write at: 1)]  ]) ].
]

{ #category : #'as yet unclassified' }
WriteList >> findLeftStart: startPosition end: endPosition [
	
	blocksList withIndexDo: [ :elem :index |
		((elem at: 2) >= startPosition) ifTrue: [
			((elem at: 1) <= endPosition) ifTrue: [^{index. true}] ifFalse: [^{index. false}].
		].
	].
	^{blocksList size + 1. false}.


]

{ #category : #'as yet unclassified' }
WriteList >> findRightStart: startPosition end: endPosition [
	| last |	
	blocksList withIndexDo: [ :elem :index |
		((elem at: 1) <= endPosition)
		  ifTrue: [
			last := index.
		] ifFalse: [
			^last.
		].
	].
	^last.


]

{ #category : #'as yet unclassified' }
WriteList >> initialize [
	self clear.
]

{ #category : #'as yet unclassified' }
WriteList >> removeAllNecesaryFrom: startPosition to: endPosition ifAdd: aBlock [
	| left right newStartPosition newEndPosition |
	left := self findLeftStart: startPosition end: endPosition.
	
	(left at: 2) ifFalse: [
			aBlock value: (left at: 1) value: startPosition value: endPosition.
	] ifTrue: [
		newStartPosition := startPosition min: ((blocksList at: (left at: 1)) at: 1).
	
		right := self findRightStart: startPosition end: endPosition.
		newEndPosition := endPosition max: ((blocksList at: right) at: 2).

		"(((left at: 1) == right) and: [(newStartPosition <= startPosition and: [ newEndPosition >= endPosition ])]) ifFalse: ["
			right to: (left at: 1) by: -1 do: [ :index | blocksList removeAt: index ].
			aBlock value: (left at: 1) value: newStartPosition value: newEndPosition.
		"]"
	] 


	
]

{ #category : #'as yet unclassified' }
WriteList >> reserve: size at: startPosition [

	| endPosition |
	endPosition := startPosition + size.

	self removeAllNecesaryFrom: startPosition to: endPosition ifAdd: [ :index :newStartPosition :newEndPosition |
		blocksList add: {newStartPosition. newEndPosition} beforeIndex: index.
	].
	
]

{ #category : #'as yet unclassified' }
WriteList >> writeFrom: firstByte to: lastByte into: aByteArray [
	| helper | 
	helper := BlockArithmetic new blockSize: aByteArray size.
	
	"self halt."
	writeQueue do: [ :write | | sourceStart sourceEnd |
		sourceStart := write at: 1.
		sourceEnd := sourceStart + (write at: 2) size - 1.
		(self areIntersected: firstByte to: lastByte and: sourceStart to: sourceEnd) ifTrue: [ | destStart destEnd |
			destStart := helper positionInBlockOf: (firstByte max: sourceStart).
			destEnd := helper positionInBlockOf: (lastByte min: sourceEnd).
			aByteArray replaceFrom: destStart to: destEnd with: (write at: 2) startingAt: (firstByte - sourceStart + 1 max: 1)
		]
	]
]
