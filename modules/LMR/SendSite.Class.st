'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #SendSite category: #Kernel!
Object subclass: #SendSite
	instanceVariableNames: 'instructions cache format token tally'
	classVariableNames: 'Instances Invoke LookupCount MICs MonomorphicStub NextMIC NextMICs NextPIC NextPICs PICs PolymorphicStub'
	poolDictionaries: ''
	category: 'Kernel'!
!SendSite commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!SendSite methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
_dispatchDebuggableOn: anObject
	| cm nativeCode invoked |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: token.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: token].
	invoked := Processor activeProcess wantsToStepInto
		ifTrue: [cm debuggableCopy]
		ifFalse: [cm].
	invoked prepareForExecution.
	nativeCode := invoked nativeCode.
	"self when: anObject behavior use: nativeCode code."
	^anObject _transferControlTo: nativeCode
! !

!SendSite methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
_dispatchDebuggableOn: anObject startingAt: aBehavior
	| cm nativeCode invoked |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#aBehavior -> #regT.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: token in: aBehavior.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: token].
	invoked := Processor activeProcess wantsToStepInto
		ifTrue: [cm debuggableCopy]
		ifFalse: [cm].
	invoked prepareForExecution.
	nativeCode := invoked nativeCode.
	"self when: aBehavior use: nativeCode code."
	^anObject _transferControlTo: nativeCode
! !

!SendSite methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
_dispatchOn: anObject
	| cm nativeCode |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: token.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: token].
	cm prepareForExecution.
	nativeCode := cm nativeCode.
	self when: anObject behavior use: nativeCode.
	^anObject _transferControlTo: nativeCode
! !

!SendSite methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
_dispatchOn: anObject startingAt: aBehavior
	| cm nativeCode |
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#aBehavior -> #regT.
	#specialABIEnd.
	LookupCount := LookupCount + 1.
	cm := anObject _cachedLookup: token in: aBehavior.
	cm == nil ifTrue: [^anObject doesNotUnderstandSelector: token].
	cm prepareForExecution.
	nativeCode := cm nativeCode.
	self beInvoke: cm using: Invoke.
	^anObject _transferControlTo: nativeCode
! !

