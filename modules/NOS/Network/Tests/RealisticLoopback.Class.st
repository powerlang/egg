'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RealisticLoopback category: 'SqueakNOS-Net-Tests'!
Object subclass: #RealisticLoopback
	instanceVariableNames: 'process queue random dropRate corruptionRate unsortRate maxDelay minDelay minimumSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
corruptedCopyOf: aPacket
	| corrupted |
	corruptionRate <= 0 ifTrue: [^ aPacket].
	corrupted := aPacket copy.
	1 to: corrupted size do: [ :each |
		random next < corruptionRate
			ifTrue: [corrupted at: each put: (random next * 256) truncated]].
	^ corrupted
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
corruptionRate: aNumber
	corruptionRate := aNumber
! !

!RealisticLoopback methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:32:25'!
down
	process ifNotNil: [process terminate].
	process := nil
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
dropRate: aNumber
	dropRate := aNumber
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	queue := SharedQueue new.
	random := Random new. 
	dropRate := 0.0.
	corruptionRate := 0.0.
	unsortRate := 0.0.
	minDelay := 50.
	maxDelay := 100.
	minimumSize := 60 "pad small packets to 60 bytes"
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
input: aPacket
	random next < dropRate ifTrue: [^ self].
	random next < unsortRate ifTrue: [^ self output: aPacket]. "re-enqueue it"
	aPacket size < minimumSize ifTrue: [aPacket class bytes: (aPacket asByteArray, (ByteArray new: minimumSize - aPacket size))]. "pad to minimum size"
	(Delay forMilliseconds: (minDelay to: maxDelay) atRandom) wait.
	super input: (self corruptedCopyOf: aPacket)
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
loop
	self input: queue next
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
maxDelay: msecs
	maxDelay := msecs
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
minDelay: msecs
	minDelay := msecs
! !

!RealisticLoopback methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
minimumSize: anInteger
	minimumSize := anInteger
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
output: aPacket
	queue nextPut: aPacket
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsortRate: aNumber
	unsortRate := aNumber
! !

!RealisticLoopback methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
up
	self down.
	process := [[self loop] repeat] fork
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RealisticLoopback class' category: 'SqueakNOS-Net-Tests'!
RealisticLoopback class
	instanceVariableNames: ''!


RealisticLoopback initialize!

