"
	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"

Class {
	#name : #TypeAdaptor,
	#superclass : #DataAdaptor,
	#instVars : [
		'classes'
	],
	#category : #JSON
}

{ #category : #'instance creation' }
TypeAdaptor class >> of: class [
	^self new classes: {class}]

{ #category : #'instance creation' }
TypeAdaptor class >> restrictedTo: classes [
	^self new classes: classes
]

{ #category : #accessing }
TypeAdaptor >> classes: aCollection [
	classes := aCollection asDictionaryUsing: #name
]

{ #category : #services }
TypeAdaptor >> dataFrom: aClass [
	^(classes includes: aClass) ifTrue: [aClass name]
]

{ #category : #services }
TypeAdaptor >> objectClasses [
	^classes
]

{ #category : #services }
TypeAdaptor >> objectFrom: aString [
	^classes at: aString ifAbsent: nil
]

