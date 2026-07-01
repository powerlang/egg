'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #GlobalDispatchCache category: #Kernel!
Object subclass: #GlobalDispatchCache
	instanceVariableNames: 'contents'
	classVariableNames: 'Current GlobalLookupCount'
	poolDictionaries: ''
	category: 'Kernel'!
!GlobalDispatchCache commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: selector for: aBehavior
	| index |
	index := self indexOf: selector with: aBehavior.
	^self lookup: selector for: aBehavior startingAt: index
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: aSymbol for: aBehavior put: aCompiledMethod
	| index |
	index := self indexOf: aSymbol with: aBehavior.
	^self startingAt: index for: aBehavior put: aCompiledMethod
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicFlush: selector for: aBehavior
	| index |
	index := self indexOf: selector with: aBehavior.
	self flush: selector for: aBehavior startingAt: index
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicFlush: selector forSpecies: aSpecies
	"
	We avoid sending messages to aSpecies because it would 
	create a huge PIC. Instead we use undermessages.
	"
	| behavior subclasses |
	behavior := aSpecies _basicAt: 2.
	self basicFlush: selector for: behavior.
	subclasses := self subclassesOf: aSpecies.
	subclasses == nil ifFalse: [
		1 to: subclasses size do: [:i | | subclass |
			subclass := subclasses at: i.
			subclass == nil ifFalse: [self basicFlush: selector forSpecies: subclass]]]
! !

!GlobalDispatchCache methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
flush
	1 to: contents _size do: [:i | contents _basicAt: i put: nil]
! !

!GlobalDispatchCache methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
flush: selector for: aBehavior startingAt: position
	contents
		_basicAt: position put: nil;
		_basicAt: position + 2 put: nil;
		_basicAt: position + 4 put: nil;
		_basicAt: position + 6 put: nil;
		_basicAt: position + 8 put: nil;
		_basicAt: position + 10 put: nil;
		_basicAt: position + 12 put: nil;
		_basicAt: position + 14 put: nil
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
flush: selector forSpecies: aSpecies
	"
	We avoid sending messages to aSpecies because it would 
	create a huge PIC. Instead we use undermessages.
	"
	(Object == aSpecies or: [ProtoObject == aSpecies or: [aSpecies == nil]])
		ifTrue: [^self flushAll: selector].
	self basicFlush: selector forSpecies: aSpecies
! !

!GlobalDispatchCache methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
flushAll: aSymbol
	1 to: contents _size by: 2 do: [:i | | method selector |
		method := contents _basicAt: i.
		method == nil ifFalse: [
			selector := method _basicAt: 4.
			selector == aSymbol ifTrue: [contents _basicAt: i put: nil]]]
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOf: selector with: behavior
	"
	we always return odd values so that the table has
	 the next (even) index to store the cached value
	"
	| hash |
	hash := (selector _basicHash bitXor: behavior _basicHash) bitAnd: 16rFFFF.
	^hash + hash + 1
! !

!GlobalDispatchCache methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	contents := Array new: 16r20000 + (8 * 2)
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookup: selector for: aBehavior startingAt: position
	| index |
	index := position.
	8 timesRepeat: [| method protocol |
		method := contents _basicAt: index.
		method == nil ifTrue: [^nil].
		protocol := contents _basicAt: index + 1.
		(protocol == aBehavior and: [method selector == selector]) ifTrue: [
			method hasBeenFlushed
				ifTrue: [
					contents
						_basicAt: index + 1 put: nil;
						_basicAt: index put: nil]
				ifFalse: [^method]].
		index := index + 2].
	^nil
! !

!GlobalDispatchCache methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupAndCache: aSymbol in: aBehavior
	| method |
	aBehavior hasInstanceBehavior
		ifTrue: [^self _lookup: aSymbol in: aBehavior].
	method := self at: aSymbol for: aBehavior.
	method == nil ifTrue: [
		GlobalLookupCount := GlobalLookupCount + 1.
		method := self _lookup: aSymbol in: aBehavior.
		self at: aSymbol for: aBehavior put: method].
	^method
! !

!GlobalDispatchCache methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
startingAt: position for: aBehavior put: aCompiledMethod
	| index |
	index := position.
	8 timesRepeat: [| method |
		method := contents _basicAt: index.
		method == nil ifTrue: [
			contents objectAtValid: index put: aCompiledMethod.
			^contents objectAtValid: index + 1 put: aBehavior].
		index := index + 2].
	contents
		objectAtValid: position put: aCompiledMethod;
		objectAtValid: position + 1 put: aBehavior;
		_basicAt: position + 2 put: nil;
		_basicAt: position + 4 put: nil;
		_basicAt: position + 6 put: nil;
		_basicAt: position + 8 put: nil;
		_basicAt: position + 10 put: nil;
		_basicAt: position + 12 put: nil;
		_basicAt: position + 14 put: nil
! !

!GlobalDispatchCache methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
subclassesOf: aSpecies
	"
	Optimized to avoid megamorphic sends
	"
	| metaclass subclasses class |
	metaclass := aSpecies _size = 6.
	^metaclass
		ifTrue: [
			class := aSpecies _basicAt: 6.
			subclasses := class _basicAt: 7.
			subclasses == nil ifFalse: [subclasses collect: [:c | c class]]]
		ifFalse: [aSpecies _basicAt: 7]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'GlobalDispatchCache class' category: #Kernel!
GlobalDispatchCache class
	instanceVariableNames: 'Current GlobalLookupCount'!

!GlobalDispatchCache class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
current
	^Thread currentGlobalLookup ifNil: [Current]
! !

!GlobalDispatchCache class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
current: aCache
	Current := aCache
! !

!GlobalDispatchCache class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
globalLookupCount
	^GlobalLookupCount
! !


GlobalDispatchCache initialize!

