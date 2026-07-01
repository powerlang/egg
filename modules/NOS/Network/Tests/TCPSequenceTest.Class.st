'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #TCPSequenceTest category: 'SqueakNOS-Net-Tests'!
TestCase subclass: #TCPSequenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!TCPSequenceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testArithmetic
	self assert: (TCPSequenceNumber value: 16rFFFFFFFF) + 1 = (TCPSequenceNumber value: 0).
	self assert: (TCPSequenceNumber value: 0) - 1 = (TCPSequenceNumber value: 16rFFFFFFFF).
	self assert: (TCPSequenceNumber value: 0) + 1 = (TCPSequenceNumber value: 1).
	self assert: (TCPSequenceNumber value: 1) - 1 = (TCPSequenceNumber value: 0)
! !

!TCPSequenceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testComparision
	self assert: (TCPSequenceNumber value: 0) < (TCPSequenceNumber value: 1).
	self deny: (TCPSequenceNumber value: 1) < (TCPSequenceNumber value: 1).
	self deny: (TCPSequenceNumber value: 1) < (TCPSequenceNumber value: 0)
! !

!TCPSequenceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testReverseArithmetic
	self assert: 1 + (TCPSequenceNumber value: 16rFFFFFFFF) = (TCPSequenceNumber value: 0).
	self assert: 1 + (TCPSequenceNumber value: 0) = (TCPSequenceNumber value: 1)
! !

!TCPSequenceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testWrapAround
	self assert: (TCPSequenceNumber value: 16rFFFFFFFF) < (TCPSequenceNumber value: 0).
	self assert: (TCPSequenceNumber value: 16rFFFFFFF4) < (TCPSequenceNumber value: 4).
	self assert: (TCPSequenceNumber value: 16rFFFFFFF1) < (TCPSequenceNumber value: 15)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TCPSequenceTest class' category: 'SqueakNOS-Net-Tests'!
TCPSequenceTest class
	instanceVariableNames: ''!


