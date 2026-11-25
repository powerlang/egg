'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #SimpleTestResource category: #'SUnit.Tests'!
TestResource subclass: #SimpleTestResource
	instanceVariableNames: 'runningState hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit.Tests'!
!SimpleTestResource commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasRun
	^hasRun
! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasSetup
	^hasSetup
! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
isAvailable
	^self runningState == self startedStateSymbol! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
runningState
	^runningState
! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
runningState: aSymbol
	runningState := aSymbol
! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
setRun
	hasRun := true
! !

!SimpleTestResource methodsFor:  'set up' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUp
	self runningState: self startedStateSymbol.
	hasSetup := true
! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
startedStateSymbol
	^#started
! !

!SimpleTestResource methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
stoppedStateSymbol
	^#stopped
! !

!SimpleTestResource methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
tearDown
	self runningState: self stoppedStateSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SimpleTestResource class' category: #'SUnit.Tests'!
SimpleTestResource class
	instanceVariableNames: ''!


