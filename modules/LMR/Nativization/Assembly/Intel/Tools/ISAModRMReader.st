"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"
Class {
	#name : #ISAModRMReader,
	#superclass : #ISAInstructionPartReader,
	#category : #'Powerlang-Core-Assembly-Intel-Tools'
}

{ #category : #accessing }
ISAModRMReader >> contents [
	^contents
]

{ #category : #private }
ISAModRMReader >> from: aStream [
	contents := aStream atEnd ifFalse: [ModRM new on: aStream next]
]
