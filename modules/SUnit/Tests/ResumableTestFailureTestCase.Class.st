'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ResumableTestFailureTestCase category: #'SUnit.Tests'!
TestCase subclass: #ResumableTestFailureTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit.Tests'!
!ResumableTestFailureTestCase commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
errorTest
	1 zork
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
failureLog
	^SUnitNameResolver defaultLogDevice
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
failureTest
	self
		assert: false description: 'You should see me' resumable: true; 
		assert: false description: 'You should see me too' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
isLogging
	^false
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
okTest
	self assert: true
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
regularTestFailureTest
	self assert: false description: 'You should see me'
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
resumableTestFailureTest
	self
		assert: false description: 'You should see me' resumable: true; 
		assert: false description: 'You should see me too' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true
! !

!ResumableTestFailureTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
testResumable
	| result suite |
	suite := TestSuite new.
	suite addTest: (self class selector: #errorTest).
	suite addTest: (self class selector: #regularTestFailureTest).
	suite addTest: (self class selector: #resumableTestFailureTest).
	suite addTest: (self class selector: #okTest).
	result := suite run.
	self assert: result failures size = 2;
		assert: result errors size = 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ResumableTestFailureTestCase class' category: #'SUnit.Tests'!
ResumableTestFailureTestCase class
	instanceVariableNames: ''!


