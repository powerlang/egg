Class {
	#name : #RealisticLoopback,
	#superclass : #Object,
	#instVars : [
		'process',
		'queue',
		'random',
		'dropRate',
		'corruptionRate',
		'unsortRate',
		'maxDelay',
		'minDelay',
		'minimumSize'
	],
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'as yet unclassified' }
RealisticLoopback >> corruptedCopyOf: aPacket [
	| corrupted |
	corruptionRate <= 0 ifTrue: [^ aPacket].
	corrupted := aPacket copy.
	1 to: corrupted size do: [ :each |
		random next < corruptionRate
			ifTrue: [corrupted at: each put: (random next * 256) truncated]].
	^ corrupted
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> corruptionRate: aNumber [
	corruptionRate := aNumber
]

{ #category : #actions }
RealisticLoopback >> down [
	process ifNotNil: [process terminate].
	process := nil
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> dropRate: aNumber [
	dropRate := aNumber
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> initialize [
	super initialize.
	queue := SharedQueue new.
	random := Random new. 
	dropRate := 0.0.
	corruptionRate := 0.0.
	unsortRate := 0.0.
	minDelay := 50.
	maxDelay := 100.
	minimumSize := 60 "pad small packets to 60 bytes"
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> input: aPacket [
	random next < dropRate ifTrue: [^ self].
	random next < unsortRate ifTrue: [^ self output: aPacket]. "re-enqueue it"
	aPacket size < minimumSize ifTrue: [aPacket class bytes: (aPacket asByteArray, (ByteArray new: minimumSize - aPacket size))]. "pad to minimum size"
	(Delay forMilliseconds: (minDelay to: maxDelay) atRandom) wait.
	super input: (self corruptedCopyOf: aPacket)
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> loop [
	self input: queue next
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> maxDelay: msecs [
	maxDelay := msecs
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> minDelay: msecs [
	minDelay := msecs
]

{ #category : #accessing }
RealisticLoopback >> minimumSize: anInteger [
	minimumSize := anInteger
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> output: aPacket [
	queue nextPut: aPacket
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> unsortRate: aNumber [
	unsortRate := aNumber
]

{ #category : #'as yet unclassified' }
RealisticLoopback >> up [
	self down.
	process := [[self loop] repeat] fork
]
