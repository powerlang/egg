"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CallbackBehavior,
	#superclass : #Behavior,
	#instVars : [
		'nativeCode'
	],
	#category : #Kernel
}

{ #category : #accessing }
CallbackBehavior >> nativeCode [
	^nativeCode
]

{ #category : #accessing }
CallbackBehavior >> nativeCode: aNativeCode [
	nativeCode := aNativeCode
]