!SendSite methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
_invokeOn: anObject
	#savePreviousSelf.
	#specialABIBegin.
	#anObject -> #regR.
	#self -> #regA.
	#specialABIEnd.
	^anObject _transferControlTo: cache nativeCode
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
beInvoke: aCompiledMethod using: invokeInstructions
	instructions := invokeInstructions.
	token := aCompiledMethod selector.
	cache := aCompiledMethod
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
bePolymorphic
	format := format bitOr: IsPolymorphic
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
beStaticSend
	format := format bitOr: IsStaticSend
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
beSuperSend
	format := format bitOr: IsSuperSend
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
cache
	^cache
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
flush
	self isStaticSend ifTrue: [^self].
	instructions := self isSuperSend
		ifTrue: [Smalltalk at: #LookupSuperCode]
		ifFalse: [Smalltalk at: #LookupCode].
	cache := nil.
	tally := 0
! !

!SendSite methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
flush: aSymbol
	aSymbol == token ifTrue: [self flush]
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasBeenReset
	^format isOnBit: HasBeenReset
! !

!SendSite methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	tally := 0.
	format := 0
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructions
	^instructions
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructions: aByteArray
	instructions := aByteArray
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isFakeMegamorphic
	^self isFakeMegamorphic: 3
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isFakeMegamorphic: maxImplementations
	| d |
	self isMegamorphic ifFalse: [^false].
	d := IdentitySet new.
	cache size = 15 ifFalse: [^false].
	1 to: cache size - 1 by: 2 do: [:i | | code |
		code := cache at: i + 1.
		d add: code].
	(cache at: cache size) ifNotNil: [:code | d add: code].
	^d size <= maxImplementations
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMegamorphic
	^self isPolymorphic and: [self hasBeenReset]
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPolymorphic
	^format isOnBit: IsPolymorphic
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStaticSelector
	(#(#basicByteAt: #basicByteAt:put: #basicInstVarAt: #basicInstVarAt:put:
		#behavior #class #allocate:size:
		 #memory #instanceBehavior
		#_instancesAreArrayed #_instancesHavePointers #nil:slotsOf:
		#initializeExtended:contentSize: #primitiveNew
		#primitiveNewBytes: #primitiveNewPointers: #_return: #_returnTo: #zero:bytesOf:)
		includes: token)
		ifTrue: [^true].
	^ProtoObject staticSelectors includes: token
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStaticSend
	^(format bitAnd: IsStaticSend) == IsStaticSend
! !

!SendSite methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSuperSend
	^(format bitAnd: IsSuperSend) == IsSuperSend
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
maxSize
	^14
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
monomorphicMap: aBehavior to: code
	cache := self takeNextFreeMIC ifNil: [^self].
	instructions := self monomorphicStub.
	cache
		objectAtValid: 1 put: aBehavior;
		objectAtValid: 2 put: code
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
monomorphicStub
	^MonomorphicStub code
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
polymorphicMap: aBehavior to: code
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
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
polymorphicStub
	^PolymorphicStub code
! !

!SendSite methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printInvokeTypeOn: aStream
	aStream nextPutAll: 'invoke '; print: cache
! !

!SendSite methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printMonomorphicTypeOn: aStream
	aStream
		nextPutAll: 'mono (';
		print: cache first;
		nextPutAll: ')'
! !

!SendSite methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: 'SendSite (';
		nextPutAll: token;
		nextPutAll: ') ['.
	self printTypeOn: aStream.
	aStream nextPut: $]
! !

!SendSite methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printPolymorphicTypeOn: aStream
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
! !

!SendSite methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTypeOn: aStream
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
! !

!SendSite methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
register
	| sends |
	sends := self class instances
		at: self selector
		ifAbsentPut: [OrderedCollection new].
	sends add: self
! !

!SendSite methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	tally := 0.
	format := format bitOr: HasBeenReset
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector
	^token
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector: aSymbol
	token := aSymbol.
	self isStaticSelector ifTrue: [self beStaticSend].
	Smalltalk isDMR ifTrue: [self register]
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
sentSelector
	^token
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
takeNextFreeMIC
	| result |
	result := MICs _basicAt: NextMIC.
	NextMIC = MICs _size
		ifTrue: [self class useNextMICs]
		ifFalse: [NextMIC := NextMIC + 1].
	^result
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
takeNextFreePIC
	| result |
	result := PICs _basicAt: NextPIC.
	NextPIC = PICs _size
		ifTrue: [self class useNextPICs]
		ifFalse: [NextPIC := NextPIC + 1].
	^result
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
unreset
	format := format bitAnd: HasBeenReset bitInvert
! !

!SendSite methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
when: aBehavior use: aNativeCode
	cache == nil
		ifTrue: [
			self isStaticSend
				ifTrue: [
					instructions := Invoke.
					cache := aNativeCode compiledCode]
				ifFalse: [self monomorphicMap: aBehavior to: aNativeCode]]
		ifFalse: [self polymorphicMap: aBehavior to: aNativeCode]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SendSite class' category: #Kernel!
SendSite class
	instanceVariableNames: 'Instances Invoke LookupCount MICs MonomorphicStub NextMIC NextMICs NextPIC NextPICs PICs PolymorphicStub'!

!SendSite class methodsFor:  'writing image' stamp: 'KenD 28/Jun/2026 13:27:39'!
ensureEnoughFreeCaches: anInteger
	MICs _size - NextMIC < anInteger ifTrue: [self useNextMICs].
	PICs _size - NextPIC < (anInteger // 8) ifTrue: [self useNextPICs]
! !

!SendSite class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
flush: selector
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
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
flushForRelease
	self instances do: [:sites | sites do: [:s | s flush]].
	self flushInstances; useNextMICs; useNextPICs
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
flushInstances
	Instances := nil
! !

!SendSite class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeFormatFlags
	self addNamespaceAs: #FormatFlags.
	FormatFlags
		at: #IsStaticSend put: 0x1;
		at: #IsSuperSend put: 0x2;
		at: #IsPolymorphic put: 0x4;
		at: #HasBeenReset put: 0x8
! !

!SendSite class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeFrom: aNativizationEnvironment
	self
		reserveMoreMICs;
		reserveMorePICsWith: aNativizationEnvironment lookup;
		useNextMICs;
		useNextPICsWith: aNativizationEnvironment lookup;
		initializeMICStubFor: aNativizationEnvironment abi;
		initializePICStubFor: aNativizationEnvironment abi.
	Invoke := aNativizationEnvironment invokeStub
! !

!SendSite class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
instances
	Instances ifNil: [
		Instances := IdentityDictionary new.
		self allInstances do: [:send | send register]].
	^Instances
! !

!SendSite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
invoking: aCompiledMethod using: instructions
	^self new beStaticSend; beInvoke: aCompiledMethod using: instructions
! !

!SendSite class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUndermethod: aSelector
	^self undermethodSelectors includes: aSelector
! !

!SendSite class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupCount
	^LookupCount
! !

!SendSite class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
mics
	^MICs
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectStaticSelectors
	"
		self undermethodSelectors asArray sort
	"
		^#(
_beArrayed _beBytes _beLarge _beNamed _beNotRemembered _beRemembered _beSecondGeneration _beSeen _beSmall _beSpecial _beNotSpecial _beUnseen _copyBasicHeaderFrom: _copyHeaderSized:from: _flagsMask: _flagsSet: _hasBeenSeen _headerSizeInBytes _isArrayed _isBytes _isEphemeron _isFixed _isLarge _hasNamedSlots _isProxy _isRemembered _isSecondGeneration _isSmall _isSpecial _largeSize: _nextBasePointer _objectFromBasePointer _pointersSize _size _sizeInBytes _strongPointersSize )
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
optimizedStaticSelectors
	^#(#basicByteAt: #basicByteAt:put: #byteAtValid: #byteAtValid:put:
		#basicObjectAt: #basicObjectAt:put: #behavior #class #allocate:size:
		 #memory #instanceBehavior
		#_instancesAreArrayed #_instancesHavePointers #nil:slotsOf:
		#initializeExtended:contentSize: #primitiveNew
		#primitiveNewBytes: #primitiveNewPointers: #_return: #_returnTo: #zero:bytesOf:)
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
reserveMoreMICs
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
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
reserveMorePICsWith: aNativeCode
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
! !

!SendSite class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
sending: selector with: instructions
	^self new selector: selector; instructions: instructions
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
undermethods
	^LMRProtoObject methodDictionary values asArray select: [:m | m selector beginsWith: '_']
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
undermethodSelectors
	"^self organization selectorsFor: 'header access'"
	^self undermethods collect: [:method | method selector]
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
useNextMICs
	MICs := NextMICs.
	NextMIC := 1.
	self reserveMoreMICs
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
useNextPICs
	self useNextPICsWith: nil
! !

!SendSite class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
useNextPICsWith: aNativeCode
	PICs := NextPICs.
	NextPIC := 1.
	self reserveMorePICsWith: aNativeCode
! !


SendSite initialize!

