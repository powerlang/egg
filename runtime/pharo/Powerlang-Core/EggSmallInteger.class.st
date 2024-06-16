Class {
	#name : #EggSmallInteger,
	#superclass : #EggObject,
	#instVars : [
		'value'
	],
	#category : 'Powerlang-Core-Execution-Metacircular'
}

{ #category : #comparing }
EggSmallInteger >> = anObject [
	anObject class == self class
		ifFalse: [ ^ false ].
	^ value = anObject value
]

{ #category : #accessing }
EggSmallInteger >> hash [
	^value hash
]

{ #category : #accessing }
EggSmallInteger >> isImmediate [
	^true
]

{ #category : #accessing }
EggSmallInteger >> printOn: aStream [
	aStream
		nextPut: $<;
		print: value;
		nextPut: $>
]

{ #category : #accessing }
EggSmallInteger >> value [
	^value
]

{ #category : #accessing }
EggSmallInteger >> value: anInteger [
	value := anInteger
]
