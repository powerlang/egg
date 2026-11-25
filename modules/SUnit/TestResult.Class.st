'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestResult category: #SUnit!
Object subclass: #TestResult
	instanceVariableNames: 'failures errors passed skipped'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!TestResult commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!TestResult methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:37'!
addAll: aTestResult
	self failures addAll: aTestResult failures.
	self errors addAll: aTestResult errors.
	self passed addAll: aTestResult passed.
	self skipped addAll: aTestResult skipped
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
caseCount
	^self runCount + self skippedCount
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
defects
	^OrderedCollection new
		addAll: (self errors asArray sortBy: #printString);
		addAll: (self failures asArray sortBy: #printString);
		addAll: (self skipped asArray sortBy: #printString);
		yourself
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
errorCount
	^self errors size
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
errors
	errors isNil ifTrue: [errors := OrderedCollection new].
	^errors
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
errors: aCollection
	errors := aCollection
! !

!TestResult methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:37'!
export
	^Dictionary
		withAll: {#failures -> (self failures collect: #export).
			#errors -> (self errors collect: #export).
			#passed -> (self passed collect: #export).
			#skipped -> (self skipped collect: #export)}
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
failureCount
	^self failures size
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
failures
	failures isNil ifTrue: [failures := OrderedCollection new].
	^failures
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasDefects
	^self hasErrors or: [failures anySatisfy: [:test | test isKnownIssue not]]
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasErrors
	^self errors size > 0
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasFailures
	^self failures size > 0
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasPassed
	^self hasErrors not and: [self hasFailures not]
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
ignoreErrors: aBlock
	errors notNil ifTrue: [errors removeAllSuchThat: aBlock]
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
ignoreFailures: aBlock
	failures notNil ifTrue: [failures removeAllSuchThat: aBlock]
! !

!TestResult methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:37'!
importAll: exported using: aTestSuite
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
! !

!TestResult methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isError: aTestCase
	^self errors includes: aTestCase
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isFailure: aTestCase
	^self failures includes: aTestCase
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isPassed: aTestCase
	^self passed includes: aTestCase
! !

!TestResult methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isSkipped: aTestCase
	^self skipped includes: aTestCase
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
knownErrors
	^self errors select: [:f | f isKnownIssue]
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
knownFailures
	^self failures select: [:f | f isKnownIssue]
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
knownIssues
	^self knownFailures , self knownErrors
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
passed
	passed isNil ifTrue: [passed := OrderedCollection new].
	^passed
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
passedCount
	^self passed size
! !

!TestResult methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printOn: aStream
	self printStatisticsOn: aStream
! !

!TestResult methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printStatisticsOn: aStream
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
	e !!= 1 ifTrue: [aStream nextPut: $s].
	e + f > 0 ifTrue: [aStream cr].
	f > 0 ifTrue: [
		aStream nextPutAll: 'Failures:'; cr.
		self unknownFailures do: [:failure | aStream print: failure; cr]].
	e > 0 ifTrue: [
		aStream nextPutAll: 'Errors:'; cr.
		self unknownErrors do: [:error | aStream print: error; cr]].
! !

!TestResult methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCase: aTestCase
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
! !

!TestResult methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCaseAsError: aTestCase
	| new |
	self errors add: aTestCase.
	new := aTestCase debugAsFailure.
	self errors remove: aTestCase.
	self passed add: new
! !

!TestResult methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCaseAsFailure: aTestCase
	| new |
	self failures add: aTestCase.
	new := aTestCase debugAsFailure.
	self failures remove: aTestCase.
	self passed add: new
! !

!TestResult methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCaseRefresh: aTestCase
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
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
runCount
	^self passedCount + self failureCount + self errorCount
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipAll: cases
	| s e |
	s := self skipped.
	cases do: [:case | s addIfAbsent: case]
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipped
	skipped isNil ifTrue: [skipped := OrderedCollection new].
	^skipped
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
skippedCount
	^self skipped size
! !

!TestResult methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
stateFor: aTestCase
	| answer |
	(self isPassed: aTestCase) ifTrue: [answer := 'Pass'].
	(self isFailure: aTestCase) ifTrue: [answer := 'Failure'].
	(self isError: aTestCase) ifTrue: [answer := 'Error'].
	(self isSkipped: aTestCase) ifTrue: [answer := 'Skipped'].
	aTestCase isKnownIssue ifTrue: [answer := answer , ' (known)'].
	^answer
! !

!TestResult methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:37'!
takeOut: aTestResult
	self failures removeAll: aTestResult failures ifAbsent: nil.
	self errors removeAll: aTestResult errors ifAbsent: nil.
	self passed removeAll: aTestResult passed
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
tests
	^(OrderedCollection new: self runCount)
		addAll: self passed;
		addAll: self errors;
		addAll: self failures;
		addAll: self skipped;
		yourself
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
totalCases
	^self passedCount + self failureCount + self errorCount
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
totalChecks
	^self tests sum: [:test | test totalChecks] ifNone: 0
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
totalTime
	^(self passed sum: [:testCase | testCase time] ifNone: [0])
		+ (self failures sum: [:testCase | testCase time] ifNone: [0])
		+ (self errors sum: [:testCase | testCase time] ifNone: [0])
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
unknownErrors
	^self errors reject: [:f | f isKnownIssue]
! !

!TestResult methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
unknownFailures
	^self failures reject: [:f | f isKnownIssue]
! !

!TestResult methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:37'!
withAll: aTestResult
	self addAll: aTestResult
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestResult class' category: #SUnit!
TestResult class
	instanceVariableNames: ''!

!TestResult class methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
error
	^self exError
! !

!TestResult class methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
exError
	^SUnitNameResolver errorObject
! !

!TestResult class methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
failure
	^TestFailure
! !

!TestResult class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
signalErrorWith: aString
	self error sunitSignalWith: aString
! !

!TestResult class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
signalFailureWith: aString
	self failure sunitSignalWith: aString
! !

!TestResult class methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipped
	^TestSkipped
! !


TestResult initialize!

