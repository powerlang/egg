'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #WriteListTest category: 'SqueakNOS-Storage-Tests'!
TestCase subclass: #WriteListTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage-Tests'!
!WriteListTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testAddingBlocks

	| list |
	list := WriteList new.
	
	list reserve: 5 at: 10.
	list reserve: 10 at: 50.
	list reserve: 15 at: 18.
	list reserve: 3 at: 15.
	
	self assert: list blocks = (OrderedCollection with: { 10. 18+ 15 } with: { 50. 60 }).
! !

!WriteListTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
testAddingContiguousBlocks

	| list |
	list := WriteList new.
	
	list reserve: 1 at: 28322905.
	list reserve: 1 at: 28322906.
	list reserve: 64 at: 28322907.
	
	self assert: list blocks = (OrderedCollection with: { 28322905. 28322907 + 64 }).
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WriteListTest class' category: 'SqueakNOS-Storage-Tests'!
WriteListTest class
	instanceVariableNames: ''!


