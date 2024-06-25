"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #GlobalDispatchCache,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#classVars : [
		'Shared',
		'GlobalLookupCount'
	],
	#category : #Kernel
}

{ #category : #accessing }
GlobalDispatchCache class >> current [
	| current |
	current := Thread currentGlobalLookup.
	^current == nil ifTrue: [Shared]
]

{ #category : #initializing }
GlobalDispatchCache class >> initialize [
	GlobalLookupCount := 0.
	Shared := self new
]

{ #category : #accessing }
GlobalDispatchCache class >> globalLookupCount [
	^GlobalLookupCount
]

{ #category : #accessing }
GlobalDispatchCache >> at: selector for: protocol [
	| index |
	index := self indexOf: selector with: protocol.
	^self lookup: selector for: protocol startingAt: index
]

{ #category : #accessing }
GlobalDispatchCache >> at: selector for: protocol put: aCompiledMethod [
	| index |
	index := self indexOf: selector with: protocol.
	^self startingAt: index for: protocol put: aCompiledMethod
]

{ #category : #accessing }
GlobalDispatchCache >> flush: selector for: protocol [
	| index |
	index := self indexOf: selector with: protocol.
	^self flush: selector for: protocol startingAt: index
]

{ #category : #services }
GlobalDispatchCache >> flush: selector for: aProtocol startingAt: position [
	contents
		_basicAt: position put: nil;
		_basicAt: position + 2 put: nil;
		_basicAt: position + 4 put: nil;
		_basicAt: position + 6 put: nil;
		_basicAt: position + 8 put: nil;
		_basicAt: position + 10 put: nil;
		_basicAt: position + 12 put: nil;
		_basicAt: position + 14 put: nil
]

{ #category : #accessing }
GlobalDispatchCache >> flush: selector forSpecies: aSpecies [
	| index |
	(aSpecies == Object or: [aSpecies == ProtoObject or: [aSpecies == nil]])
		ifTrue: [^self flushAll: selector].
	aSpecies withAllSubclassesDo: [:species | 
		index := self indexOf: selector with: species instanceBehavior.
		self flush: selector for: species instanceBehavior startingAt: index]
]

{ #category : #services }
GlobalDispatchCache >> flushAll: selector [
	1 to: contents _size by: 2 do: [:i | | method |
		method := contents _basicAt: i.
		(method != nil and: [method selector == selector])
			ifTrue: [contents _basicAt: i put: nil]]
]

{ #category : #accessing }
GlobalDispatchCache >> indexOf: selector with: behavior [
	"
	we always return odd values so that the table has
	 the next (even) index to store the cached value
	"
	| hash |
	hash := (selector _basicHash bitXor: behavior _basicHash) bitAnd: 16rFFFF.
	^hash + hash + 1
]

{ #category : #initialization }
GlobalDispatchCache >> initialize [
	contents := Array new: 16r20000 + (8 * 2)
]

{ #category : #accessing }
GlobalDispatchCache >> lookup: selector for: aProtocol startingAt: position [
	| index |
	index := position.
	8 timesRepeat: [| method protocol |
		method := contents _basicAt: index.
		method == nil ifTrue: [^nil].
		protocol := contents _basicAt: index + 1.
		(protocol == aProtocol and: [method selector == selector]) ifTrue: [^method].
		index := index + 2].
	^nil
]

{ #category : #services }
GlobalDispatchCache >> lookupAndCache: selector in: aProtocol [
	| method |
	method := self at: selector for: aProtocol.
	method == nil ifTrue: [
		GlobalLookupCount := GlobalLookupCount + 1.
		method := self _lookup: selector in: aProtocol.
		self at: selector for: aProtocol put: method].
	^method
]

{ #category : #services }
GlobalDispatchCache >> startingAt: position for: aProtocol put: aCompiledMethod [
	| index |
	index := position.
	8 timesRepeat: [| method |
		method := contents _basicAt: index.
		method == nil ifTrue: [
			contents objectAtValid: index put: aCompiledMethod.
			^contents objectAtValid: index + 1 put: aProtocol].
		index := index + 2].
	contents
		objectAtValid: position put: aCompiledMethod;
		objectAtValid: position + 1 put: aProtocol;
		_basicAt: position + 2 put: nil;
		_basicAt: position + 4 put: nil;
		_basicAt: position + 6 put: nil;
		_basicAt: position + 8 put: nil;
		_basicAt: position + 10 put: nil;
		_basicAt: position + 12 put: nil;
		_basicAt: position + 14 put: nil
]

