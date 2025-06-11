"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SimpleTestResourceTestCase,
	#superclass : #TestCase,
	#instVars : [
		'resource'
	],
	#category : #'SUnit.Tests'
}

{ #category : #unclassified }
SimpleTestResourceTestCase class >> resources [
	^Set new add: SimpleTestResource; yourself
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> dummy [
	self assert: true
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> error [
	'foo' odd
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> fail [
	self assert: false
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> setRun [
	resource setRun
]

{ #category : #'set up' }
SimpleTestResourceTestCase >> setUp [
	resource := SimpleTestResource current
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> testRan [
	| case |

	case := self class selector: #setRun.
	case run.
	self assert: resource hasSetup.
	self assert: resource hasRun
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> testResourceInitRelease [
	| result suite error failure |
	suite := TestSuite new.
	suite addTest: (error := self class selector: #error).
	suite addTest: (failure := self class selector: #fail).
	suite addTest: (self class selector: #dummy).
	result := suite run.
	self assert: resource hasSetup
]

{ #category : #unclassified }
SimpleTestResourceTestCase >> testResourcesCollection [
	| collection |
	collection := self resources.
	self assert: collection size = 1
]

