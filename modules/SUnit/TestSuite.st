"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestSuite,
	#superclass : #Object,
	#instVars : [
		'tests',
		'resources',
		'name',
		'view',
		'current',
		'stop'
	],
	#category : #SUnit
}

{ #category : #events }
TestSuite class >> availableEvents [
	^super availableEvents add: #resultChanged:; yourself
]

{ #category : #'instance creation' }
TestSuite class >> fromString: aString [
	| suite cm |
	suite := self named: 'From strings'.
	aString lines do: [:line | 
		cm := CompiledMethod fromSignature: line withoutSeparators.
		suite addTest: (cm classBinding selector: cm selector)].
	^suite
]

{ #category : #'instance creation' }
TestSuite class >> named: aString [
	^self new name: aString; yourself
]

{ #category : #'instance creation' }
TestSuite class >> named: aString with: objects [
	| tests |
	tests := objects collect: [:o | 
		o isClass ifTrue: [o buildSuiteFromSelectors] ifFalse: [
			self ASSERT: o isAssociation.
			o key buildSuiteFromMethods: {o value}]].
	^self named: aString withTests: tests
]

{ #category : #'instance creation' }
TestSuite class >> named: aString withTests: aCollection [
	^self new name: aString; addTests: aCollection
]

{ #category : #accessing }
TestSuite >> addDependent: anObject [
	self when: #changed send: #update to: anObject
]

{ #category : #accessing }
TestSuite >> addDependentToHierachy: anObject [
	self addDependent: anObject.
	self tests do: [:each | each addDependentToHierachy: anObject]
]

{ #category : #accessing }
TestSuite >> addDependentToHierarchy: anObject [
	self addDependent: anObject.
	self tests do: [:each | each addDependentToHierarchy: anObject]
]

{ #category : #accessing }
TestSuite >> addTest: test [
	test suite: self.
	self tests add: test
]

{ #category : #accessing }
TestSuite >> addTests: aCollection [
	aCollection do: [:test | self addTest: test]
]

{ #category : #running }
TestSuite >> allCases [
	^self tests gather: [:test | test allCases]
]

{ #category : #accessing }
TestSuite >> anyTest [
	tests isNil ifTrue: [^nil].
	tests isEmpty ifTrue: [^nil].
	^tests anyone anyTest
]

{ #category : #running }
TestSuite >> basicRun: aTestResult [
	self tests do: [:test | 
		self run: test result: aTestResult]
]

{ #category : #exceptions }
TestSuite >> caseCount [
	^self tests sum: #caseCount
]

{ #category : #accessing }
TestSuite >> currentTest [
	^current notNil ifTrue: [current currentTest]
]

{ #category : #private }
TestSuite >> defaultResources [
	| default |
	default := Dictionary new.
	self tests do: [:test | 
		test resources do: [:resource | | users |
			users := default at: resource ifAbsentPut: [OrderedCollection new].
			users add: test]].
	^default
]

{ #category : #accessing }
TestSuite >> innerSuites [
	^tests isNil
		ifTrue: [#()]
		ifFalse: [tests select: [:t | t isKindOf: TestSuite]]
]

{ #category : #comparing }
TestSuite >> isLike: aTestSuite [
	aTestSuite class == self class ifFalse: [^false].
	^aTestSuite name = name
]

{ #category : #accessing }
TestSuite >> name [
	^name
]

{ #category : #accessing }
TestSuite >> name: aString [
	name := aString
]

{ #category : #printing }
TestSuite >> printOn: aStream [
	name isNil ifTrue: [^super printOn: aStream].
	aStream
		nextPutAll: self class name;
		nextPutAll: ' for ';
		nextPutAll: name
]

{ #category : #accessing }
TestSuite >> removeAllSuchThat: aBlock [
	tests isNil ifTrue: [^self].
	tests removeAllSuchThat: aBlock.
	tests do: [:test | test removeAllSuchThat: aBlock]
]

{ #category : #accessing }
TestSuite >> removeDependentFromHierachy: anObject [
	self removeDependent: anObject.
	self tests do: [:each | each removeDependentFromHierachy: anObject]
]

{ #category : #accessing }
TestSuite >> removeDependentFromHierarchy: anObject [
	self removeDependent: anObject.
	self tests do: [:each | each removeDependentFromHierarchy: anObject]
]

{ #category : #accessing }
TestSuite >> removeTests: aCollection [
	self
		removeAllSuchThat: [:t | aCollection anySatisfy: [:test | test isLike: t]]
]

{ #category : #accessing }
TestSuite >> resources [
	resources isNil ifTrue: [resources := self defaultResources].
	^resources keys
]

{ #category : #private }
TestSuite >> resultChanged: aTestResult [
	"self triggerEvent: #resultChanged: with: aTestResult"
]

{ #category : #running }
TestSuite >> run [
	| result |
	result := TestResult new.
	self run: result.
	^result
]

{ #category : #running }
TestSuite >> run: aTestResult [
	| res |
	res := self setUpResources: aTestResult.
	[
		stop == true ifTrue: [^self].
		self basicRun: aTestResult]
		sunitEnsure: [res do: [:resource | resource reset]]
]

{ #category : #running }
TestSuite >> run: test result: aTestResult [
	current := test.
"	self changed: self."
	stop == true ifTrue: [^self].
	(test isKindOf: TestSuite) ifTrue: [
		"test
			when: #changed: send: #changed: to: self;
			when: #resultChanged: send: #resultChanged: to: self"].
	test basicRun: aTestResult.
	self resultChanged: aTestResult
]

{ #category : #running }
TestSuite >> setUpResources: aTestResult [
	| res |
	res := [self resources] on: Error do: [
		aTestResult skipAll: self allCases.
		{}].
	res do: [:resource | 
		[resource beAvailableFor: self]
			on: Error
			do: [self skipTestsUsing: resource in: aTestResult]].
	^res
]

{ #category : #accessing }
TestSuite >> size [
	^tests isNil
		ifTrue: [0]
		ifFalse: [tests
			sum: [:t | (t isKindOf: TestCase) ifTrue: [1] ifFalse: [t size]]]
]

{ #category : #running }
TestSuite >> skipTestsUsing: aResource in: aTestResult [
	| users |
	users := resources at: aResource.
	users do: [:test | aTestResult skipAll: test allCases]
]

{ #category : #running }
TestSuite >> stop [
	self stop: true
]

{ #category : #running }
TestSuite >> stop: aBoolean [
	stop := aBoolean.
	tests notNil ifTrue: [tests do: [:suite | suite stop: aBoolean]]
]

{ #category : #accessing }
TestSuite >> suite [
	^self
]

{ #category : #accessing }
TestSuite >> suite: aTestSuite [
	"
	Do nothing, compatibility with TestCase
	"
]

{ #category : #accessing }
TestSuite >> tests [
	tests isNil ifTrue: [tests := OrderedCollection new].
	^tests
			
]

{ #category : #exceptions }
TestSuite >> uniqueCaseCount [
	| signatures |
	signatures := self allCases collect: #signature.
	^signatures withoutDuplicates size
]

