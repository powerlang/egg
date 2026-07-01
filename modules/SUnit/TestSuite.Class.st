'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #TestSuite category: #SUnit!
Object subclass: #TestSuite
	instanceVariableNames: 'tests resources name view current stop'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SUnit'!
!TestSuite commentStamp: '<historical>' prior: 0!

	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
!

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addDependent: anObject
	self when: #changed send: #update to: anObject
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addDependentToHierachy: anObject
	self addDependent: anObject.
	self tests do: [:each | each addDependentToHierachy: anObject]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addDependentToHierarchy: anObject
	self addDependent: anObject.
	self tests do: [:each | each addDependentToHierarchy: anObject]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addTest: test
	test suite: self.
	self tests add: test
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
addTests: aCollection
	aCollection do: [:test | self addTest: test]
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
allCases
	^self tests gather: [:test | test allCases]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
anyTest
	tests isNil ifTrue: [^nil].
	tests isEmpty ifTrue: [^nil].
	^tests anyone anyTest
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
basicRun: aTestResult
	self tests do: [:test | 
		self run: test result: aTestResult]
! !

!TestSuite methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
caseCount
	^self tests sum: #caseCount
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
currentTest
	^current notNil ifTrue: [current currentTest]
! !

!TestSuite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
defaultResources
	| default |
	default := Dictionary new.
	self tests do: [:test | 
		test resources do: [:resource | | users |
			users := default at: resource ifAbsentPut: [OrderedCollection new].
			users add: test]].
	^default
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
innerSuites
	^tests isNil
		ifTrue: [#()]
		ifFalse: [tests select: [:t | t isKindOf: TestSuite]]
! !

!TestSuite methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isLike: aTestSuite
	aTestSuite class == self class ifFalse: [^false].
	^aTestSuite name = name
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name
	^name
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name: aString
	name := aString
! !

!TestSuite methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printOn: aStream
	name isNil ifTrue: [^super printOn: aStream].
	aStream
		nextPutAll: self class name;
		nextPutAll: ' for ';
		nextPutAll: name
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeAllSuchThat: aBlock
	tests isNil ifTrue: [^self].
	tests removeAllSuchThat: aBlock.
	tests do: [:test | test removeAllSuchThat: aBlock]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeDependentFromHierachy: anObject
	self removeDependent: anObject.
	self tests do: [:each | each removeDependentFromHierachy: anObject]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeDependentFromHierarchy: anObject
	self removeDependent: anObject.
	self tests do: [:each | each removeDependentFromHierarchy: anObject]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
removeTests: aCollection
	self
		removeAllSuchThat: [:t | aCollection anySatisfy: [:test | test isLike: t]]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
resources
	resources isNil ifTrue: [resources := self defaultResources].
	^resources keys
! !

!TestSuite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
resultChanged: aTestResult
	"self triggerEvent: #resultChanged: with: aTestResult"
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
run
	| result |
	result := TestResult new.
	self run: result.
	^result
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
runDebug
	| res |
	res := self resources.
	res do: [:resource | resource beAvailableFor: self].
	[
		self allCases do: [:test |
			Kernel log: 'running ', test printString; log: String cr.
			test runCase]]
		sunitEnsure: [res do: [:resource | resource reset]]
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
run: aTestResult
	| res |
	res := self setUpResources: aTestResult.
	[
		stop == true ifTrue: [^self].
		self basicRun: aTestResult]
		sunitEnsure: [res do: [:resource | resource reset]]
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
run: test result: aTestResult
	current := test.
"	self changed: self."
	stop == true ifTrue: [^self].
	(test isKindOf: TestSuite) ifTrue: [
		"test
			when: #changed: send: #changed: to: self;
			when: #resultChanged: send: #resultChanged: to: self"].
	test basicRun: aTestResult.
	self resultChanged: aTestResult
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
setUpResources: aTestResult
	| res |
	res := [self resources] on: Error do: [
		aTestResult skipAll: self allCases.
		{}].
	res do: [:resource | 
		[resource beAvailableFor: self]
			on: Error
			do: [self skipTestsUsing: resource in: aTestResult]].
	^res
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
size
	^tests isNil
		ifTrue: [0]
		ifFalse: [tests
			sum: [:t | (t isKindOf: TestCase) ifTrue: [1] ifFalse: [t size]]]
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
skipTestsUsing: aResource in: aTestResult
	| users |
	users := resources at: aResource.
	users do: [:test | aTestResult skipAll: test allCases]
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
stop
	self stop: true
! !

!TestSuite methodsFor:  'running' stamp: 'KenD 28/Jun/2026 13:27:37'!
stop: aBoolean
	stop := aBoolean.
	tests notNil ifTrue: [tests do: [:suite | suite stop: aBoolean]]
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
suite
	^self
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
suite: aTestSuite
	"
	Do nothing, compatibility with TestCase
	"
! !

!TestSuite methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
tests
	tests isNil ifTrue: [tests := OrderedCollection new].
	^tests
			
! !

!TestSuite methodsFor:  'exceptions' stamp: 'KenD 28/Jun/2026 13:27:37'!
uniqueCaseCount
	| signatures |
	signatures := self allCases collect: #signature.
	^signatures withoutDuplicates size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TestSuite class' category: #SUnit!
TestSuite class
	instanceVariableNames: ''!

!TestSuite class methodsFor:  'events' stamp: 'KenD 28/Jun/2026 13:27:37'!
availableEvents
	^super availableEvents add: #resultChanged:; yourself
! !

!TestSuite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
forModule: aModule
	| suite |
	suite := self named: aModule name.
	aModule classes do: [:cls |
		(cls inheritsFrom: TestCase) ifTrue: [
			suite addTest: cls buildTestSuite]].
	^suite
! !

!TestSuite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
fromString: aString
	| suite cm |
	suite := self named: 'From strings'.
	aString lines do: [:line | 
		cm := CompiledMethod fromSignature: line withoutSeparators.
		suite addTest: (cm classBinding selector: cm selector)].
	^suite
! !

!TestSuite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
named: aString
	^self new name: aString; yourself
! !

!TestSuite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
named: aString with: objects
	| tests |
	tests := objects collect: [:o | 
		o isClass ifTrue: [o buildSuiteFromSelectors] ifFalse: [
			self ASSERT: o isAssociation.
			o key buildSuiteFromMethods: {o value}]].
	^self named: aString withTests: tests
! !

!TestSuite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
named: aString withTests: aCollection
	^self new name: aString; addTests: aCollection
! !


