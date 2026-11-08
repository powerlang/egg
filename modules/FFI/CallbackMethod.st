"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CallbackMethod,
	#superclass : #CompiledMethod,
	#type : #variable,
	#instVars : [
		'receiver',
		'descriptor'
	],
	#category : #FFI
}


{ #category : #accessing }
CallbackMethod >> descriptor [
	^descriptor
]

{ #category : #accessing }
CallbackMethod >> descriptor: anFFIDescriptor [
	descriptor := anFFIDescriptor
]

{ #category : #testing }
CallbackMethod >> hasFrame [
	^true
]

{ #category : #accessing }
CallbackMethod >> isCallback [
	^true
]

{ #category : #accessing }
CallbackMethod >> receiver [
	^receiver
]

{ #category : #accessing }
CallbackMethod >> receiver: anObject [
	receiver := anObject
]

{ #category : #callbacks }
CallbackMethod >> argumentsAt: buffer offsets: anArray [
	| types last bytes |
	types := descriptor argumentTypeNames.
	last := anArray inject: 0 into: [:max :offset | max max: offset].
	bytes := ByteArray new: last + WordSize.
	bytes _replaceFrom: 1 to: bytes size // WordSize with: buffer _asObject.
	^anArray withIndexCollect: [:offset :i | | type |
		type := types at: i.
		descriptor valueOf: type at: offset in: bytes]
]

{ #category : #callbacks }
CallbackMethod >> store: anObject at: buffer [
	| value bytes |
	value := descriptor returnTypeName == #double ifTrue: [anObject asFloat] ifFalse: [anObject].
	bytes := descriptor marshalArguments: {value}.
	buffer _asObject _replaceFrom: 1 to: 1 with: bytes
]
