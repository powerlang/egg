"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SUnitTest,
	#superclass : #TestCase,
	#instVars : [
		'hasRun',
		'hasSetup',
		'hasRanOnce'
	],
	#category : #'SUnit.Tests'
}

{ #category : #testing }
SUnitTest class >> shouldInheritSelectors [
	^false
]

{ #category : #private }
SUnitTest >> error [
	3 zork
]

{ #category : #private }
SUnitTest >> errorShouldntRaise [
	self 
		shouldnt: [self someMessageThatIsntUnderstood] 
		raise: SUnitNameResolver notificationObject
]

{ #category : #private }
SUnitTest >> fail [
	self assert: false
]

{ #category : #testing }
SUnitTest >> hasRun [
	^hasRun
]

{ #category : #testing }
SUnitTest >> hasSetup [
	^hasSetup
]

{ #category : #private }
SUnitTest >> noop [
]

{ #category : #accessing }
SUnitTest >> setRun [
	hasRun := true
]

{ #category : #'set up' }
SUnitTest >> setUp [
	super setUp.
	hasSetup := true
]

{ #category : #private }
SUnitTest >> skip [
	self skipIf: true description: 'this test is skipped'
]

{ #category : #all }
SUnitTest >> testAssert [
	self assert: true; deny: false
]

{ #category : #all }
SUnitTest >> log: message [
	Kernel log: message, String cr
]

{ #category : #all }
SUnitTest >> testCounter [
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
]

{ #category : #all }
SUnitTest >> testDefects [
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
]

{ #category : #all }
SUnitTest >> testDialectLocalizedException [
	self
		should: [TestResult signalFailureWith: 'Foo']
		raise: TestResult failure.
	self should: [TestResult signalErrorWith: 'Foo'] raise: TestResult error
]

{ #category : #all }
SUnitTest >> testError [
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
]

{ #category : #all }
SUnitTest >> testException [
	self should: [self error: 'foo'] raise: TestResult error
]

{ #category : #all }
SUnitTest >> testFail [
	| case result |
	case := self class selector: #fail.
	result := case run.
	self
		assert: result runCount = 1;
		assert: result passedCount = 0;
		assert: result failureCount = 1;
		assert: result errorCount = 0
]

{ #category : #all }
SUnitTest >> testIsNotRerunOnDebug [
	| case |
	case := self class selector: #testRanOnlyOnce.
	case run.
	case debug
]

{ #category : #all }
SUnitTest >> testRan [
	| case |
	case := self class selector: #setRun.
	case run.
	self assert: case hasSetup.
	self assert: case hasRun
]

{ #category : #all }
SUnitTest >> testRandomGenerator [
	| seed |
	seed := self random seed.
	self random next.
	self deny: self random seed = seed
]

{ #category : #all }
SUnitTest >> testRanOnlyOnce [
	self assert: hasRanOnce ~= true.
	hasRanOnce := true
]

{ #category : #all }
SUnitTest >> testRemoveTests [
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
]

{ #category : #all }
SUnitTest >> testResult [
	| case result |
	case := self class selector: #noop.
	result := case run.
	self
		assert: result runCount = 1;
		assert: result passedCount = 1;
		assert: result failureCount = 0;
		assert: result errorCount = 0
]

{ #category : #accessing }
SUnitTest >> testSelectors [
	TestCase allSubclasses
		do: [:class | self deny: (class allTestSelectors includes: #tests)]
]

{ #category : #all }
SUnitTest >> testShould [
	self should: [true]; shouldnt: [false]
]

{ #category : #all }
SUnitTest >> testSkip [
	| case result |
	case := self class selector: #skip.
	result := case run.
	self
		assert: result runCount = 0;
		assert: result passedCount = 0;
		assert: result failureCount = 0;
		assert: result errorCount = 0;
		assert: result skippedCount = 1
]

{ #category : #all }
SUnitTest >> testSuite [
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
]

{ #category : #all }
SUnitTest >> testTestRandomGenerator [
	| seed case |
	case := self class selector: #testRandomGenerator.
	seed := case random seed.
	case run.
	case setUp.
	self
		assert: case random seed == seed
		description: 'Initial seed not restored in RandomGenerator'
]

{ #category : #all }
SUnitTest >> testTime [
	"(Delay forSeconds: 1) wait.
	self assert: self time >= 1000"
]

{ #category : #all }
SUnitTest >> testTotalChecks [
	| suite result test total |
	suite := TestSuite new.
	suite addTest: (self class selector: #testCounter).
	result := suite run.
	test := result passed anyone.
	total := test totalChecks.
	result := suite run.
	test := result passed anyone.
	self assert: total = test totalChecks
]

