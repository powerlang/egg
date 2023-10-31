"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MethodDictionary,
	#superclass : #IdentityDictionary,
	#category : #Kernel
}

{ #category : #constants }
MethodDictionary class >> defaultSize [
	^4
]

{ #category : #private }
MethodDictionary class >> reserveSlot [
	self allInstances do: [:md | | selector cm |
		selector := md contents at: 1.
		cm := md contents at: 2.
		selector notNil ifTrue: [md removeKey: selector].
		md contents at: 1 put: 0.
		md incrementTally.
		selector notNil ifTrue: [md at: selector put: cm]]
]

{ #category : #accessing }
MethodDictionary >> at: aSymbol put: aCompiledMethod [
	| current |
	current := self at: aSymbol ifAbsent: nil.
	(current notNil and: [current isNativized])
		ifTrue: [aCompiledMethod prepareForExecution].
	self at: aSymbol putWithoutFlushing: aCompiledMethod.
	aSymbol flushCacheFor: self classBinding.
	^aCompiledMethod
]

{ #category : #accessing }
MethodDictionary >> at: aSymbol putWithoutFlushing: aCompiledMethod [
	aCompiledMethod canBeInstalled
		ifTrue: [self basicAt: aSymbol put: aCompiledMethod]
]

{ #category : #private }
MethodDictionary >> basicAt: aSymbol put: aCompiledMethod [
	[
		(table atKey: aSymbol put: aCompiledMethod) == nil
			ifTrue: [self incrementTally]] evaluateAtomically.
	^aCompiledMethod
]

{ #category : #private }
MethodDictionary >> basicRemoveKey: aSymbol ifAbsent: aBlock [
	| copy |
	(self includesKey: aSymbol) ifFalse: [^aBlock value].
	copy := MethodDictionary new.
	self keysAndValuesDo: [:selector :cm | 
		selector == aSymbol
			ifTrue: [cm flushFromCaches]
			ifFalse: [copy basicAt: selector put: cm]].
	[
		table := copy contents owner: self.
		tally := copy size] evaluateAtomically.
	^aSymbol
]

{ #category : #private }
MethodDictionary >> classBinding [
	^self isEmpty ifFalse: [self anyone classBinding].
]
	
{ #category : #private }
MethodDictionary >> contentOfSize: anInteger [
	| modulo |
	modulo := self moduloFor: anInteger.
	^(self bucketClass basicNew: modulo * 2) owner: self
]

{ #category : #copying }
MethodDictionary >> copy [
	^self objectShallowCopy postCopy
]

{ #category : #private }
MethodDictionary >> flushCache [
	| class | 
	class := self classBinding.
	self keysDo: [:selector | selector flushCacheFor: class]
]

{ #category : #private }
MethodDictionary >> hashFor: object [
	^object basicHash
]

{ #category : #testing }
MethodDictionary >> isMethodDictionary [
	^true
]

{ #category : #private }
MethodDictionary >> moduloFor: size [
	| last powers |
	powers := #(4 8 16 32 64 128 256 512 1024 2048 4096).
	powers do: [:number | size < number ifTrue: [^number]].
	last := powers last.
	[size < last] whileFalse: [last := last * 2].
	^last
]

{ #category : #copying }
MethodDictionary >> postCopy [
	table := table copy owner: self
]

{ #category : #removing }
MethodDictionary >> removeKey: aSymbol ifAbsent: aBlock [
	^Kernel removeKey: aSymbol from: self ifAbsent: aBlock
]

