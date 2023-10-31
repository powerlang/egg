"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #Recursion,
	#superclass : #Error,
	#instVars : [
		'object'
	],
	#category : #Kernel
}

{ #category : #services }
Recursion class >> check: anObject in: aSet while: aBlock [
	^(aSet includes: anObject) ifTrue: [self signalOn: anObject] ifFalse: [
		aSet add: anObject.
		aBlock ensure: [aSet remove: anObject]]
]

{ #category : #services }
Recursion class >> checkOn: anObject while: aBlock [
	^self check: anObject in: Recursion recursionSet while: aBlock
]

{ #category : #services }
Recursion class >> checkOn: anObject while: aBlock onSignal: exceptionBlock [
	| set |
	set := Recursion recursionSet.
	^[self check: anObject in: set while: aBlock] on: self do: exceptionBlock
]

{ #category : #accessing }
Recursion class >> recursionSet [
	| handler set |
	handler := ActiveProcess.
	[
		handler := handler notNil ifTrue: [handler findHandlerFor: self new].
		handler notNil
			ifTrue: [set := handler propertyAt: #recursionSet ifAbsent: nil].
		handler notNil and: [set isNil]]
		whileTrue: [handler := handler nextHandler].
	^set ifNil: [
		ActiveProcess exceptionHandler
			propertyAt: #recursionSet
			ifAbsentPut: [IdentitySet new]]
]

{ #category : #'instance creation' }
Recursion class >> signalOn: anObject [
	^self new signalOn: anObject
]

{ #category : #signaling }
Recursion >> description [
	^'recursive structure found at ' , object class name withArticle
]

{ #category : #signaling }
Recursion >> signalOn: anObject [
	object := anObject.
	^self signal
]

