Class {
	#name : #EggSlotObject,
	#superclass : #EggHeapObject,
	#instVars : [
		'slots'
	],
	#category : #'Powerlang-Core-Execution-LMR'
}

{ #category : #accessing }
EggSlotObject >> at: index [
	^ slots at: header behavior classInstSize + index
]

{ #category : #accessing }
EggSlotObject >> at: index put: anLMRObject [	
	^ slots at: header behavior classInstSize + index put: anLMRObject
]

{ #category : #accessing }
EggSlotObject >> basicAt: index put: anLMRObject [
	^ slots at: index put: anLMRObject
]

{ #category : #accessing }
EggSlotObject >> header: anLMRObjectHeader [
	super header: anLMRObjectHeader.
	slots := Array new: header size
]

{ #category : #accessing }
EggSlotObject >> nilSlots: nilObj [
	slots atAllPut: nilObj
]

{ #category : #accessing }
EggSlotObject >> pointersSize [
	^ header size
]

{ #category : #accessing }
EggSlotObject >> size [
	^header size
]

{ #category : #accessing }
EggSlotObject >> slotAt: index [
	^ slots at: index
]

{ #category : #accessing }
EggSlotObject >> slotAt: index put: anLMRObject [
	^ slots at: index put: anLMRObject
]

{ #category : #accessing }
EggSlotObject >> slots [
	^ slots
]
