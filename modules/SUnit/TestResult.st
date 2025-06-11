"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestResult,
	#superclass : #Object,
	#instVars : [
		'failures',
		'errors',
		'passed',
		'skipped'
	],
	#category : #SUnit
}

{ #category : #exceptions }
TestResult class >> error [
	^self exError
]

{ #category : #exceptions }
TestResult class >> exError [
	^SUnitNameResolver errorObject
]

{ #category : #exceptions }
TestResult class >> failure [
	^TestFailure
]

{ #category : #services }
TestResult class >> signalErrorWith: aString [
	self error sunitSignalWith: aString
]

{ #category : #services }
TestResult class >> signalFailureWith: aString [
	self failure sunitSignalWith: aString
]

{ #category : #exceptions }
TestResult class >> skipped [
	^TestSkipped
]

{ #category : #adding }
TestResult >> addAll: aTestResult [
	self failures addAll: aTestResult failures.
	self errors addAll: aTestResult errors.
	self passed addAll: aTestResult passed.
	self skipped addAll: aTestResult skipped
]

{ #category : #accessing }
TestResult >> caseCount [
	^self runCount + self skippedCount
]

{ #category : #accessing }
TestResult >> defects [
	^OrderedCollection new
		addAll: (self errors asArray sortBy: #printString);
		addAll: (self failures asArray sortBy: #printString);
		addAll: (self skipped asArray sortBy: #printString);
		yourself
]

{ #category : #accessing }
TestResult >> errorCount [
	^self errors size
]

{ #category : #accessing }
TestResult >> errors [
	errors isNil ifTrue: [errors := OrderedCollection new].
	^errors
]

{ #category : #accessing }
TestResult >> errors: aCollection [
	errors := aCollection
]

{ #category : #adding }
TestResult >> export [
	^Dictionary
		withAll: {#failures -> (self failures collect: #export).
			#errors -> (self errors collect: #export).
			#passed -> (self passed collect: #export).
			#skipped -> (self skipped collect: #export)}
]

{ #category : #accessing }
TestResult >> failureCount [
	^self failures size
]

{ #category : #accessing }
TestResult >> failures [
	failures isNil ifTrue: [failures := OrderedCollection new].
	^failures
]

{ #category : #testing }
TestResult >> hasDefects [
	^self hasErrors or: [failures anySatisfy: [:test | test isKnownIssue not]]
]

{ #category : #testing }
TestResult >> hasErrors [
	^self errors size > 0
]

{ #category : #testing }
TestResult >> hasFailures [
	^self failures size > 0
]

{ #category : #testing }
TestResult >> hasPassed [
	^self hasErrors not and: [self hasFailures not]
]

{ #category : #accessing }
TestResult >> ignoreErrors: aBlock [
	errors notNil ifTrue: [errors removeAllSuchThat: aBlock]
]

{ #category : #accessing }
TestResult >> ignoreFailures: aBlock [
	failures notNil ifTrue: [failures removeAllSuchThat: aBlock]
]

{ #category : #adding }
TestResult >> importAll: exported using: aTestSuite [
	| all |
	all := aTestSuite allCases.
	exported keysAndValuesDo: [:name :contents | | imported collection |
		imported := contents collect: [:data | | classname selector found |
			classname := data at: 1.
			selector := data at: 2.
			found := all
				detect: [:case | case selector = selector
					and: [case class name = classname]].
			found importFrom: data].
		collection := self perform: name.
		collection addAll: imported]
]

{ #category : #initialization }
TestResult >> initialize [
]

{ #category : #testing }
TestResult >> isError: aTestCase [
	^self errors includes: aTestCase
]

{ #category : #testing }
TestResult >> isFailure: aTestCase [
	^self failures includes: aTestCase
]

{ #category : #testing }
TestResult >> isPassed: aTestCase [
	^self passed includes: aTestCase
]

{ #category : #testing }
TestResult >> isSkipped: aTestCase [
	^self skipped includes: aTestCase
]

{ #category : #accessing }
TestResult >> knownErrors [
	^self errors select: [:f | f isKnownIssue]
]

{ #category : #accessing }
TestResult >> knownFailures [
	^self failures select: [:f | f isKnownIssue]
]

{ #category : #accessing }
TestResult >> knownIssues [
	^self knownFailures , self knownErrors
]

{ #category : #accessing }
TestResult >> passed [
	passed isNil ifTrue: [passed := OrderedCollection new].
	^passed
]

{ #category : #accessing }
TestResult >> passedCount [
	^self passed size
]

{ #category : #printing }
TestResult >> printOn: aStream [
	self printStatisticsOn: aStream
]

{ #category : #printing }
TestResult >> printStatisticsOn: aStream [
	| kf ke k f e |
	kf := self knownFailures size.
	ke := self knownErrors size.
	k := kf + ke.
	f := self failureCount - kf.
	e := self errorCount - ke.
	aStream
		nextPutAll: self runCount printString;
		nextPutAll: ' run, ';
		nextPutAll: self passedCount printString;
		nextPutAll: ' passed, ';
		nextPutAll: f printString;
		nextPutAll: ' failed, ';
		nextPutAll: self skippedCount printString;
		nextPutAll: ' skipped, '.
	k > 0 ifTrue: [aStream print: k; nextPutAll: ' known issues, '].
	aStream print: e; nextPutAll: ' error'.
	e != 1 ifTrue: [aStream nextPut: $s].
	e + f > 0 ifTrue: [aStream cr].
	f > 0 ifTrue: [
		aStream nextPutAll: 'Failures:'; cr.
		self unknownFailures do: [:failure | aStream print: failure; cr]].
	e > 0 ifTrue: [
		aStream nextPutAll: 'Errors:'; cr.
		self unknownErrors do: [:error | aStream print: error; cr]].
]

{ #category : #running }
TestResult >> runCase: aTestCase [
	| success t |
	success := [
		t := Kernel host currentMilliseconds.
		aTestCase runCase; time: Kernel host currentMilliseconds - t.
		true]
		sunitOn: self class failure
		do: [:signal | 
			aTestCase time: Kernel host currentMilliseconds - t.
			self failures add: aTestCase.
			signal sunitExitWith: false]
		on: self class skipped
		do: [:signal | 
			aTestCase time: Kernel host currentMilliseconds - t.
			self skipped add: aTestCase.
			signal sunitExitWith: false]
		on: self class error
		do: [:signal | 
			aTestCase time: Kernel host currentMilliseconds - t.
			self errors add: aTestCase.
			signal sunitExitWith: false].
	success ifTrue: [self passed add: aTestCase]
]

{ #category : #running }
TestResult >> runCaseAsError: aTestCase [
	| new |
	self errors add: aTestCase.
	new := aTestCase debugAsFailure.
	self errors remove: aTestCase.
	self passed add: new
]

{ #category : #running }
TestResult >> runCaseAsFailure: aTestCase [
	| new |
	self failures add: aTestCase.
	new := aTestCase debugAsFailure.
	self failures remove: aTestCase.
	self passed add: new
]

{ #category : #running }
TestResult >> runCaseRefresh: aTestCase [
	| failure error |
	failure := self isFailure: aTestCase.
	error := self isError: aTestCase.
	self passed remove: aTestCase ifAbsent: nil.
	self failures remove: aTestCase ifAbsent: nil.
	self errors remove: aTestCase ifAbsent: nil.
	failure ifTrue: [self runCaseAsFailure: aTestCase] ifFalse: [
		error
			ifTrue: [self runCaseAsError: aTestCase]
			ifFalse: [self runCase: aTestCase]]
]

{ #category : #accessing }
TestResult >> runCount [
	^self passedCount + self failureCount + self errorCount
]

{ #category : #accessing }
TestResult >> skipAll: cases [
	| s e |
	s := self skipped.
	cases do: [:case | s addIfAbsent: case]
]

{ #category : #accessing }
TestResult >> skipped [
	skipped isNil ifTrue: [skipped := OrderedCollection new].
	^skipped
]

{ #category : #accessing }
TestResult >> skippedCount [
	^self skipped size
]

{ #category : #services }
TestResult >> stateFor: aTestCase [
	| answer |
	(self isPassed: aTestCase) ifTrue: [answer := 'Pass'].
	(self isFailure: aTestCase) ifTrue: [answer := 'Failure'].
	(self isError: aTestCase) ifTrue: [answer := 'Error'].
	(self isSkipped: aTestCase) ifTrue: [answer := 'Skipped'].
	aTestCase isKnownIssue ifTrue: [answer := answer , ' (known)'].
	^answer
]

{ #category : #adding }
TestResult >> takeOut: aTestResult [
	self failures removeAll: aTestResult failures ifAbsent: nil.
	self errors removeAll: aTestResult errors ifAbsent: nil.
	self passed removeAll: aTestResult passed
]

{ #category : #accessing }
TestResult >> tests [
	^(OrderedCollection new: self runCount)
		addAll: self passed;
		addAll: self errors;
		addAll: self failures;
		addAll: self skipped;
		yourself
]

{ #category : #accessing }
TestResult >> totalCases [
	^self passedCount + self failureCount + self errorCount
]

{ #category : #accessing }
TestResult >> totalChecks [
	^self tests sum: [:test | test totalChecks] ifNone: 0
]

{ #category : #accessing }
TestResult >> totalTime [
	^(self passed sum: [:testCase | testCase time] ifNone: [0])
		+ (self failures sum: [:testCase | testCase time] ifNone: [0])
		+ (self errors sum: [:testCase | testCase time] ifNone: [0])
]

{ #category : #accessing }
TestResult >> unknownErrors [
	^self errors reject: [:f | f isKnownIssue]
]

{ #category : #accessing }
TestResult >> unknownFailures [
	^self failures reject: [:f | f isKnownIssue]
]

{ #category : #adding }
TestResult >> withAll: aTestResult [
	self addAll: aTestResult
]

