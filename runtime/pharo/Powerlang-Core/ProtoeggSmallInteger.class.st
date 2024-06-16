Class {
	#name : #ProtoeggSmallInteger,
	#superclass : #ProtoeggObject,
	#instVars : [
		'value'
	],
	#category : 'Powerlang-Core-Execution-Bootstrap'
}

{ #category : #'instance creation' }
ProtoeggSmallInteger class >> new: anRGBehavior valued: anInteger [
	^self new initializeAs: anRGBehavior valued: anInteger
]

{ #category : #comparing }
ProtoeggSmallInteger >> = anObject [
	anObject class == self class
		ifFalse: [ ^ false ].
	^ value = anObject value
]

{ #category : #accessing }
ProtoeggSmallInteger >> at: index [
	self errorNotIndexable
]

{ #category : #accessing }
ProtoeggSmallInteger >> at: index put: anObject [
	self errorNotIndexable
]

{ #category : #comparing }
ProtoeggSmallInteger >> hash [
	^ value hash
]

{ #category : #initialization }
ProtoeggSmallInteger >> initializeAs: anRGBehavior sized: size [
	self shouldNotImplement
]

{ #category : #initialization }
ProtoeggSmallInteger >> initializeAs: anRGBehavior valued: anInteger [
	self assert: anRGBehavior name == #SmallInteger.
	self assert: anInteger isInteger.
	spec := anRGBehavior.
	value := anInteger
]

{ #category : #testing }
ProtoeggSmallInteger >> isImmediate [
	^ true
]

{ #category : #printing }
ProtoeggSmallInteger >> printOn: aStream [
	aStream
		nextPutAll: '<<';
		nextPutAll: value printString;
		nextPutAll: '>>'
]

{ #category : #accessing }
ProtoeggSmallInteger >> size [ 
	^ 0
]

{ #category : #accessing }
ProtoeggSmallInteger >> slotAt: index [
	self errorNotIndexable
]

{ #category : #accessing }
ProtoeggSmallInteger >> slotAt: index put: anObject [
	self errorNotIndexable
]

{ #category : #validation }
ProtoeggSmallInteger >> validate [ 
	super validate.
	self assert: value isSmallInteger 
]

{ #category : #accessing }
ProtoeggSmallInteger >> value [
	^value
]

{ #category : #accessing }
ProtoeggSmallInteger >> value: aSmallInteger [
	value := aSmallInteger
]
