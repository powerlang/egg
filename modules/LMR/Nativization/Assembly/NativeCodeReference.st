Class {
	#name : #NativeCodeReference,
	#superclass : #Object,
	#instVars : [
		'source',
		'sourceOffset',
		'target',
		'absolute'
	],
	#category : #'Powerlang-Core-Assembly'
}

{ #category : #'as yet unclassified' }
NativeCodeReference class >> absoluteFor: anObject [
	^(self new for: anObject) beAbsolute
]

{ #category : #'instance creation' }
NativeCodeReference class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : #accessing }
NativeCodeReference >> beAbsolute [
	absolute := true
]

{ #category : #accessing }
NativeCodeReference >> classBinding [
	^source classBinding
]

{ #category : #accessing }
NativeCodeReference >> for: anObject [
	self target: anObject
]

{ #category : #accessing }
NativeCodeReference >> initialize [
	absolute := false
]

{ #category : #accessing }
NativeCodeReference >> isAbsolute [
	^absolute
]

{ #category : #accessing }
NativeCodeReference >> printOn: aStream [
	aStream nextPutAll: 'Ref to '; print: target
]

{ #category : #accessing }
NativeCodeReference >> source: sourceObject [
	source := sourceObject
]

{ #category : #accessing }
NativeCodeReference >> sourceOffset [
	^sourceOffset
]

{ #category : #accessing }
NativeCodeReference >> sourceOffset: aNumber [
	sourceOffset := aNumber
]

{ #category : #accessing }
NativeCodeReference >> target [
	^target
]

{ #category : #accessing }
NativeCodeReference >> target: anObject [
	target := anObject
]
