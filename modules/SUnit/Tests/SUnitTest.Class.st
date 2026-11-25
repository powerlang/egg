'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #SUnitTest category: #'SUnit.Tests'!
TestCase subclass: #SUnitTest
	instanceVariableNames: 'hasRun hasSetup hasRanOnce'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit.Tests'!
!SUnitTest commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!SUnitTest methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
error
	3 zork
! !

!SUnitTest methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
errorShouldntRaise
	self 
		shouldnt: [self someMessageThatIsntUnderstood] 
		raise: SUnitNameResolver notificationObject
! !

!SUnitTest methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
fail
	self assert: false
! !

!SUnitTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasRun
	^hasRun
! !

!SUnitTest methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasSetup
	^hasSetup
! !

!SUnitTest methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
noop
! !

!SUnitTest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
setRun
	hasRun := true
! !

!SUnitTest methodsFor:  'set up' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUp
	super setUp.
	hasSetup := true
! !

!SUnitTest methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
skip
	self skipIf: true description: 'this test is skipped'
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testAssert
	self assert: true; deny: false
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
log: message
	Kernel log: message, String cr
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testCounter
	| assert deny shouldnt description |
	assert := counter occurrencesOf: #assert:.
	deny := counter occurrencesOf: #deny:.
	shouldnt := counter occurrencesOf: #shouldnt:raise:.
	description := counter occurrencesOf: #assert:description:.
	self
		assert: true;
		assert: assert + 1 = (counter occurrencesOf: #assert:)
		description: 'Failure counting asserts';
		deny: false;
		assert: deny + 1 = (counter occurrencesOf: #deny:)
		description: 'Failure counting denys';
		shouldnt: [] raise: Error;
		assert: shouldnt + 1 = (counter occurrencesOf: #shouldnt:raise:)
		description: 'Failure counting #shouldnt:raise:';
		assert: description + 3 = (counter occurrencesOf: #assert:description:)
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testDefects
	| error failure suite result |
	error := self class selector: #error.
	failure := self class selector: #fail.
	suite := TestSuite new.
	suite addTest: error; addTest: failure.
	result := suite run.
	self
		assert: result defects asArray = (Array with: error with: failure);
		assert: result runCount = 2;
		assert: result passedCount = 0;
		assert: result failureCount = 1;
		assert: result errorCount = 1
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testDialectLocalizedException
	self
		should: [TestResult signalFailureWith: 'Foo']
		raise: TestResult failure.
	self should: [TestResult signalErrorWith: 'Foo'] raise: TestResult error
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testError
	| case result |
	case := self class selector: #error.
	result := case run.
	self
		assert: result runCount = 1;
		assert: result passedCount = 0;
		assert: result failureCount = 0;
		assert: result errorCount = 1.
	case := self class selector: #errorShouldntRaise.
	result := case run.
	self
		assert: result runCount = 1;
		assert: result passedCount = 0;
		assert: result failureCount = 0;
		assert: result errorCount = 1
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testException
	self should: [self error: 'foo'] raise: TestResult error
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testFail
	| case result |
	case := self class selector: #fail.
	result := case run.
	self
		assert: result runCount = 1;
		assert: result passedCount = 0;
		assert: result failureCount = 1;
		assert: result errorCount = 0
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testIsNotRerunOnDebug
	| case |
	case := self class selector: #testRanOnlyOnce.
	case run.
	case debug
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testRan
	| case |
	case := self class selector: #setRun.
	case run.
	self assert: case hasSetup.
	self assert: case hasRun
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testRandomGenerator
	| seed |
	seed := self random seed.
	self random next.
	self deny: self random seed = seed
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testRanOnlyOnce
	self assert: hasRanOnce ~= true.
	hasRanOnce := true
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testRemoveTests
	| suite inner |
	suite := TestSuite new.
	inner := TestSuite named: 'inner'.
	inner
		addTest: (TestCase selector: #a);
		addTest: (TestCase selector: #b).
	suite
		addTest: inner;
		addTest: (TestCase selector: #c).
	suite removeTests: {TestCase selector: #a}.
	self
		deny: (suite tests
			anySatisfy: [:test | test tests anySatisfy: [:t | t selector == #a]]);
		assert: (suite tests
			anySatisfy: [:test | test tests anySatisfy: [:t | t selector == #b]]);
		assert: (suite tests
			anySatisfy: [:test | test tests anySatisfy: [:t | t selector == #c]]).
	suite removeTests: {TestSuite named: 'inner'. TestCase selector: #c}.
	self assert: suite tests isEmpty
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testResult
	| case result |
	case := self class selector: #noop.
	result := case run.
	self
		assert: result runCount = 1;
		assert: result passedCount = 1;
		assert: result failureCount = 0;
		assert: result errorCount = 0
! !

!SUnitTest methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
testSelectors
	TestCase allSubclasses
		do: [:class | self deny: (class allTestSelectors includes: #tests)]
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testShould
	self should: [true]; shouldnt: [false]
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testSkip
	| case result |
	case := self class selector: #skip.
	result := case run.
	self
		assert: result runCount = 0;
		assert: result passedCount = 0;
		assert: result failureCount = 0;
		assert: result errorCount = 0;
		assert: result skippedCount = 1
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testSuite
	| noop fail error suite result |
	noop := self class selector: #noop.
	fail := self class selector: #fail.
	error := self class selector: #error.
	suite := TestSuite new.
	suite
		addTest: noop;
		addTest: fail;
		addTest: error.
	result := suite run.
	self
		assert: result runCount = 3;
		assert: result passedCount = 1;
		assert: result failureCount = 1;
		assert: result errorCount = 1;
		assert: noop time >= 0;
		assert: error time >= 0;
		assert: fail time >= 0
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testTestRandomGenerator
	| seed case |
	case := self class selector: #testRandomGenerator.
	seed := case random seed.
	case run.
	case setUp.
	self
		assert: case random seed == seed
		description: 'Initial seed not restored in RandomGenerator'
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testTime
	"(Delay forSeconds: 1) wait.
	self assert: self time >= 1000"
! !

!SUnitTest methodsFor:  'all' stamp: 'KenD 28/Jun/2026 13:27:37'!
testTotalChecks
	| suite result test total |
	suite := TestSuite new.
	suite addTest: (self class selector: #testCounter).
	result := suite run.
	test := result passed anyone.
	total := test totalChecks.
	result := suite run.
	test := result passed anyone.
	self assert: total = test totalChecks
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SUnitTest class' category: #'SUnit.Tests'!
SUnitTest class
	instanceVariableNames: ''!

!SUnitTest class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldInheritSelectors
	^false
! !


