Class {
	#name : #WriteListTest,
	#superclass : #TestCase,
	#category : #'SqueakNOS-Storage-Tests'
}

{ #category : #'as yet unclassified' }
WriteListTest >> testAddingBlocks [

	| list |
	list := WriteList new.
	
	list reserve: 5 at: 10.
	list reserve: 10 at: 50.
	list reserve: 15 at: 18.
	list reserve: 3 at: 15.
	
	self assert: list blocks = (OrderedCollection with: { 10. 18+ 15 } with: { 50. 60 }).
]

{ #category : #'as yet unclassified' }
WriteListTest >> testAddingContiguousBlocks [

	| list |
	list := WriteList new.
	
	list reserve: 1 at: 28322905.
	list reserve: 1 at: 28322906.
	list reserve: 64 at: 28322907.
	
	self assert: list blocks = (OrderedCollection with: { 28322905. 28322907 + 64 }).
]
