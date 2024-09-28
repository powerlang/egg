"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CallbackMethod,
	#superclass : #CompiledMethod,
	#type : #variable,
	#instVars : [
		'receiver',
		'descriptor'
	],
	#category : #Kernel
}


{ #category : #accessing }
CallbackMethod >> descriptor [
	^descriptor
]

{ #category : #accessing }
CallbackMethod >> descriptor: anFFIDescriptor [
	descriptor := anFFIDescriptor
]

{ #category : #accessing }
CallbackMethod >> isCallback [
	^true
]

{ #category : #accessing }
CallbackMethod >> receiver [
	^receiver
]

{ #category : #accessing }
CallbackMethod >> receiver: anObject [
	receiver := anObject
]

