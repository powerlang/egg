'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestCase category: #SUnit!
Object subclass: #TestCase
	instanceVariableNames: 'testSelector testSeed time counter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!TestCase commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021-2025 Aucerna, Javier Pimás.
	See (MIT) license in root directory.
!

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addCountTo: aTestCounter
	aTestCounter addCounter: counter! !

!TestCase methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:27:37'!
addDependentToHierachy: anObject
	"an empty method. for Composite compability with TestSuite"		
! !

!TestCase methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:27:37'!
addDependentToHierarchy: anObject
	"an empty method. for Composite compability with TestSuite"			
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
allCases
	^{self}
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
anyTest
	^self
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
assert: aBoolean
	self count: #assert:; primAssert: aBoolean
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
assert: aBoolean description: aString
	self
		count: #assert:description:;
		primAssert: aBoolean description: aString
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
assert: aBoolean description: aString resumable: resumableBoolean
	self
		count: #assert:description:resumable:;
		primAssert: aBoolean description: aString resumable: resumableBoolean
! !

!TestCase methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:37'!
assert: result equals: expected
	self assert: result = expected
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
basicRun: aTestResult
	(aTestResult skipped includes: self) ifFalse: [aTestResult runCase: self]
! !

!TestCase methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
caseCount
	^1
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
checkDescriptions
	^counter checkDescriptions
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
count: selector
	counter count: selector
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
currentTest
	^self
! !

!TestCase methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:37'!
debug
	self resources do: [:resource | resource beAvailableFor: self].
	[(self class selector: testSelector) runCase]
		sunitEnsure: [self resources do: [:resource | resource reset]]
! !

!TestCase methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:37'!
debugAsFailure
	| semaphore |
	semaphore := Semaphore new.
	self resources do: [:resource | resource beAvailableFor: self].
	[
		semaphore wait.
		self resources do: [:resource | resource reset]] fork.
	^false
		ifTrue: [(self class selector: testSelector) runCaseAsFailure: semaphore]
		ifFalse: [self runCaseAsFailure: semaphore]
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
deny: aBoolean
	self count: #deny:; primDeny: aBoolean
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
deny: aBoolean description: aString
	self
		count: #deny:description:;
		primDeny: aBoolean description: aString
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
deny: aBoolean description: aString resumable: resumableBoolean
	self
		count: #deny:description:resumable:;
		primDeny: aBoolean description: aString resumable: resumableBoolean
! !

!TestCase methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
executeShould: aBlock inScopeOf: anExceptionalEvent
	^[
		aBlock value.
		false]
		sunitOn: anExceptionalEvent
		do: [:ex | ex return: true]
! !

!TestCase methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
executeShould: aBlock inScopeOf: anExceptionalEvent checking: exceptionBlock
	^[
		aBlock value.
		false]
		sunitOn: anExceptionalEvent
		do: [:ex | ex return: (exceptionBlock value: ex)]
! !

!TestCase methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:37'!
failureLog
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"

	^SUnitNameResolver defaultLogDevice
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
get: aspect from: anObject
	^anObject instVarNamed: aspect asString
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
importFrom: data
	testSeed := data at: 4.
	time := data at: 5.
	counter := data at: 6
! !

!TestCase methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	testSeed := self random seed.
	counter := TestCounter new
! !

