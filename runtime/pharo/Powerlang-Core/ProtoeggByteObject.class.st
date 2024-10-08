Class {
	#name : 'ProtoeggByteObject',
	#superclass : 'ProtoeggObject',
	#instVars : [
		'bytes',
		'hash'
	],
	#category : 'Powerlang-Core-Execution-Bootstrap',
	#package : 'Powerlang-Core',
	#tag : 'Execution-Bootstrap'
}

{ #category : 'instance creation' }
ProtoeggByteObject class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : 'instance creation' }
ProtoeggByteObject class >> new: anRGBehavior size: anInteger [

	^ self new
		initializeAs: anRGBehavior sized: anInteger
]

{ #category : 'instance creation' }
ProtoeggByteObject class >> new: anRGBehavior valued: bytes [
	"self assert: anRGBehavior isBytes."
	^self new initializeAs: anRGBehavior sized: bytes size; fillFrom: bytes
]

{ #category : 'testing' }
ProtoeggByteObject >> asString [
	| string |
	string := bytes allButLast asString.
	^spec name = #String ifTrue: [ string ] ifFalse: [ string asSymbol ]
]

{ #category : 'accessing' }
ProtoeggByteObject >> at: index [
	"Return indexed value at given index, starting with 1. This CANNOT be 
	 used for accessing named slots (aka, instance variables), to access 
	 them use #instVarAt:"
	
	self assert: (index between: 1 and: bytes size).
	^bytes at: index
]

{ #category : 'accessing' }
ProtoeggByteObject >> at: index put: anObjectMap [
	"Set indexed value at given `index` to `value`. This CANNOT be used for 
	 setting named slots (aka, instance variables), to access them use 
	 #instVarAt:put:"

	| value |
	self assert: (index between: 1 and: bytes size).
	self assert: anObjectMap isImmediate.
	value := anObjectMap value.
	self assert: (value between: 0 and: 255).
	bytes at: index put: value.
	^anObjectMap
]

{ #category : 'accessing' }
ProtoeggByteObject >> bodySizeInBytes [
	"Return the size of object body(s) in bytes, padded"
	^ self size alignedTo: self wordSize
]

{ #category : 'testing' }
ProtoeggByteObject >> bytes [
	^ bytes
]

{ #category : 'testing' }
ProtoeggByteObject >> contentsString [
		spec name == #String
		ifTrue: [ ^bytes allButLast asString storeString ].
		spec name == #Symbol
				ifTrue: [ ^bytes allButLast asString asSymbol storeString ].
		spec name == #ByteArray
			ifTrue: [ ^bytes storeString ].
		^spec name withArticle, ': ', bytes printString
]

{ #category : 'accessing' }
ProtoeggByteObject >> fillFrom: anObject [
	self assert: anObject size == bytes size.
	bytes replaceFrom: 1 to: bytes size with: anObject startingAt: 1
]

{ #category : 'testing' }
ProtoeggByteObject >> headerFlags [
	| byte variable small |
	byte := 1.
	variable := 2.
	small := self isSmall ifTrue: [ 16r80 ] ifFalse: [ 0 ].
	^ byte | variable | small
]

{ #category : 'testing' }
ProtoeggByteObject >> headerHash [
	^ hash
]

{ #category : 'testing' }
ProtoeggByteObject >> headerHash: anInteger [
	hash := anInteger
]

{ #category : 'initialization' }
ProtoeggByteObject >> initialize [
	hash := 0
]

{ #category : 'initialization' }
ProtoeggByteObject >> initializeAs: anRGBehavior sized: size [
	self assert: anRGBehavior notNil.
"	self assert: anRGBehavior isBytes.
	self assert: anRGBehavior isVariable.
"	
	spec := anRGBehavior.
	bytes := ByteArray new: size
]

{ #category : 'testing' }
ProtoeggByteObject >> isBytes [
	^true
]

{ #category : 'testing' }
ProtoeggByteObject >> printOn: aStream [
	spec ifNil: [ ^ super printOn: aStream ].
	aStream
		nextPutAll: '<<';
		nextPutAll: self contentsString;
		nextPutAll: '>>'
]

{ #category : 'accessing' }
ProtoeggByteObject >> size [
	"Return the size if this object, that this, the value of
	 size field in object header. 
	
	 For slot (pointer) objects, this is a number of slots. 
	 For byte objects, this is a number of bytes. "
	
	^ bytes size
]
