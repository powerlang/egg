"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPRepeatingParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'min',
		'max'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser [
	^(super on: aParser) setMin: 0 max: SmallInteger maximum
]

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser max: aMaxInteger [
	^ (self on: aParser) setMin: 0 max: aMaxInteger
]

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser min: aMinInteger [
	^(self on: aParser) setMin: aMinInteger max: SmallInteger maximum
]

{ #category : #'instance creation' }
PPRepeatingParser class >> on: aParser min: aMinInteger max: aMaxInteger [
	^ (self on: aParser) setMin: aMinInteger max: aMaxInteger
]

{ #category : #testing }
PPRepeatingParser >> isPlus [
	^min = 1 and: [max = SmallInteger maximum]
]

{ #category : #testing }
PPRepeatingParser >> isStar [
	^min = 0 and: [max = SmallInteger maximum]
]

{ #category : #accessing }
PPRepeatingParser >> max [
	"Answer the maximum number of repetitions."

	^ max
]

{ #category : #accessing }
PPRepeatingParser >> min [
	"Answer the minimum number of repetitions."

	^ min
]

{ #category : #parsing }
PPRepeatingParser >> parseOn: aStream [
	| start element elements |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray
]

{ #category : #printing }
PPRepeatingParser >> printOn: aStream [
	self name ifNotNil: [^self printNameOn: aStream].
	aStream nextPut: $(.
	parser printOn: aStream.
	aStream nextPutAll: ') '.
	self isStar ifTrue: [^aStream nextPutAll: 'star'].
	self isPlus ifTrue: [^aStream nextPutAll: 'plus'].
	aStream
		nextPutAll: ' [';
		print: min;
		nextPutAll: ', ';
		nextPutAll: (max = SmallInteger maximum
			ifTrue: ['*']
			ifFalse: [max printString]);
		nextPut: $]
]

{ #category : #printing }
PPRepeatingParser >> printTextOn: rtf [
	| stop |
	self name ifNotNil: [^self printNameOn: rtf].
	parser printSmalltalkReceiverOn: rtf.
	self isStar ifTrue: [^rtf nextPutAll: ' star'].
	self isPlus ifTrue: [^rtf nextPutAll: ' plus'].
	stop := max = SmallInteger maximum ifTrue: ['*'] ifFalse: [max printString].
	rtf
		nextPutAll: ' rep [';
		print: min;
		nextPutAll: ', ';
		nextPutAll: stop;
		nextPut: $]
]

{ #category : #initialization }
PPRepeatingParser >> setMin: aMinInteger max: aMaxInteger [
	min := aMinInteger.
	max := aMaxInteger
]

