Class {
	#name : 'ProtoeggSymbol',
	#superclass : 'ProtoeggByteObject',
	#instVars : [
		'symbol'
	],
	#category : 'Powerlang-Core-Execution-Bootstrap',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Bootstrap'
}

{ #category : 'instance creation' }
ProtoeggSymbol class >> new: anRGBehavior symbol: aSymbol [
	| bytes |
	bytes := aSymbol copyWith: Character null.
	^ self new
		initializeAs: anRGBehavior sized: bytes size;
		fillFrom: bytes;
		symbol: aSymbol
]

{ #category : 'accessing' }
ProtoeggSymbol >> asString [
	^ symbol
]

{ #category : 'accessing' }
ProtoeggSymbol >> contentsString [
	^symbol storeString

]

{ #category : 'accessing' }
ProtoeggSymbol >> symbol [
	^symbol
]

{ #category : 'accessing' }
ProtoeggSymbol >> symbol: aSymbol [
	symbol := aSymbol 
]
