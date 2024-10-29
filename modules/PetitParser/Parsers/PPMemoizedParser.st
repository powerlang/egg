"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPMemoizedParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'stream',
		'buffer'
	],
	#category : #Parsers
}

{ #category : #operations }
PPMemoizedParser >> memoized [
	"Ther is no point in memoizing more than once."

	^ self
]

{ #category : #parsing }
PPMemoizedParser >> parseOn: aStream [
	| memento |
	stream == aStream ifFalse: [self reset: aStream].
	memento := (buffer at: stream position + 1)
		ifNil: [buffer at: stream position + 1 put: PPMemento new].
	memento position isNil
		ifTrue: [
			memento
				result: (stream size - stream position + 2 < memento count
					ifTrue: [PPFailure message: 'overflow' from: stream]
					ifFalse: [
						memento increment.
						parser parseOn: stream]).
			memento position: stream position]
		ifFalse: [stream position: memento position].
	^memento result
]

{ #category : #printing }
PPMemoizedParser >> printTextOn: rtf [
	self printSmalltalkReceiverOn: rtf.
	parser nextPutAll: ' memoized'
]

{ #category : #private }
PPMemoizedParser >> reset: aStream [
	stream := aStream.
	buffer := Array new: aStream size + 1
]

