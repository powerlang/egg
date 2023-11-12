Class {
	#name : #Buffer,
	#superclass : #Object,
	#instVars : [
		'pointer',
		'size'
	],
	#category : #'SqueakNOS-External-Structures'
}

{ #category : #'as yet unclassified' }
Buffer >> address [
	^pointer address.

]

{ #category : #'as yet unclassified' }
Buffer >> allocateSpace [
	pointer := Alien newC: size.
]

{ #category : #'methodsFor:' }
Buffer >> at: anAddress size: aNumberOfBytes [
	pointer := Alien forPointer: anAddress.
	size := aNumberOfBytes.
]

{ #category : #'as yet unclassified' }
Buffer >> basicSize [
	^size.

]

{ #category : #'as yet unclassified' }
Buffer >> contents [
	| result | 
	result := ByteArray new: size.
	pointer copyInto: result from: 1 to: size in: pointer startingAt: 1.
	^result.

]

{ #category : #'as yet unclassified' }
Buffer >> contents: aByteArray [
	pointer replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.

]

{ #category : #'as yet unclassified' }
Buffer >> size [
	^size.

]

{ #category : #'methodsFor:' }
Buffer >> size: aSize [
	^size := aSize.

]
