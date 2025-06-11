"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #ResumableTestFailureTestCase,
	#superclass : #TestCase,
	#category : #'SUnit.Tests'
}

{ #category : #unclassified }
ResumableTestFailureTestCase >> errorTest [
	1 zork
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> failureLog [
	^SUnitNameResolver defaultLogDevice
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> failureTest [
	self
		assert: false description: 'You should see me' resumable: true; 
		assert: false description: 'You should see me too' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> isLogging [
	^false
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> okTest [
	self assert: true
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> regularTestFailureTest [
	self assert: false description: 'You should see me'
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> resumableTestFailureTest [
	self
		assert: false description: 'You should see me' resumable: true; 
		assert: false description: 'You should see me too' resumable: true; 
		assert: false description: 'You should see me last' resumable: false; 
		assert: false description: 'You should not see me' resumable: true
]

{ #category : #unclassified }
ResumableTestFailureTestCase >> testResumable [
	| result suite |
	suite := TestSuite new.
	suite addTest: (self class selector: #errorTest).
	suite addTest: (self class selector: #regularTestFailureTest).
	suite addTest: (self class selector: #resumableTestFailureTest).
	suite addTest: (self class selector: #okTest).
	result := suite run.
	self assert: result failures size = 2;
		assert: result errors size = 1
]

