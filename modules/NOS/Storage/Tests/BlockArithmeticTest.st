Class {
	#name : #BlockArithmeticTest,
	#superclass : #TestCase,
	#category : 'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
BlockArithmeticTest >> testFirstPositionInSameBlock [

	| helper |
	helper := BlockArithmetic new size: 512.

	self assert: (helper firstPositionInSameBlockOf: 1) = 1.
	self assert: (helper firstPositionInSameBlockOf: 2) = 1.
	self assert: (helper firstPositionInSameBlockOf: 300) = 1.
	self assert: (helper firstPositionInSameBlockOf: 511) = 1.
	self assert: (helper firstPositionInSameBlockOf: 512) = 1.
	self assert: (helper firstPositionInSameBlockOf: 513) = 513.
	self assert: (helper firstPositionInSameBlockOf: 514) = 513.
	self assert: (helper firstPositionInSameBlockOf: 1024) = 513.
	self assert: (helper firstPositionInSameBlockOf: 1025) = 1025.
]

{ #category : #'as yet unclassified' }
BlockArithmeticTest >> testLastPositionInSameBlock [

	| helper |
	helper := BlockArithmetic new size: 512.

	self assert: (helper lastPositionInSameBlockOf: 1) = 512.
	self assert: (helper lastPositionInSameBlockOf: 2) = 512.
	self assert: (helper lastPositionInSameBlockOf: 300) = 512.
	self assert: (helper lastPositionInSameBlockOf: 511) = 512.
	self assert: (helper lastPositionInSameBlockOf: 512) = 512.
	self assert: (helper lastPositionInSameBlockOf: 513) = 1024.
	self assert: (helper lastPositionInSameBlockOf: 514) = 1024.
	self assert: (helper lastPositionInSameBlockOf: 1024) = 1024.
	self assert: (helper lastPositionInSameBlockOf: 1025) = 1536.
]
