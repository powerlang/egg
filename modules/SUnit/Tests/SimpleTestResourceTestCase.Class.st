'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #SimpleTestResourceTestCase category: #'SUnit.Tests'!
TestCase subclass: #SimpleTestResourceTestCase
	instanceVariableNames: 'resource'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit.Tests'!
!SimpleTestResourceTestCase commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
dummy
	self assert: true
! !

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
error
	'foo' odd
! !

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
fail
	self assert: false
! !

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
setRun
	resource setRun
! !

!SimpleTestResourceTestCase methodsFor:  'set up' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUp
	resource := SimpleTestResource current
! !

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
testRan
	| case |

	case := self class selector: #setRun.
	case run.
	self assert: resource hasSetup.
	self assert: resource hasRun
! !

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
testResourceInitRelease
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	suite addTest: (self class selector: #dummy).
	result := suite run.
	self assert: resource hasSetup
! !

!SimpleTestResourceTestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
testResourcesCollection
	| collection |
	collection := self resources.
	self assert: collection size = 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SimpleTestResourceTestCase class' category: #'SUnit.Tests'!
SimpleTestResourceTestCase class
	instanceVariableNames: ''!

!SimpleTestResourceTestCase class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
resources
	^Set new add: SimpleTestResource; yourself
! !


