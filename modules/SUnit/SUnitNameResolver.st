"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #SUnitNameResolver,
	#superclass : #Object,
	#category : #SUnit
}

{ #category : #unclassified }
SUnitNameResolver class >> classNamed: aSymbol [
	^Smalltalk
		at: aSymbol
		ifAbsent: [nil]
]

{ #category : #unclassified }
SUnitNameResolver class >> defaultLogDevice [
	^Transcript
]

{ #category : #unclassified }
SUnitNameResolver class >> errorObject [
	^Error
]

{ #category : #unclassified }
SUnitNameResolver class >> mnuExceptionObject [
	^MessageNotUnderstood
]

{ #category : #unclassified }
SUnitNameResolver class >> notificationObject [
	^Notification
]

