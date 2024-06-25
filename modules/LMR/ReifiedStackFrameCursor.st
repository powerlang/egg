"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ReifiedStackFrameCursor,
	#superclass : #StackFrameCursor,
	#category : #Kernel
}

{ #category : #accessing }
ReifiedStackFrameCursor >> addObjectsTo: aCollection [
	self slotCount to: 1 by: -1 do: [:i | aCollection add: (self slotAt: i)]
]

{ #category : #accessing }
ReifiedStackFrameCursor >> caller [
	^current + ((current _asObject _basicAt: 1) // 2)
]

{ #category : #testing }
ReifiedStackFrameCursor >> ended [
	^current == previous
]

{ #category : #accessing }
ReifiedStackFrameCursor >> objectsDo: aBlock [
	self slotCount to: 1 by: -1 do: [:i | aBlock value: (self slotAt: i)]
]

