"
    Copyright (c) 2022-2023, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #Writer,
	#superclass : #Object,
	#instVars : [
		'stream',
		'objects',
		'mapping',
		'imports',
		'exports',
		'closure'
	],
	#category : #'Writer'
}

{ #category : #accessing }
Writer >> closure: anObjectClosure [
	closure := anObjectClosure
]

{ #category : #accessing }
Writer >> objects: aCollection [
	objects := aCollection
]

{ #category : #accessing }
Writer >> mapping: aDictionary [
	mapping := aDictionary
]

{ #category : #accessing }
Writer >> imports: anIdentityDictionary [
	imports := anIdentityDictionary
]

{ #category : #accessing }
Writer >> exports: aDictionary [
	exports := aDictionary
]

{ #category : #accessing }
Writer >> image [
	^stream contents
]

{ #category : #initializing }
Writer >> initialize [
	stream := '' writeStream.
]

{ #category : #accessing }
Writer >> stream: aWriteStream [
	stream := aWriteStream
]

{ #category : #services }
Writer >> write [
	self subclassResponsibility
]


{ #category : #writing }
Writer >> writeTo: aStream [
	self stream: aStream; write.
]

{ #category : #writing }
Writer >> writeToFile: filename [
	filename binaryWriteStreamDo: [ :s | self writeTo: byteStream ]
]

