Class {
	#name : 'EggHeapObject',
	#superclass : 'EggObject',
	#instVars : [
		'header'
	],
	#category : 'Powerlang-Core-Execution-Metacircular',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Metacircular'
}

{ #category : 'accessing' }
EggHeapObject >> behavior [
	^header behavior
]

{ #category : 'accessing' }
EggHeapObject >> behavior: anLMRHeapObject [
	header behavior: anLMRHeapObject
]

{ #category : 'accessing' }
EggHeapObject >> header: anInteger [
	header := anInteger
]

{ #category : 'accessing' }
EggHeapObject >> headerFlags [
	^header flags
]

{ #category : 'accessing' }
EggHeapObject >> headerHash [
	^ header hash
]

{ #category : 'accessing' }
EggHeapObject >> headerHash: anInteger [
	header hash: anInteger
]

{ #category : 'accessing' }
EggHeapObject >> isSmall [
	^ header isSmall
]

{ #category : 'accessing' }
EggHeapObject >> localClassName [
	^ self behavior localClassName
]

{ #category : 'accessing' }
EggHeapObject >> printOn: aStream [
	self behavior printInstance: self on: aStream
]

{ #category : 'accessing' }
EggHeapObject >> size [
	^header size
]
