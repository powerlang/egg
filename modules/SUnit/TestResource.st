"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TestResource,
	#superclass : #Object,
	#instVars : [
		'name',
		'description'
	],
	#category : #SUnit
}

{ #category : #'pm support' }
TestResource class >> aboutToSaveLibraryOn: aCodeSegmentBuilder [
	aCodeSegmentBuilder map: current to: nil
]

{ #category : #testing }
TestResource class >> beAvailableFor: aTestSuite [
	^self current notNil and: [self current beAvailableFor: aTestSuite]
]

{ #category : #accessing }
TestResource class >> current [
	current isNil ifTrue: [current := self new].
	^current
]

{ #category : #accessing }
TestResource class >> current: aTestResource [
	current := aTestResource
]

{ #category : #testing }
TestResource class >> isAbstract [
	"Override to true if a TestResource subclass is Abstract and should not have TestCase
	instances built from it"
	^self name = 'TestResource'
]

{ #category : #testing }
TestResource class >> isUnavailable [
	^self isAvailable not
]

{ #category : #accessing }
TestResource class >> reset [
	current notNil ifTrue: [[current tearDown] ensure: [current := nil]]
]

{ #category : #accessing }
TestResource class >> resources [
	^#()
]

{ #category : #exceptions }
TestResource class >> signalInitializationError [
	^TestResult
		signalErrorWith: 'Resource ' , self name , ' could not be initialized'
]

{ #category : #testing }
TestResource >> beAvailable [
	self isAvailable ifFalse: [self signalInitializationError]
]

{ #category : #testing }
TestResource >> beAvailableFor: aTestSuite [
	self beAvailable
]

{ #category : #accessing }
TestResource >> description [
	description isNil ifTrue: [^''].
	^description
]

{ #category : #accessing }
TestResource >> description: aString [
	description := aStrin
]

{ #category : #initialization }
TestResource >> initialize [
	self setUp
]

{ #category : #testing }
TestResource >> isAvailable [
	^true
]

{ #category : #testing }
TestResource >> isUnavailable [
	^self isAvailable not
]

{ #category : #accessing }
TestResource >> name [
	name isNil ifTrue: [^self printString].
	^name
]

{ #category : #accessing }
TestResource >> name: aString [
	name := aString
]

{ #category : #printing }
TestResource >> printOn: aStream [
	aStream nextPutAll: self class printString
]

{ #category : #accessing }
TestResource >> resources [
	^self class resources
]

{ #category : #'set up' }
TestResource >> setUp [
]

{ #category : #exceptions }
TestResource >> signalInitializationError [
	^self class signalInitializationError
]

{ #category : #finalization }
TestResource >> tearDown [
]

