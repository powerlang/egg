"
	Copyright (c) 2020-2022 Quorum Software.
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
		'NextMICs',
		'NextPIC',
		'NextPICs',
		'PICs',
		'PolymorphicStub'
	],
	#category : #Kernel
}

{ #category : #'writing image' }
SendSite class >> ensureEnoughFreeCaches: anInteger [
	MICs _size - NextMIC < anInteger ifTrue: [self useNextMICs].
	PICs _size - NextPIC < (anInteger // 8) ifTrue: [self useNextPICs]
]

{ #category : #services }
SendSite class >> flush: selector [
	| sends count copy |
	sends := self instances at: selector ifAbsent: [^self].
	count := 0.
	sends do: [:send | 
		send ifNotNil: [
			count := count + 1.
			send flush: selector]].
	count * 3 < sends size ifFalse: [^self].
	count = 0 ifTrue: [^sends removeKey: selector].
	copy := WeakArray new: (count * 1.5) asInteger.
	count := 0.
	sends do: [:send | 
		send ifNotNil: [
			count := count + 1.
			copy at: count put: send]].
	self instances at: selector put: copy
]

{ #category : #private }
SendSite class >> flushForRelease [
	self instances do: [:sites | sites do: [:s | s flush]].
	self flushInstances; useNextMICs; useNextPICs
]

{ #category : #private }
SendSite class >> flushInstances [
	Instances := nil
]

{ #category : #initialization }
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
SendSite class >> initializeFrom: aNativizationEnvironment [
	self
		reserveMoreMICs;
		reserveMorePICsWith: aNativizationEnvironment lookup;
		useNextMICs;
		useNextPICsWith: aNativizationEnvironment lookup;
		initializeMICStubFor: aNativizationEnvironment abi;
		initializePICStubFor: aNativizationEnvironment abi.
	Invoke := aNativizationEnvironment invokeStub
]

{ #category : #accessing }
SendSite class >> instances [
	Instances ifNil: [
		Instances := IdentityDictionary new.
		self allInstances do: [:send | send register]].
	^Instances
]

{ #category : #'instance creation' }
SendSite class >> invoking: aCompiledMethod using: instructions [
	^self new beStaticSend; beInvoke: aCompiledMethod
	using: instructions
]

{ #category : #accessing }
SendSite class >> lookupCount [
	^LookupCount
]

{ #category : #accessing }
SendSite class >> mics [
	^MICs
]

{ #category : #'instance creation' }
SendSite class >> new [
	^self basicNew initialize
]

{ #category : #private }
SendSite class >> reserveMoreMICs [
	"
	The amount needs to be enough to execute all the code until either:
	a. initializing the memory spaces;
	b. reading the image.
	If not, when exhausting the caches we will try to create a new GCSpace
	but will raise errors because memory hasn't been initialized yet
	"
	| memory amount array mic |
	memory := Smalltalk memory.
	amount := 2000.
	array := memory newLargeArray: amount.
	mic := Array new: 2.
	1 to: amount do: [:i | array basicAt: i put: (memory pinnedCopy: mic)].
	NextMICs := array
]

{ #category : #private }
SendSite class >> reserveMorePICsWith: aNativeCode [
	| memory amount array lookup pic |
	memory := Smalltalk memory.
	amount := 1000.
	array := memory newLargeArray: amount.
	lookup := aNativeCode ifNil: [Smalltalk at: #Lookup].
	pic := (Array new: 15)
		at: 15 put: lookup;
		yourself.
	1 to: amount do: [:i | array basicAt: i put: (memory pinnedCopy: pic)].
	NextPICs := array
]

{ #category : #'instance creation' }
SendSite class >> sending: aSelector with: instructions [
	^self new selector: aSelector; instructions: instructions
]

{ #category : #private }
SendSite class >> useNextMICs [
	MICs := NextMICs.
	NextMIC := 1.
	self reserveMoreMICs
]

{ #category : #private }
SendSite class >> useNextPICs [
	self useNextPICsWith: nil
]

{ #category : #private }
SendSite class >> useNextPICsWith: aNativeCode [
	PICs := NextPICs.
	NextPIC := 1.
	self reserveMorePICsWith: aNativeCode
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
	invoked := Processor activeProcess wantsToStepInto
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
	invoked := Processor activeProcess wantsToStepInto
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
	self isStaticSend ifTrue: [^self].
	instructions := self isSuperSend
		ifTrue: [Smalltalk at: #LookupSuperCode]
		ifFalse: [Smalltalk at: #LookupCode].
	cache := nil.
	tally := 0
]

{ #category : #services }
SendSite >> flush: aSelector [
	aSelector == selector ifTrue: [self flush]
]

{ #category : #testing }
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

{ #category : #testing }
SendSite >> isFakeMegamorphic [
	^self isFakeMegamorphic: 3
]

{ #category : #testing }
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

{ #category : #testing }
SendSite >> isMegamorphic [
	^self isPolymorphic and: [self hasBeenReset]
]

{ #category : #testing }
SendSite >> isPolymorphic [
	^format isOnBit: IsPolymorphic
]

{ #category : #testing }
SendSite >> isStaticSelector [
	(#(#basicByteAt: #basicByteAt:put: #basicInstVarAt: #basicInstVarAt:put:
		#behavior #class #allocate:size:
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
	cache := self takeNextFreeMIC ifNil: [^self].
	instructions := self monomorphicStub.
	cache
		objectAtValid: 1 put: aBehavior;
		objectAtValid: 2 put: code
]

{ #category : #private }
SendSite >> monomorphicStub [
	^MonomorphicStub code
]

{ #category : #private }
SendSite >> polymorphicMap: aBehavior to: code [
	cache _size == 2 ifTrue: [
		cache := self takeNextFreePIC ifNil: [^self].
		tally := 0.
		instructions := self polymorphicStub.
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

{ #category : #private }
SendSite >> polymorphicStub [
	^PolymorphicStub code
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
	instructions == MonomorphicStub code
		ifTrue: [^self printMonomorphicTypeOn: aStream].
	instructions == PolymorphicStub code
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

{ #category : #services }
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
	| result |
	result := MICs _basicAt: NextMIC.
	NextMIC = MICs _size
		ifTrue: [self class useNextMICs]
		ifFalse: [NextMIC := NextMIC + 1].
	^result
]

{ #category : #private }
SendSite >> takeNextFreePIC [
	| result |
	result := PICs _basicAt: NextPIC.
	NextPIC = PICs _size
		ifTrue: [self class useNextPICs]
		ifFalse: [NextPIC := NextPIC + 1].
	^result
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

