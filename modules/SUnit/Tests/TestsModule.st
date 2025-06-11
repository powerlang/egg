Class {
	#name : #TestsModule,
	#superclass : #Module,
	#category : #Test
}

{ #category : #spec }
TestsModule >> imports [
	^{
		#Kernel -> #(Error).
		#SUnit -> #(SUnitNameResolver TestCase TestResource TestResult TestSuite)
	}
]

{ #category : #spec }
TestsModule >> initialize [
	super initialize
]

{ #category : #spec }
TestsModule >> main: args [
	| result |
	Kernel log: 'running tests...', String cr.

	result := SUnitTest buildTestSuite run.
	Kernel log: 'done', String cr.
	Kernel log: 'Results: ', String cr.
	Kernel log: result printString, String cr, String cr.
]