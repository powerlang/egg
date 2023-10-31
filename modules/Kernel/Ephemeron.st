"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Ephemeron,
	#superclass : #Association,
	#instVars : [
		'key',
		'value',
		'registry'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Ephemeron class >> key: anObject [
	^self new key: anObject
]

{ #category : #'instance creation' }
Ephemeron class >> key: anObject value: aDictionary [
	^self new key: anObject value: aDictionary
]

{ #category : #comparing }
Ephemeron >> = anEphemeron [
	^anEphemeron class == self class and: [key = anEphemeron key]
]

{ #category : #initialization }
Ephemeron >> activate [
	self _beSpecial
]

{ #category : #initialization }
Ephemeron >> deactivate [
	self _beNotSpecial
]

{ #category : #comparing }
Ephemeron >> hash [
	^key hash
]

{ #category : #initialization }
Ephemeron >> initialize [
	super initialize.
	self activate
]

{ #category : #accessing }
Ephemeron >> key [
	^key
]

{ #category : #accessing }
Ephemeron >> key: anObject [
	key := anObject
]

{ #category : #accessing }
Ephemeron >> key: anObject value: aDictionary [
	key := anObject.
	value := aDictionary
]

{ #category : #printing }
Ephemeron >> printOn: aStream [
	aStream
		print: key;
		nextPutAll: ' → ';
		print: value
]

{ #category : #accessing }
Ephemeron >> registry [
	^registry
]

{ #category : #accessing }
Ephemeron >> registry: weakRegistry [
	registry := weakRegistry
]

{ #category : #private }
Ephemeron >> rescue [
	registry isNil ifFalse: [registry rescue: self]
]

{ #category : #accessing }
Ephemeron >> value [
	^value
]

{ #category : #accessing }
Ephemeron >> value: aDictionary [
	value := aDictionary
]

