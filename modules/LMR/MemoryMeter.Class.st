'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #MemoryMeter category: #Kernel!
Object subclass: #MemoryMeter
	instanceVariableNames: 'memory runs time maxPause youngFreed oldGrown grows shrinks rescued'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!MemoryMeter commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
growIfTime
	memory old percentageOfCommitedUsed > 90 ifTrue: [
		grows := grows + 1.
		memory commitMoreSpace]
! !

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	runs := 0.
	time := 0.
	maxPause := 0.
	youngFreed := 0.
	oldGrown := 0.
	grows := 0.
	shrinks := 0.
	rescued := 0
! !

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
measure: aBlock
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
! !

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
memory: aMemory
	memory := aMemory
! !

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
statistics
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
! !

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
statitistics
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
! !

!MemoryMeter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
throughput
	^time = 0
		ifTrue: [0]
		ifFalse: [memory eden commitedSize + memory from commitedSize * 2 * runs
			* 1000
			/ (time * 1024 * 1024)]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MemoryMeter class' category: #Kernel!
MemoryMeter class
	instanceVariableNames: ''!


MemoryMeter initialize!

