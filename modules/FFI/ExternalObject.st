"
	Copyright (c) 2024, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ExternalObject,
	#superclass : #Object,
	#instVars: [
		'handle'
	],
	#category : #FFI
}

{ #category : #'accessing' }
ExternalObject >> asParameter [
	^handle
]

{ #category : #'accessing' }
ExternalObject >> handle [
	^handle
]

{ #category : #'accessing' }
ExternalObject >> handle: anObject [
	handle := anObject
]

{ #category : #'testing' }
ExternalObject >> isValid [
	^handle notNil
]

{ #category : #'testing' }
ExternalObject >> initialize [
	self requireFinalization
]

{ #category : #'testing' }
ExternalObject >> release [
]
