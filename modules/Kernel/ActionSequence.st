"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ActionSequence,
	#superclass : #Array,
	#type : #variable,
	#category : #Kernel
}

{ #category : #operations }
ActionSequence >> & anActionSequence [
	^anActionSequence notNil ifTrue: [self , anActionSequence] ifFalse: [self]
]

{ #category : #operations }
ActionSequence >> && anObject [
	^anObject notNil ifTrue: [self copyWith: anObject]
]

{ #category : #converting }
ActionSequence >> asActionSequence [
	^self
]

{ #category : #converting }
ActionSequence >> asArray [
	| array |
	array := Array new: self size.
	self withIndexDo: [:ai :i | array at: i put: ai].
	^array
]

{ #category : #accessing }
ActionSequence >> compressed [
	^self isEmpty ifFalse: [self size = 1 ifTrue: [self first] ifFalse: [self]]
]

{ #category : #evaluating }
ActionSequence >> evaluate [
	| value |
	self do: [:action | value := action evaluate].
	^value
]

{ #category : #evaluating }
ActionSequence >> evaluateWithArguments: anArray [
	| value |
	self do: [:action | value := action evaluateWithArguments: anArray].
	^value
]

{ #category : #printing }
ActionSequence >> printOn: aStream [
	aStream nextPutAll: self class name; space.
	super printOn: aStream
]

