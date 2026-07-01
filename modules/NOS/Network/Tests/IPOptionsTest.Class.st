'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #IPOptionsTest category: 'SqueakNOS-Net-Tests'!
TestCase subclass: #IPOptionsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Tests'!
!IPOptionsTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testClassification
	| option |
	option := IPOption bytes: #(68 3 1). "timestamp"
	self assert: option classification = 2.
	self assert: option number = 4.
	self assert: option length = 3
! !

!IPOptionsTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testEOL
	| option |
	option := IPOption bytes: #(0).
	self assert: option classification = 0.
	self assert: option number = 0.
	self assert: option isEOL
! !

!IPOptionsTest methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:32:25'!
testNop
	| option |
	option := IPOption bytes: #(1).
	self assert: option classification = 0.
	self assert: option number = 1.
	self assert: option isNOP
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IPOptionsTest class' category: 'SqueakNOS-Net-Tests'!
IPOptionsTest class
	instanceVariableNames: ''!


