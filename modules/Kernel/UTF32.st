"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #UTF32,
	#superclass : #Unicode,
	#category : #Kernel
}

{ #category : #accessing }
UTF32 class >> prefix [
	^#[16rFE 16rFF 0 0]
]

{ #category : #'encoding / decoding' }
UTF32 >> decode: aByteArray [
	^WideString newFrom: aByteArray
]

{ #category : #'encoding / decoding' }
UTF32 >> encode: aCharacter on: aStream [
	aStream nextULongPut: aCharacter codePoint
]

