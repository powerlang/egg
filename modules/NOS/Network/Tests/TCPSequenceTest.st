Class {
	#name : #TCPSequenceTest,
	#superclass : #TestCase,
	#category : 'SqueakNOS-Net-Tests'
}

{ #category : #'as yet unclassified' }
TCPSequenceTest >> testArithmetic [
	self assert: (TCPSequenceNumber value: 16rFFFFFFFF) + 1 = (TCPSequenceNumber value: 0).
	self assert: (TCPSequenceNumber value: 0) - 1 = (TCPSequenceNumber value: 16rFFFFFFFF).
	self assert: (TCPSequenceNumber value: 0) + 1 = (TCPSequenceNumber value: 1).
	self assert: (TCPSequenceNumber value: 1) - 1 = (TCPSequenceNumber value: 0)
]

{ #category : #'as yet unclassified' }
TCPSequenceTest >> testComparision [
	self assert: (TCPSequenceNumber value: 0) < (TCPSequenceNumber value: 1).
	self deny: (TCPSequenceNumber value: 1) < (TCPSequenceNumber value: 1).
	self deny: (TCPSequenceNumber value: 1) < (TCPSequenceNumber value: 0)
]

{ #category : #'as yet unclassified' }
TCPSequenceTest >> testReverseArithmetic [
	self assert: 1 + (TCPSequenceNumber value: 16rFFFFFFFF) = (TCPSequenceNumber value: 0).
	self assert: 1 + (TCPSequenceNumber value: 0) = (TCPSequenceNumber value: 1)
]

{ #category : #'as yet unclassified' }
TCPSequenceTest >> testWrapAround [
	self assert: (TCPSequenceNumber value: 16rFFFFFFFF) < (TCPSequenceNumber value: 0).
	self assert: (TCPSequenceNumber value: 16rFFFFFFF4) < (TCPSequenceNumber value: 4).
	self assert: (TCPSequenceNumber value: 16rFFFFFFF1) < (TCPSequenceNumber value: 15)
]
