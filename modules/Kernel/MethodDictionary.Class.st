'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #MethodDictionary category: #Kernel!
IdentityDictionary subclass: #MethodDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!MethodDictionary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MethodDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: aSymbol put: aCompiledMethod
	| current |
	current := self at: aSymbol ifAbsent: nil.
	(current notNil and: [current isNativized])
		ifTrue: [aCompiledMethod prepareForExecution].
	self at: aSymbol putWithoutFlushing: aCompiledMethod.
	aSymbol flushCacheFor: self classBinding.
	^aCompiledMethod
! !

!MethodDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: aSymbol putWithoutFlushing: aCompiledMethod
	aCompiledMethod canBeInstalled
		ifTrue: [self basicAt: aSymbol put: aCompiledMethod]
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: aSymbol put: aCompiledMethod
	[
		(table atKey: aSymbol put: aCompiledMethod) == nil
			ifTrue: [self incrementTally]] evaluateAtomically.
	^aCompiledMethod
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicRemoveKey: aSymbol ifAbsent: aBlock
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
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
classBinding
	^self isEmpty ifFalse: [self anyone classBinding].
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
contentOfSize: anInteger
	| modulo |
	modulo := self moduloFor: anInteger.
	^(self bucketClass basicNew: modulo * 2) owner: self
! !

!MethodDictionary methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copy
	^self objectShallowCopy postCopy
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
flushCache
	| class | 
	class := self classBinding.
	self keysDo: [:selector | selector flushCacheFor: class]
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: object
	^object basicHash
! !

!MethodDictionary methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMethodDictionary
	^true
! !

!MethodDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
moduloFor: size
	| last powers |
	powers := #(4 8 16 32 64 128 256 512 1024 2048 4096).
	powers do: [:number | size < number ifTrue: [^number]].
	last := powers last.
	[size < last] whileFalse: [last := last * 2].
	^last
! !

!MethodDictionary methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	table := table copy owner: self
! !

!MethodDictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: aSymbol ifAbsent: aBlock
	^Kernel removeKey: aSymbol from: self ifAbsent: aBlock
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MethodDictionary class' category: #Kernel!
MethodDictionary class
	instanceVariableNames: ''!

!MethodDictionary class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultSize
	^4
! !

!MethodDictionary class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reserveSlot
	self allInstances do: [:md | | selector cm |
		selector := md contents at: 1.
		cm := md contents at: 2.
		selector notNil ifTrue: [md removeKey: selector].
		md contents at: 1 put: 0.
		md incrementTally.
		selector notNil ifTrue: [md at: selector put: cm]]
! !


