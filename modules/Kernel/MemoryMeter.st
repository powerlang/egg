"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MemoryMeter,
	#superclass : #Object,
	#instVars : [
		'memory',
		'runs',
		'time',
		'maxPause',
		'youngFreed',
		'oldGrown',
		'grows',
		'shrinks',
		'rescued'
	],
	#category : #Kernel
}

{ #category : #accessing }
MemoryMeter >> growIfTime [
	memory old percentageOfCommitedUsed > 90 ifTrue: [
		grows := grows + 1.
		memory commitMoreSpace]
]

{ #category : #accessing }
MemoryMeter >> initialize [
	runs := 0.
	time := 0.
	maxPause := 0.
	youngFreed := 0.
	oldGrown := 0.
	grows := 0.
	shrinks := 0.
	rescued := 0
]

{ #category : #accessing }
MemoryMeter >> measure: aBlock [
	| eden from old milliseconds |
	eden := memory eden usedBytes.
	from := memory from usedBytes.
	old := memory old usedBytes.
	milliseconds := (Smalltalk os microsecondsToRun: aBlock) / 1000.0.
	oldGrown := memory old usedBytes - old.
	youngFreed := memory from usedBytes - from - eden.
	runs := runs + 1.
	time := time + milliseconds.
	maxPause := milliseconds max: maxPause.
	rescued := memory rescuedEphemerons size
]

{ #category : #accessing }
MemoryMeter >> memory: aMemory [
	memory := aMemory
]

{ #category : #accessing }
MemoryMeter >> statistics [
	^String streamContents: [:s | 
		s
			print: runs;
			nextPutAll: ' runs took ';
			nextPutAll: time printString;
			nextPutAll: 'ms (max pause was ';
			print: maxPause;
			nextPutAll: 'ms, estimated throughput: ~';
			nextPutAll: (self throughput printFraction: 3);
			nextPutAll: 'mb/s). Rescued ';
			print: rescued;
			nextPutAll: ' ephemerons. Grown ';
			print: grows;
			nextPutAll: ' times.']
]

{ #category : #accessing }
MemoryMeter >> statitistics [
	^String streamContents: [:s | 
		s
			print: runs;
			nextPutAll: ' runs took ';
			nextPutAll: time printString;
			nextPutAll: 'ms (max pause was ';
			print: maxPause;
			nextPutAll: 'ms, estimated throughput: ~';
			nextPutAll: (self throughput printFraction: 3);
			nextPutAll: 'mb/s). Rescued ';
			print: rescued;
			nextPutAll: ' ephemerons. Grown ';
			print: grows;
			nextPutAll: ' times.']
]

{ #category : #accessing }
MemoryMeter >> throughput [
	^time = 0
		ifTrue: [0]
		ifFalse: [memory eden commitedSize + memory from commitedSize * 2 * runs
			* 1000
			/ (time * 1024 * 1024)]
]

