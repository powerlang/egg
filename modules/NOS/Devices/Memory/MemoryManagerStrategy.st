Class {
	#name : #MemoryManagerStrategy,
	#superclass : #Object,
	#instVars : [
		'memory',
		'processor'
	],
	#category : 'SqueakNOS-Memory-Manager'
}

{ #category : #'instance creation' }
MemoryManagerStrategy class >> forMemory: aMemory [
	^self new memory: aMemory; identityMapping 
]

{ #category : #'instance creation' }
MemoryManagerStrategy class >> forMemory: aMemory using: aProcessor [
	^self new memory: aMemory; processor: aProcessor; identityMapping 
]

{ #category : #accesing }
MemoryManagerStrategy >> memory [
	^memory
]

{ #category : #accesing }
MemoryManagerStrategy >> memory: aMemory [
	memory  := aMemory
]

{ #category : #accesing }
MemoryManagerStrategy >> processor [
	^processor
]

{ #category : #accesing }
MemoryManagerStrategy >> processor: aProcessor [
	processor := aProcessor.
]
