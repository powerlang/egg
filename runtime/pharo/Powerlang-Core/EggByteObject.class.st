Class {
	#name : #EggByteObject,
	#superclass : #EggHeapObject,
	#instVars : [
		'bytes'
	],
	#category : #'Powerlang-Core-Execution-LMR'
}

{ #category : #accessing }
EggByteObject >> asLocalString [
	^ bytes allButLast asString
]

{ #category : #accessing }
EggByteObject >> at: index [

	^bytes at: index
]

{ #category : #accessing }
EggByteObject >> at: index put: anLMRObject [
	| value |
	value := anLMRObject value.
	bytes at: index put: value.
	^ anLMRObject
]

{ #category : #accessing }
EggByteObject >> bytes [
	^bytes
]

{ #category : #accessing }
EggByteObject >> bytes: aByteArray [
	self ASSERT: aByteArray size = header size.
	self ASSERT: aByteArray class == ByteArray.
	bytes := aByteArray
]

{ #category : #accessing }
EggByteObject >> header: anLMRObjectHeader [
	super header: anLMRObjectHeader.
	bytes := ByteArray new: header size
]

{ #category : #accessing }
EggByteObject >> isBytes [
	^true
]
