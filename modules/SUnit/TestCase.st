"
	Copyright (c) 2021-2025 Aucerna, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #TestCase,
	#superclass : #Object,
	#instVars : [
		'testSelector',
		'testSeed',
		'time',
		'counter'
	],
	#category : #SUnit
}

{ #category : #running }
TestCase class >> allTestSelectors [
	^(self
		selectorsUpTo: self rootClass
		satisfying: [:selector | self isTestSelector: selector]) asOrderedCollection sort
]

{ #category : #running }
TestCase class >> buildSuiteFromAllSelectors [
	^self buildSuiteFromMethods: self allTestSelectors
]

{ #category : #running }
TestCase class >> buildSuiteFromLocalSelectors [
	^self buildSuiteFromMethods: self testSelectors
]

{ #category : #running }
TestCase class >> buildSuiteFromMethods: aCollection [
	| suite |
	suite := self newSuite.
	self shouldBuildForSubclasses
		ifTrue: [
			self allSubclasses reject: #shouldIgnoreTestClass thenDo: [:c | | s |
				s := c buildSuiteFromMethods: aCollection.
				suite addTest: s]]
		ifFalse: [
			aCollection do: [:selector | | test |
				test := self selector: selector.
				suite addTest: test]].
	^suite
]

{ #category : #running }
TestCase class >> buildSuiteFromSelectors [
	self shouldIgnoreTestClass ifTrue: [^self newSuite].
	^self shouldInheritSelectors
		ifTrue: [self buildSuiteFromAllSelectors]
		ifFalse: [self buildSuiteFromLocalSelectors]
]

{ #category : #running }
TestCase class >> buildTestSuite [
	| suite |
	^self isAbstract
		ifTrue: [
			suite := self newSuite.
			self allSubclasses
				do: [:cls | cls isAbstract
					ifFalse: [suite addTest: cls buildSuiteFromSelectors]].
			suite]
		ifFalse: [self buildSuiteFromSelectors]
]

{ #category : #testing }
TestCase class >> debug: aSymbol [
	^(self selector: aSymbol) debug
]

{ #category : #testing }
TestCase class >> isAbstract [
	^self sunitName = #TestCase
]

{ #category : #testing }
TestCase class >> isTestSelector: aSymbol [
	aSymbol == #tests ifTrue: [^false].
	^(self selectorPatterns
		anySatisfy: [:pattern | pattern sunitMatch: aSymbol])
		and: [aSymbol last != $:]
]

{ #category : #running }
TestCase class >> newSuite [
	^self suiteClass named: self name asString
]

{ #category : #resources }
TestCase class >> resources [
	^#()
]

{ #category : #accessing }
TestCase class >> rootClass [
	^TestCase
]

{ #category : #running }
TestCase class >> run: aSymbol [
	^(self selector: aSymbol) run
]

{ #category : #initialization }
TestCase class >> selector: aSymbol [
	^self new testSelector: aSymbol
]

{ #category : #running }
TestCase class >> selectorPattern [
	^'test'
]

{ #category : #running }
TestCase class >> selectorPatterns [
	^#('test' 'devTest')
]

{ #category : #running }
TestCase class >> shouldBuildForSubclasses [
	^self isAbstract
]

{ #category : #testing }
TestCase class >> shouldIgnoreTestClass [
	^self isAbstract
]

{ #category : #testing }
TestCase class >> shouldInheritSelectors [
	^self superclass isAbstract or: [self testSelectors isEmpty]
]

{ #category : #running }
TestCase class >> suite [
	^self buildTestSuite
]

{ #category : #running }
TestCase class >> suiteClass [
	^TestSuite
			
]

{ #category : #accessing }
TestCase class >> sunitVersion [
	^'3.1'
			
]

{ #category : #running }
TestCase class >> testSelectors [
	^self sunitSelectors select: [:each | 
		(self selectorPatterns anySatisfy: [:pattern | pattern sunitMatch: each])
			and: [each last ~= $:]]
]

{ #category : #accessing }
TestCase >> addCountTo: aTestCounter [
	aTestCounter addCounter: counter]

{ #category : #compatibility }
TestCase >> addDependentToHierachy: anObject [
	"an empty method. for Composite compability with TestSuite"		
]

{ #category : #compatibility }
TestCase >> addDependentToHierarchy: anObject [
	"an empty method. for Composite compability with TestSuite"			
]

{ #category : #accessing }
TestCase >> allCases [
	^{self}
]

{ #category : #accessing }
TestCase >> anyTest [
	^self
]

{ #category : #asserting }
TestCase >> assert: aBoolean [
	self count: #assert:; primAssert: aBoolean
]

{ #category : #asserting }
TestCase >> assert: aBoolean description: aString [
	self
		count: #assert:description:;
		primAssert: aBoolean description: aString
]

{ #category : #asserting }
TestCase >> assert: aBoolean description: aString resumable: resumableBoolean [
	self
		count: #assert:description:resumable:;
		primAssert: aBoolean description: aString resumable: resumableBoolean
]

{ #category : #unclassified }
TestCase >> assert: result equals: expected [
	self assert: result = expected
]

{ #category : #running }
TestCase >> basicRun: aTestResult [
	(aTestResult skipped includes: self) ifFalse: [aTestResult runCase: self]
]

{ #category : #exceptions }
TestCase >> caseCount [
	^1
]

{ #category : #accessing }
TestCase >> checkDescriptions [
	^counter checkDescriptions
]

{ #category : #accessing }
TestCase >> count: selector [
	counter count: selector
]

{ #category : #accessing }
TestCase >> currentTest [
	^self
]

{ #category : #debugging }
TestCase >> debug [
	self resources do: [:resource | resource beAvailableFor: self].
	[(self class selector: testSelector) runCase]
		sunitEnsure: [self resources do: [:resource | resource reset]]
]

{ #category : #debugging }
TestCase >> debugAsFailure [
	| semaphore |
	semaphore := Semaphore new.
	self resources do: [:resource | resource beAvailableFor: self].
	[
		semaphore wait.
		self resources do: [:resource | resource reset]] fork.
	^false
		ifTrue: [(self class selector: testSelector) runCaseAsFailure: semaphore]
		ifFalse: [self runCaseAsFailure: semaphore]
]

{ #category : #denying }
TestCase >> deny: aBoolean [
	self count: #deny:; primDeny: aBoolean
]

{ #category : #denying }
TestCase >> deny: aBoolean description: aString [
	self
		count: #deny:description:;
		primDeny: aBoolean description: aString
]

{ #category : #denying }
TestCase >> deny: aBoolean description: aString resumable: resumableBoolean [
	self
		count: #deny:description:resumable:;
		primDeny: aBoolean description: aString resumable: resumableBoolean
]

{ #category : #exceptions }
TestCase >> executeShould: aBlock inScopeOf: anExceptionalEvent [
	^[
		aBlock value.
		false]
		sunitOn: anExceptionalEvent
		do: [:ex | ex return: true]
]

{ #category : #exceptions }
TestCase >> executeShould: aBlock inScopeOf: anExceptionalEvent checking: exceptionBlock [
	^[
		aBlock value.
		false]
		sunitOn: anExceptionalEvent
		do: [:ex | ex return: (exceptionBlock value: ex)]
]

{ #category : #logging }
TestCase >> failureLog [
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"

	^SUnitNameResolver defaultLogDevice
]

{ #category : #accessing }
TestCase >> get: aspect from: anObject [
	^anObject instVarNamed: aspect asString
]

{ #category : #accessing }
TestCase >> importFrom: data [
	testSeed := data at: 4.
	time := data at: 5.
	counter := data at: 6
]

{ #category : #initialization }
TestCase >> initialize [
	testSeed := self random seed.
	counter := TestCounter new
]

{ #category : #testing }
TestCase >> isKnownIssue [
	| cm |
	cm := self methodFor: testSelector.
	^cm notNil and: [cm includesIdentical: #knownIssue]
]

{ #category : #comparing }
TestCase >> isLike: aTestCase [
	aTestCase class == self class ifFalse: [^false].
	^aTestCase selector = self selector
]

{ #category : #testing }
TestCase >> isLogging [
	"By default, we're not logging failures. If you override this in
	a subclass, make sure that you override #failureLog"
	^false
]

{ #category : #testing }
TestCase >> isSlow [
	| cm |
	cm := self methodFor: testSelector.
	^cm notNil and: [cm includesIdentical: #slowTest]
]

{ #category : #logging }
TestCase >> logFailure: aString [
	self isLogging ifTrue: [
		self failureLog
			cr;
			nextPutAll: aString;
			flush]
]

{ #category : #debugging }
TestCase >> openDebuggerOnFailingTestMethod [
	"SUnit has halted one step in front of the failing test method. Step over the
	'self halt' and send into 'self perform: testSelector' to see the failure from
	the beginning"
	self performTest
]

{ #category : #running }
TestCase >> performTest [
	self perform: testSelector sunitAsSymbol
]

{ #category : #asserting }
TestCase >> precondition: aBoolean [
	self assert: aBoolean description: 'Precondition for this test is not met'
]

{ #category : #asserting }
TestCase >> primAssert: aBoolean [
	self primAssert: aBoolean description: 'Assertion failed'
]

{ #category : #asserting }
TestCase >> primAssert: aBoolean description: aString [
	| msg |
	aBoolean ifFalse: [
		msg := aString.
		self isKnownIssue ifTrue: [msg := msg , ' - Known Issue'].
		self logFailure: msg.
		self signalFailure: msg]
]

{ #category : #asserting }
TestCase >> primAssert: aBoolean description: aString resumable: rBoolean [
	aBoolean ifFalse: [
		self logFailure: aString.
		TestResult failure sunitSignalWith: aString resumable: rBoolean]
]

{ #category : #denying }
TestCase >> primDeny: aBoolean [
	self primAssert: aBoolean not
]

{ #category : #denying }
TestCase >> primDeny: aBoolean description: aString [
	self primAssert: aBoolean not description: aString
]

{ #category : #denying }
TestCase >> primDeny: aBoolean description: aString resumable: resumableBoolean [
	self
		primAssert: aBoolean not
		description: aString
		resumable: resumableBoolean
]

{ #category : #printing }
TestCase >> printOn: aStream [

	aStream
		nextPutAll: self class printString;
		nextPutAll: '>>#';
		nextPutAll: testSelector asString
			
]

{ #category : #accessing }
TestCase >> random [
	^TestCase module random
]

{ #category : #accessing }
TestCase >> removeAllSuchThat: aBlock [
	^self
]

{ #category : #compatibility }
TestCase >> removeDependentFromHierachy: anObject [
	"an empty method. for Composite compability with TestSuite"
]

{ #category : #compatibility }
TestCase >> removeDependentFromHierarchy: anObject [
	"an empty method. for Composite compability with TestSuite"
]

{ #category : #accessing }
TestCase >> resources [
	| all queue r |
	r := self class resources.
	r isEmpty ifTrue: [^r].
	all := Set new.
	queue := OrderedCollection new.
	queue addAll: r.
	[queue isEmpty] whileFalse: [| next |
		next := queue removeFirst.
		all add: next.
		queue addAll: next resources].
	^all
]

{ #category : #running }
TestCase >> run [
	| result |
	result := TestResult new.
	self run: result.
	^result
]

{ #category : #running }
TestCase >> run: aTestResult [
	aTestResult runCase: self
]

{ #category : #running }
TestCase >> runCase [
	| t |
	[
		t := Kernel host currentMilliseconds.
		self initialize; setUp; performTest]
		sunitEnsure: [self tearDown; time: Kernel host currentMilliseconds - t]
]

{ #category : #running }
TestCase >> runCaseAsFailure: aSemaphore [
	[self setUp; openDebuggerOnFailingTestMethod] sunitEnsure: [
		self tearDown.
		aSemaphore signal]
]

{ #category : #accessing }
TestCase >> seed [
	^testSeed
]

{ #category : #accessing }
TestCase >> selector [
	^testSelector isMessage
		ifTrue: [testSelector selector]
		ifFalse: [testSelector]
]

{ #category : #accessing }
TestCase >> set: aspect of: anObject to: value [
	anObject instVarNamed: aspect asString put: value
]

{ #category : #'set up' }
TestCase >> setUp [
	| file |
	self random seed: testSeed.
	counter reset
]

{ #category : #asserting }
TestCase >> should: aBlock [
	self count: #should:.
	self primAssert: aBlock value
]

{ #category : #asserting }
TestCase >> should: aBlock description: aString [
	self count: #should:description:.
	self primAssert: aBlock value description: aString
]

{ #category : #asserting }
TestCase >> should: aBlock raise: anExceptionalEvent [
	self count: #should:raise:.
	^self primAssert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #asserting }
TestCase >> should: aBlock raise: anExceptionalEvent description: aString [
	self count: #should:raise:description:.
	^self
		primAssert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
]

{ #category : #asserting }
TestCase >> should: aBlock
raise: anExceptionalEvent
description: aString
resumable: aBoolean [
	| raised |
	self count: #should:raise:description:.
	raised := false.
	[
		aBlock value.
		false]
		sunitOn: anExceptionalEvent
		do: [:ex | 
			raised := true.
			ex isResumable ifTrue: [ex resume] ifFalse: [ex return]].
	^self
		primAssert: raised
		description: aString
		resumable: aBoolean
]

{ #category : #asserting }
TestCase >> should: aBlock raise: anExceptionalEvent satisfying: exceptionBlock [
	self count: #should:raise:.
	^self
		primAssert: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
]

{ #category : #asserting }
TestCase >> should: aBlock
raise: anExceptionalEvent
satisfying: exceptionBlock
description: aString [
	self count: #should:raise:description:.
	^self
		primAssert: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
		description: aString
]

{ #category : #asserting }
TestCase >> should: aBlock send: aSymbol to: anObject [
	^self
		should: aBlock
		send: aSymbol
		to: anObject
		description: aSymbol , ' should have been sent'
]

{ #category : #asserting }
TestCase >> should: aBlock
send: aSymbol
to: anObject
description: aString [
	| sent |
	sent := false.
	anObject whenReceiving: aSymbol evaluate: [:msg | sent := true].
	aBlock ensure: [anObject stopSpying: aSymbol].
	self assert: sent description: aString
]

{ #category : #denying }
TestCase >> shouldnt: aBlock [
	self count: #shouldnt:; primDeny: aBlock value
]

{ #category : #denying }
TestCase >> shouldnt: aBlock description: aString [
	self
		count: #shouldnt:description:;
		primDeny: aBlock value description: aString
]

{ #category : #denying }
TestCase >> shouldnt: aBlock raise: anExceptionalEvent [
	^self
		count: #shouldnt:raise:;
		primDeny: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
]

{ #category : #denying }
TestCase >> shouldnt: aBlock raise: anExceptionalEvent description: aString [
	^self
		count: #shouldnt:raise:description:;
		primDeny: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
]

{ #category : #denying }
TestCase >> shouldnt: testBlock
raise: anExceptionalEvent
description: aString
ensure: aBlock [
	^[self shouldnt: testBlock raise: anExceptionalEvent description: aString]
		ensure: aBlock
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock
raise: anExceptionalEvent
description: aString
resumable: aBoolean [
	^self
		count: #shouldnt:raise:description:;
		primDeny: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
		resumable: aBoolean
]

{ #category : #denying }
TestCase >> shouldnt: aBlock raise: anExceptionalEvent otherwise: exceptionBlock [
	^self
		count: #shouldnt:raise:;
		primDeny: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock
raise: anExceptionalEvent
satisfying: exceptionBlock
description: aString [
	self count: #shouldnt:raise:description:.
	^self
		primDeny: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
		description: aString
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock
send: aSymbol
moreThan: anInteger
timesTo: anObject [
	self
		shouldnt: aBlock
		send: aSymbol
		moreThan: anInteger
		timesTo: anObject
		description: 'Possible stack overflow'
]

{ #category : #denying }
TestCase >> shouldnt: aBlock
send: aSymbol
moreThan: anInteger
timesTo: anObject
description: aString [
	| count |
	count := 0.
	anObject whenReceiving: aSymbol evaluate: [:msg | 
		count := count + 1.
		self assert: count <= anInteger description: aString].
	aBlock ensure: [anObject stopSpying: aSymbol]
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock send: aSymbol to: anObject [
	^self
		shouldnt: aBlock
		send: aSymbol
		to: anObject
		description: aSymbol storeString , ' should not be sent to '
			, anObject printString
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock
send: aSymbol
to: anObject
description: aString [
	anObject
		whenReceiving: aSymbol
		evaluate: [:msg | self deny: true description: aString].
	aBlock ensure: [anObject stopSpying: aSymbol]
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock takeMoreThan: milliseconds [
	self
		shouldnt: aBlock
		takeMoreThan: milliseconds
		description: 'Too long time to perform this task'
]

{ #category : #asserting }
TestCase >> shouldnt: aBlock takeMoreThan: milliseconds description: aString [
	| semaphore process |
	semaphore := Semaphore new.
	process := [
		aBlock value.
		semaphore signal]
		forkAt: Processor userBackgroundPriority.
	[semaphore waitForAtMost: milliseconds] on: Timeout do: [
		process terminate.
		self assert: false print description: aString].
	self assert: true
]

{ #category : #exceptions }
TestCase >> signalFailure: aString [
	TestResult failure sunitSignalWith: aString
]

{ #category : #exceptions }
TestCase >> signalSkipped: aString [
	TestResult skipped sunitSignalWith: aString
]

{ #category : #accessing }
TestCase >> signature [
	^self suite name -> self class name -> testSelector
]

{ #category : #skipping }
TestCase >> skipIf: aBoolean description: aString [
	aBoolean ifTrue: [self signalSkipped: aString]
]

{ #category : #compatibility }
TestCase >> stop: aBoolean [
]

{ #category : #accessing }
TestCase >> suite [
	^self propertyAt: #suite
]

{ #category : #accessing }
TestCase >> suite: aTestSuite [
	self propertyAt: #suite put: aTestSuite
]

{ #category : #running }
TestCase >> tearDown [
			
]

{ #category : #accessing }
TestCase >> tests [
	^{self}
]

{ #category : #accessing }
TestCase >> testSelector: aSymbol [
	testSelector := aSymbol
]

{ #category : #accessing }
TestCase >> time [
	^time
]

{ #category : #accessing }
TestCase >> time: anInteger [
	time := anInteger
]

{ #category : #accessing }
TestCase >> totalChecks [
	^counter totalChecks
]
