"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Magnitude,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #comparing }
Magnitude >> < aMagnitude [
	self subclassResponsibility
]

{ #category : #comparing }
Magnitude >> <= aMagnitude [
	self subclassResponsibility
]

{ #category : #comparing }
Magnitude >> = aMagnitude [
	self subclassResponsibility
]

{ #category : #comparing }
Magnitude >> > aMagnitude [
	^aMagnitude < self
]

{ #category : #comparing }
Magnitude >> >= aMagnitude [
	^aMagnitude <= self
]

{ #category : #arithmetic }
Magnitude >> addTo: aMagnitude [
	^aMagnitude + self asFloat
]

{ #category : #comparing }
Magnitude >> between: min and: max [
	^min <= self and: [self <= max]
]

{ #category : #comparing }
Magnitude >> hash [
	^self subclassResponsibility
]

{ #category : #comparing }
Magnitude >> max: aMagnitude [
	^self > aMagnitude ifTrue: [self] ifFalse: [aMagnitude]
]

{ #category : #comparing }
Magnitude >> min: aMagnitude [
	^self < aMagnitude ifTrue: [self] ifFalse: [aMagnitude]
]

