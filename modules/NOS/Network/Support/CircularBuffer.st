Class {
	#name : #CircularBuffer,
	#superclass : #SequenceableCollection,
	#instVars : [
		'buffer',
		'head',
		'tally'
	],
	#category : 'SqueakNOS-Net-Support'
}

{ #category : #'as yet unclassified' }
CircularBuffer class >> new [
	^ self new: 512
]

{ #category : #'as yet unclassified' }
CircularBuffer class >> new: anInteger [
	^ super new initialize: anInteger
]

{ #category : #adding }
CircularBuffer >> add: anObject [
	tally < buffer size ifFalse: [^ self errorOutOfBounds].
	buffer at: head + tally - 1 \\ buffer size + 1 put: anObject.
	tally := tally + 1.
	^ anObject
]

{ #category : #'as yet unclassified' }
CircularBuffer >> at: anInteger [
	(anInteger > 0 and: [anInteger <= tally]) ifFalse: [^ self errorOutOfBounds].
	^ buffer at: head + anInteger - 2 \\ buffer size + 1
]

{ #category : #'as yet unclassified' }
CircularBuffer >> capacity [
	^ buffer size - self size
]

{ #category : #'initialize-release' }
CircularBuffer >> initialize: capacity [
	buffer := ByteArray new: capacity.
	head := 1.
	tally := 0
]

{ #category : #accessing }
CircularBuffer >> next [
	| answer |
	tally > 0 ifFalse: [^ self errorOutOfBounds].
	answer := self first.
	tally := tally - 1.
	head := head \\ buffer size + 1.
	^ answer
]

{ #category : #accessing }
CircularBuffer >> nextPut: anObject [
	tally < buffer size ifFalse: [^ self errorOutOfBounds].
	buffer at: head + tally - 1 \\ buffer size + 1 put: anObject.
	tally := tally + 1.
	^ anObject
]

{ #category : #'as yet unclassified' }
CircularBuffer >> nextPutAll: aCollection [
	aCollection do: [ :each | self nextPut: each]
]

{ #category : #removing }
CircularBuffer >> removeFirst [
	| answer |
	tally > 0 ifFalse: [^ self errorOutOfBounds].
	answer := self first.
	tally := tally - 1.
	head := head \\ buffer size + 1.
	^ answer
]

{ #category : #'as yet unclassified' }
CircularBuffer >> size [
	^ tally
]
