Class {
	#name : #MemoryBlock,
	#superclass : #Object,
	#instVars : [
		'interval',
		'description'
	],
	#category : #'SqueakNOS-Devices-Memory'
}

{ #category : #'instance creation' }
MemoryBlock class >> from: start to: end description: aString [
	^self new interval: (Interval from: start to: end); description: aString
]

{ #category : #accessing }
MemoryBlock >> description [
	^description
]

{ #category : #accessing }
MemoryBlock >> description: aString [
	description := aString
]

{ #category : #accessing }
MemoryBlock >> end [
	^interval last
]

{ #category : #accessing }
MemoryBlock >> interval [
	^interval
]

{ #category : #accessing }
MemoryBlock >> interval: anInterval [
	interval := anInterval
]

{ #category : #printing }
MemoryBlock >> printOn: aStream [
	^aStream nextPutAll: self interval first printString; nextPut: $-; nextPutAll: self interval last printString; nextPut: $(;nextPutAll: self description; nextPut: $)
]

{ #category : #accessing }
MemoryBlock >> start [
	^interval first
]