!TestCase methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isKnownIssue
	| cm |
	cm := self methodFor: testSelector.
	^cm notNil and: [cm includesIdentical: #knownIssue]
! !

!TestCase methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isLike: aTestCase
	aTestCase class == self class ifFalse: [^false].
	^aTestCase selector = self selector
! !

!TestCase methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isLogging
	"By default, we're not logging failures. If you override this in
	a subclass, make sure that you override #failureLog"
	^false
! !

!TestCase methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isSlow
	| cm |
	cm := self methodFor: testSelector.
	^cm notNil and: [cm includesIdentical: #slowTest]
! !

!TestCase methodsFor:  'logging' stamp: 'KenD 28/Jun/2026 13:27:37'!
logFailure: aString
	self isLogging ifTrue: [
		self failureLog
			cr;
			nextPutAll: aString;
			flush]
! !

!TestCase methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:37'!
openDebuggerOnFailingTestMethod
	"SUnit has halted one step in front of the failing test method. Step over the
	'self halt' and send into 'self perform: testSelector' to see the failure from
	the beginning"
	self performTest
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
performTest
	self perform: testSelector sunitAsSymbol
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
precondition: aBoolean
	self assert: aBoolean description: 'Precondition for this test is not met'
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
primAssert: aBoolean
	self primAssert: aBoolean description: 'Assertion failed'
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
primAssert: aBoolean description: aString
	| msg |
	aBoolean ifFalse: [
		msg := aString.
		self isKnownIssue ifTrue: [msg := msg , ' - Known Issue'].
		self logFailure: msg.
		self signalFailure: msg]
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
primAssert: aBoolean description: aString resumable: rBoolean
	aBoolean ifFalse: [
		self logFailure: aString.
		TestResult failure sunitSignalWith: aString resumable: rBoolean]
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
primDeny: aBoolean
	self primAssert: aBoolean not
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
primDeny: aBoolean description: aString
	self primAssert: aBoolean not description: aString
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
primDeny: aBoolean description: aString resumable: resumableBoolean
	self
		primAssert: aBoolean not
		description: aString
		resumable: resumableBoolean
! !

!TestCase methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printOn: aStream

	aStream
		nextPutAll: self class printString;
		nextPutAll: '>>#';
		nextPutAll: testSelector asString
			
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
random
	^TestCase module random
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeAllSuchThat: aBlock
	^self
! !

!TestCase methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeDependentFromHierachy: anObject
	"an empty method. for Composite compability with TestSuite"
! !

!TestCase methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeDependentFromHierarchy: anObject
	"an empty method. for Composite compability with TestSuite"
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
resources
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
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
run
	| result |
	result := TestResult new.
	self run: result.
	^result
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
run: aTestResult
	aTestResult runCase: self
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCase
	| t |
	[
		t := Kernel host currentMilliseconds.
		self initialize; setUp; performTest]
		sunitEnsure: [self tearDown; time: Kernel host currentMilliseconds - t]
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCaseAsFailure: aSemaphore
	[self setUp; openDebuggerOnFailingTestMethod] sunitEnsure: [
		self tearDown.
		aSemaphore signal]
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
seed
	^testSeed
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
selector
	^testSelector isMessage
		ifTrue: [testSelector selector]
		ifFalse: [testSelector]
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
set: aspect of: anObject to: value
	anObject instVarNamed: aspect asString put: value
! !

!TestCase methodsFor:  'set up' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUp
	| file |
	self random seed: testSeed.
	counter reset
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock
	self count: #should:.
	self primAssert: aBlock value
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock description: aString
	self count: #should:description:.
	self primAssert: aBlock value description: aString
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock raise: anExceptionalEvent
	self count: #should:raise:.
	^self primAssert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock raise: anExceptionalEvent description: aString
	self count: #should:raise:description:.
	^self
		primAssert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock raise: anExceptionalEvent description: aString resumable: aBoolean
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
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock raise: anExceptionalEvent satisfying: exceptionBlock
	self count: #should:raise:.
	^self
		primAssert: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock raise: anExceptionalEvent satisfying: exceptionBlock description: aString
	self count: #should:raise:description:.
	^self
		primAssert: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
		description: aString
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock send: aSymbol to: anObject
	^self
		should: aBlock
		send: aSymbol
		to: anObject
		description: aSymbol , ' should have been sent'
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
should: aBlock send: aSymbol to: anObject description: aString
	| sent |
	sent := false.
	anObject whenReceiving: aSymbol evaluate: [:msg | sent := true].
	aBlock ensure: [anObject stopSpying: aSymbol].
	self assert: sent description: aString
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock
	self count: #shouldnt:; primDeny: aBlock value
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock description: aString
	self
		count: #shouldnt:description:;
		primDeny: aBlock value description: aString
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock raise: anExceptionalEvent
	^self
		count: #shouldnt:raise:;
		primDeny: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock raise: anExceptionalEvent description: aString
	^self
		count: #shouldnt:raise:description:;
		primDeny: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: testBlock raise: anExceptionalEvent description: aString ensure: aBlock
	^[self shouldnt: testBlock raise: anExceptionalEvent description: aString]
		ensure: aBlock
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock raise: anExceptionalEvent description: aString resumable: aBoolean
	^self
		count: #shouldnt:raise:description:;
		primDeny: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString
		resumable: aBoolean
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock raise: anExceptionalEvent otherwise: exceptionBlock
	^self
		count: #shouldnt:raise:;
		primDeny: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock raise: anExceptionalEvent satisfying: exceptionBlock description: aString
	self count: #shouldnt:raise:description:.
	^self
		primDeny: (self
			executeShould: aBlock
			inScopeOf: anExceptionalEvent
			checking: exceptionBlock)
		description: aString
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock send: aSymbol moreThan: anInteger timesTo: anObject
	self
		shouldnt: aBlock
		send: aSymbol
		moreThan: anInteger
		timesTo: anObject
		description: 'Possible stack overflow'
! !

!TestCase methodsFor:  'denying' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock send: aSymbol moreThan: anInteger timesTo: anObject description: aString
	| count |
	count := 0.
	anObject whenReceiving: aSymbol evaluate: [:msg | 
		count := count + 1.
		self assert: count <= anInteger description: aString].
	aBlock ensure: [anObject stopSpying: aSymbol]
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock send: aSymbol to: anObject
	^self
		shouldnt: aBlock
		send: aSymbol
		to: anObject
		description: aSymbol storeString , ' should not be sent to '
			, anObject printString
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock send: aSymbol to: anObject description: aString
	anObject
		whenReceiving: aSymbol
		evaluate: [:msg | self deny: true description: aString].
	aBlock ensure: [anObject stopSpying: aSymbol]
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock takeMoreThan: milliseconds
	self
		shouldnt: aBlock
		takeMoreThan: milliseconds
		description: 'Too long time to perform this task'
! !

!TestCase methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldnt: aBlock takeMoreThan: milliseconds description: aString
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
! !

!TestCase methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
signalFailure: aString
	TestResult failure sunitSignalWith: aString
! !

!TestCase methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
signalSkipped: aString
	TestResult skipped sunitSignalWith: aString
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
signature
	^self suite name -> self class name -> testSelector
! !

!TestCase methodsFor:  'skipping' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipIf: aBoolean description: aString
	aBoolean ifTrue: [self signalSkipped: aString]
! !

!TestCase methodsFor:  'compatibility' stamp: 'KenD 28/Jun/2026 13:27:37'!
stop: aBoolean
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
suite
	^self propertyAt: #suite
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
suite: aTestSuite
	self propertyAt: #suite put: aTestSuite
! !

!TestCase methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
tearDown
			
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
tests
	^{self}
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
testSelector: aSymbol
	testSelector := aSymbol
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
time
	^time
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
time: anInteger
	time := anInteger
! !

!TestCase methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
totalChecks
	^counter totalChecks
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestCase class' category: #SUnit!
TestCase class
	instanceVariableNames: ''!

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
allTestSelectors
	^(self
		selectorsUpTo: self rootClass
		satisfying: [:selector | self isTestSelector: selector]) asOrderedCollection sort
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
buildSuiteFromAllSelectors
	^self buildSuiteFromMethods: self allTestSelectors
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
buildSuiteFromLocalSelectors
	^self buildSuiteFromMethods: self testSelectors
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
buildSuiteFromMethods: aCollection
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
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
buildSuiteFromSelectors
	self shouldIgnoreTestClass ifTrue: [^self newSuite].
	^self shouldInheritSelectors
		ifTrue: [self buildSuiteFromAllSelectors]
		ifFalse: [self buildSuiteFromLocalSelectors]
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
buildTestSuite
	| suite |
	^self isAbstract
		ifTrue: [
			suite := self newSuite.
			self allSubclasses
				do: [:cls | cls isAbstract
					ifFalse: [suite addTest: cls buildSuiteFromSelectors]].
			suite]
		ifFalse: [self buildSuiteFromSelectors]
! !

!TestCase class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
debug: aSymbol
	^(self selector: aSymbol) debug
! !

!TestCase class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isAbstract
	^self sunitName = #TestCase
! !

!TestCase class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isTestSelector: aSymbol
	aSymbol == #tests ifTrue: [^false].
	^(self selectorPatterns
		anySatisfy: [:pattern | pattern sunitMatch: aSymbol])
		and: [aSymbol last !!= $:]
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
newSuite
	^self suiteClass named: self name asString
! !

!TestCase class methodsFor:  'resources' stamp: 'KenD 28/Jun/2026 13:27:37'!
resources
	^#()
! !

!TestCase class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
rootClass
	^TestCase
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
run: aSymbol
	^(self selector: aSymbol) run
! !

!TestCase class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
selector: aSymbol
	^self new testSelector: aSymbol
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
selectorPattern
	^'test'
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
selectorPatterns
	^#('test' 'devTest')
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldBuildForSubclasses
	^self isAbstract
! !

!TestCase class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldIgnoreTestClass
	^self isAbstract
! !

!TestCase class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
shouldInheritSelectors
	^self superclass isAbstract or: [self testSelectors isEmpty]
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
suite
	^self buildTestSuite
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
suiteClass
	^TestSuite
			
! !

!TestCase class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitVersion
	^'3.1'
			
! !

!TestCase class methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
testSelectors
	^self sunitSelectors select: [:each | 
		(self selectorPatterns anySatisfy: [:pattern | pattern sunitMatch: each])
			and: [each last ~= $:]]
! !


TestCase initialize!

