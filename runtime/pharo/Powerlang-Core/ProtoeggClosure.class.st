Class {
	#name : 'ProtoeggClosure',
	#superclass : 'ProtoeggSlotObject',
	#instVars : [
		'block'
	],
	#category : 'Powerlang-Core-Execution-Bootstrap',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Bootstrap'
}

{ #category : 'instance creation' }
ProtoeggClosure class >> classFor: anRGBehavior [
	^ self
]

{ #category : 'accessing' }
ProtoeggClosure >> block [
	^block
]

{ #category : 'accessing' }
ProtoeggClosure >> block: anSCompiledBlock [
	block := anSCompiledBlock
]

{ #category : 'accessing' }
ProtoeggClosure >> executionTree [
	^ block optimizedCode
]

{ #category : 'accessing' }
ProtoeggClosure >> home [
	block capturesHome ifFalse: [ self error: 'closure has no home' ].
	^block capturesSelf ifTrue: [ self at: 2 ] ifFalse: [ self at: 1 ]
]

{ #category : 'accessing' }
ProtoeggClosure >> isClosure [ 
	^true
]

{ #category : 'accessing' }
ProtoeggClosure >> printOn: aStream [
	aStream
		nextPutAll: '<< ['.
	self slots do: [ :slot | aStream print: slot ] separatedBy: [ aStream nextPutAll: ', ' ].
aStream
		nextPutAll: '] >>'
]
