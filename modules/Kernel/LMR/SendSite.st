"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #SendSite,
	#superclass : #DispatchSite,
	#instVars : [
	],
	#classVars : [
		'FormatFlags',
		'Instances',
		'Invoke',
		'LookupCount',
		'MICs',
		'MonomorphicStub',
		'NextMIC',
		'NextPIC',
		'PICs',
		'PolymorphicStub'
	],
	#category : #Kernel
}

{ #category : #initialization }
SendSite class >> allocateCaches: amount lookup: aNativeCode [
	| mics pics array |
	mics := amount.
	pics := amount // 4.
	array := Array new: mics.
	1 to: mics do: [:i | array basicAt: i put: (Array new: 2)].
	MICs := array.
	NextMIC := 1.
	array := Array new: pics.
	1 to: pics do: [:i | array basicAt: i put: (self newPICUsing: aNativeCode)].
	PICs := array.
	NextPIC := 1
]

{ #category : #initialization }
SendSite class >> allocateInitialCachesUsing: aNativeCode [
	self allocateCaches: 3000 lookup: aNativeCode
]

{ #category : #initialization }
SendSite class >> allocateMoreCaches [
	self beeAllocateCaches: 140000 lookup: (Smalltalk at: #Lookup)
]

{ #category : #initialization }
SendSite class >> beeAllocateCaches: amount lookup: aNativeCode [
	| mics pics array mic pic memory |
	mics := amount.
	pics := amount // 5.
	array := Array new: mics.
	mic := Array new: 2.
	pic := (Array new: 15)
		at: 15 put: aNativeCode;
		yourself.
	memory := Memory current.
	1 to: mics do: [:i | array basicAt: i put: (memory pinnedCopy: mic)].
	MICs := array.
	NextMIC := 1.
	array := Array new: pics.
	1 to: pics do: [:i | array basicAt: i put: (memory pinnedCopy: pic)].
	PICs := array.
	NextPIC := 1
]

{ #category : #private }
SendSite class >> flush [
	Instances := nil
]

{ #category : #initialization }
SendSite class >> flush: selector [
	| sends |
	sends := self instances at: selector ifAbsent: [^self].
	sends do: [:send | send flush: selector]
]

{ #category : #private }
SendSite class >> initializeFormatFlags [
	"
	SendSite initializeFormatFlags
	"
	FormatFlags := self addNamespace
		at: #IsStaticSend put: 16r1;
		at: #IsSuperSend put: 16r2;
		at: #IsPolymorphic put: 16r4;
		at: #HasBeenReset put: 16r8;
		yourself
]

{ #category : #initialization }
SendSite class >> instances [
	Instances ifNil: [
		Instances := IdentityDictionary new.
		self allExistingInstances do: [:send | send register]].
	^Instances
]

{ #category : #initialization }
SendSite class >> initializeInvoke: aNativeCode [
	Invoke := aNativeCode code
]

{ #category : #private }
SendSite class >> invoking: aCompiledMethod using: instructions [
	^self new beInvoke: aCompiledMethod using: instructions
]

{ #category : #accessing }
SendSite class >> lookupCount [
	^LookupCount
]

{ #category : #initialization }
SendSite class >> mics [
	^MICs
]

{ #category : #initialization }
SendSite class >> monomorphicCache: instructions [
	MonomorphicStub := instructions
]

{ #category : #initialization }
SendSite class >> newPICUsing: aNativeCode [
	| new |
	new := Array new: 15.
	new at: 15 put: aNativeCode.
	^new
]

{ #category : #initialization }
SendSite class >> polymorphicCache: instructions [
	PolymorphicStub := instructions
]

{ #category : #private }
SendSite class >> sending: aSelector with: instructions [
	^self new selector: aSelector; instructions: instructions
]

{ #category : #initialization }
SendSite class >> startUp [
	Instances := nil
]

{ #category : #'meta accessing' }
SendSite >> _dispatchDebuggableOn: anObject [
	| cm nativeCode invoked |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	invoked := ActiveProcess wantsToStepInto
		ifTrue: [cm debuggableCopy]
		ifFalse: [cm].
	invoked prepareForExecution.
	nativeCode := invoked nativeCode.
	"self when: anObject behavior use: nativeCode code."
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _dispatchDebuggableOn: anObject startingAt: aBehavior [
	| cm nativeCode invoked |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#aBehavior -> #regT.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector in: aBehavior.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	invoked := ActiveProcess wantsToStepInto
		ifTrue: [cm debuggableCopy]
		ifFalse: [cm].
	invoked prepareForExecution.
	nativeCode := invoked nativeCode.
	"self when: aBehavior use: nativeCode code."
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _dispatchOn: anObject [
	| cm nativeCode |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	cm prepareForExecution.
	nativeCode := cm nativeCode.
	self when: anObject behavior use: nativeCode.
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _dispatchOn: anObject startingAt: aBehavior [
	| cm nativeCode |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#aBehavior -> #regT.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: selector in: aBehavior.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: selector].
	cm prepareForExecution.
	nativeCode := cm nativeCode.
	self beInvoke: cm using: Invoke.
	^anObject _transferControlTo: nativeCode
]

{ #category : #'meta accessing' }
SendSite >> _invokeOn: anObject [
	#savePreviousSelf.
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	^anObject _transferControlTo: cache nativeCode
]

{ #category : #private }
SendSite >> beInvoke: aCompiledMethod using: invokeInstructions [
	instructions := invokeInstructions.
	cache := aCompiledMethod
]

{ #category : #private }
SendSite >> bePolymorphic [
	format := format bitOr: IsPolymorphic
]

{ #category : #private }
SendSite >> beStaticSend [
	format := format bitOr: IsStaticSend
]

{ #category : #private }
SendSite >> beSuperSend [
	format := format bitOr: IsSuperSend
]

{ #category : #private }
SendSite >> cache [
	^cache
]

{ #category : #private }
SendSite >> flush [
	instructions := self isSuperSend
		ifTrue: [Smalltalk at: #LookupSuperCode]
		ifFalse: [Smalltalk at: #LookupCode].
	cache := nil
]

{ #category : #private }
SendSite >> flush: aSelector [
	aSelector == selector ifTrue: [self flush]
]

{ #category : #private }
SendSite >> hasBeenReset [
	^format isOnBit: HasBeenReset
]

{ #category : #initialization }
SendSite >> initialize [
	tally := 0.
	format := 0
]

{ #category : #private }
SendSite >> instructions [
	^instructions
]

{ #category : #private }
SendSite >> instructions: aByteArray [
	instructions := aByteArray
]

{ #category : #printing }
SendSite >> isFakeMegamorphic [
	^self isFakeMegamorphic: 3
]

{ #category : #printing }
SendSite >> isFakeMegamorphic: maxImplementations [
	| d |
	self isMegamorphic ifFalse: [^false].
	d := IdentitySet new.
	cache size = 15 ifFalse: [^false].
	1 to: cache size - 1 by: 2 do: [:i | | code |
		code := cache at: i + 1.
		d add: code].
	(cache at: cache size) ifNotNil: [:code | d add: code].
	^d size <= maxImplementations
]

{ #category : #private }
SendSite >> isMegamorphic [
	^self isPolymorphic and: [self hasBeenReset]
]

{ #category : #private }
SendSite >> isPolymorphic [
	^format isOnBit: IsPolymorphic
]

{ #category : #testing }
SendSite >> isStaticSelector [
	(#(#basicByteAt: #basicByteAt:put: #byteAtValid: #byteAtValid:put:
		#basicObjectAt: #basicObjectAt:put: #behavior #class #allocate:size:
		 #memory #instanceBehavior
		#_instancesAreArrayed #_instancesHavePointers #nil:slotsOf:
		#initializeExtended:contentSize: #primitiveNew
		#primitiveNewBytes: #primitiveNewPointers: #_return: #_returnTo: #zero:bytesOf:)
		includes: selector)
		ifTrue: [^true].
	^ProtoObject staticSelectors includes: selector
]

{ #category : #testing }
SendSite >> isStaticSend [
	^(format bitAnd: 1) == 1
]

{ #category : #testing }
SendSite >> isSuperSend [
	^(format bitAnd: 2) == 2
]

{ #category : #private }
SendSite >> maxSize [
	^14
]

{ #category : #private }
SendSite >> monomorphicMap: aBehavior to: code [
	instructions := MonomorphicStub.
	cache := self takeNextFreeMIC.
	cache objectAtValid: 1 put: aBehavior.
	cache objectAtValid: 2 put: code
]

{ #category : #private }
SendSite >> polymorphicMap: aBehavior to: code [
	cache _size == 2 ifTrue: [
		instructions := PolymorphicStub.
		cache := self takeNextFreePIC.
		self bePolymorphic].
	aBehavior == SmallInteger instanceBehavior
		ifTrue: [cache objectAtValid: self maxSize + 1 put: code]
		ifFalse: [
			tally == self maxSize ifTrue: [self reset].
			cache
				objectAtValid: tally + 1 put: aBehavior;
				objectAtValid: tally + 2 put: code.
			tally := tally + 2]
]

{ #category : #printing }
SendSite >> printInvokeTypeOn: aStream [
	aStream nextPutAll: 'invoke '; print: cache
]

{ #category : #printing }
SendSite >> printMonomorphicTypeOn: aStream [
	aStream
		nextPutAll: 'mono (';
		print: cache first;
		nextPutAll: ')'
]

{ #category : #printing }
SendSite >> printOn: aStream [
	aStream
		nextPutAll: 'SendSite (';
		nextPutAll: selector;
		nextPutAll: ') ['.
	self printTypeOn: aStream.
	aStream nextPut: $]
]

{ #category : #printing }
SendSite >> printPolymorphicTypeOn: aStream [
	aStream nextPutAll: 'poly '.
	(1 to: tally by: 2)
		do: [:i | | behavior |
			behavior := cache at: i.
			aStream print: behavior]
		separatedBy: [aStream nextPut: $,; space].
	(cache at: cache size)
		ifNotNil: [aStream nextPutAll: ', '; print: SmallInteger behavior].
	aStream nextPutAll: ' -- old: '.
	(tally + 1 to: cache size - 1 by: 2)
		do: [:i | | behavior |
			behavior := cache at: i.
			aStream print: behavior]
		separatedBy: [aStream nextPut: $,; space]
]

{ #category : #printing }
SendSite >> printTypeOn: aStream [
	cache isCompiledMethod ifTrue: [^self printInvokeTypeOn: aStream].
	instructions == MonomorphicStub
		ifTrue: [^self printMonomorphicTypeOn: aStream].
	instructions == PolymorphicStub
		ifTrue: [^self printPolymorphicTypeOn: aStream].
	instructions == (Smalltalk at: #Lookup ifAbsent: [''])
		ifTrue: [^aStream nextPutAll: 'lookup'].
	cache isCompiledMethod
		ifTrue: [^aStream nextPutAll: 'dispatch ' , cache printString].
	aStream nextPutAll: 'other '; print: cache
]

{ #category : #services }
SendSite >> register [
	| sends |
	sends := self class instances
		at: self selector
		ifAbsentPut: [OrderedCollection new].
	sends add: self
]

{ #category : #private }
SendSite >> reset [
	tally := 0.
	format := format bitOr: HasBeenReset
]

{ #category : #private }
SendSite >> selector [
	^selector
]

{ #category : #private }
SendSite >> selector: aSelector [
	selector := aSelector.
	self isStaticSelector ifTrue: [self beStaticSend].
	self register
]

{ #category : #private }
SendSite >> sentSelector [
	^selector
]

{ #category : #private }
SendSite >> takeNextFreeMIC [
	| position |
	position := NextMIC.
	NextMIC := NextMIC + 1.
	position + 50 = MICs _size ifTrue: [self class allocateMoreCaches].
	^MICs _basicAt: position]

{ #category : #private }
SendSite >> takeNextFreePIC [
	| position |
	position := NextPIC.
	NextPIC := NextPIC + 1.
	NextPIC + 50 = PICs _size ifTrue: [self class allocateMoreCaches].
	^PICs _basicAt: position
]

{ #category : #private }
SendSite >> unreset [
	format := format bitAnd: HasBeenReset bitInvert
]

{ #category : #private }
SendSite >> when: aBehavior use: aNativeCode [
	cache == nil
		ifTrue: [
			self isStaticSend
				ifTrue: [
					instructions := Invoke.
					cache := aNativeCode compiledCode]
				ifFalse: [self monomorphicMap: aBehavior to: aNativeCode]]
		ifFalse: [self polymorphicMap: aBehavior to: aNativeCode]
]

