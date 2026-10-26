'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ExampleSetTest category: #'SUnit.Tests'!
TestCase subclass: #ExampleSetTest
	instanceVariableNames: 'full empty'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit.Tests'!
!ExampleSetTest commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!ExampleSetTest methodsFor:  'set up' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUp
	empty := Set new.
	full := Set with: 5 with: #abc
! !

!ExampleSetTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testAdd
	empty add: 5.
	self assert: (empty includes: 5)
! !

!ExampleSetTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testGrow
	empty addAll: (1 to: 100).
	self assert: empty size = 100
! !

!ExampleSetTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testIllegal
	self 
		should: [empty at: 5] 
		raise: TestResult error.
	self 
		should: [empty at: 5 put: #abc] 
		raise: TestResult error
! !

!ExampleSetTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testIncludes
	self assert: (full includes: 5).
	self assert: (full includes: #abc)
! !

!ExampleSetTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testOccurrences
	self assert: (empty occurrencesOf: 0) = 0.
	self assert: (full occurrencesOf: 5) = 1.
	full add: 5.
	self assert: (full occurrencesOf: 5) = 1
! !

!ExampleSetTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testRemove
	full remove: 5.
	self assert: (full includes: #abc).
	self deny: (full includes: 5)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExampleSetTest class' category: #'SUnit.Tests'!
ExampleSetTest class
	instanceVariableNames: ''!


