"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #WriteStringStream,
	#superclass : #InternalWriteStream,
	#category : #Kernel
}

{ #category : #configuration }
WriteStringStream >> beWide [
	super beWide.
	limit := contents size

]

{ #category : #writing }
WriteStringStream >> nextPut: aCharacter [
	aCharacter isByteCharacter ifTrue: [^super nextPut: aCharacter].
	self beWide.
	^super nextPut: aCharacter
]

{ #category : #writing }
WriteStringStream >> nextPutAll: aString [
	aString isString ifFalse: [^super nextPutAll: aString].
	contents isWideString = aString isWideString
		ifTrue: [^super nextPutAll: aString].
	contents isWideString ifTrue: [^super nextPutAll: aString asWideString].
	self beWide.
	^super nextPutAll: aString
]

