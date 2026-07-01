'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #BlockArithmeticTest category: 'SqueakNOS-Storage'!
TestCase subclass: #BlockArithmeticTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!BlockArithmeticTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testFirstPositionInSameBlock

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
! !

!BlockArithmeticTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testLastPositionInSameBlock

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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockArithmeticTest class' category: 'SqueakNOS-Storage'!
BlockArithmeticTest class
	instanceVariableNames: ''!


