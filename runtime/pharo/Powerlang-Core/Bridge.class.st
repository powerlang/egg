"
I am the one in charge of 'discovering' well known objects in
the remote image, giving my clients handles to them. For example,
the Smalltalk bridge allows to get a handle to the remote Smalltalk
object. Subclasses of SmalltalkBridge implement this functionality,
as it is runtime specific.

"
Class {
	#name : 'Bridge',
	#superclass : 'Object',
	#instVars : [
		'cache',
		'objects',
		'runtime'
	],
	#category : 'Powerlang-Core-Metaphysics',
	#package : 'Powerlang-Core',
	#tag : 'Metaphysics'
}

{ #category : 'instance creation' }
Bridge class >> new [
	^self basicNew initialize
]

{ #category : 'initialization' }
Bridge >> findObjectNamed: aSymbol [
	^self subclassResponsibility
]

{ #category : 'initialization' }
Bridge >> initialize [
	cache := IdentityDictionary new.
	objects := Dictionary new
]

{ #category : 'initialization' }
Bridge >> mirrorOn: address [
	^(runtime handleOn: address) mirror
]

{ #category : 'initialization' }
Bridge >> name: object as: name [
	^objects at: name put: object
]

{ #category : 'initialization' }
Bridge >> objectNamed: aSymbol [
	^ objects at: aSymbol ifAbsentPut: [ self findObjectNamed: aSymbol ]
]

{ #category : 'initialization' }
Bridge >> objectNamed: aSymbol ifAbsent: aBlock [
	^ objects at: aSymbol ifAbsent: aBlock
]

{ #category : 'initialization' }
Bridge >> runtime: aRuntime [
	runtime := aRuntime
]
