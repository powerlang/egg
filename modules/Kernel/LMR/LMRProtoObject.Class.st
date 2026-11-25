'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LMRProtoObject category: #Kernel!
ProtoObject subclass: #LMRProtoObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LMRProtoObject commentStamp: '<historical>' prior: 0!

	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRProtoObject methodsFor:  '*system' stamp: 'KenD 28/Jun/2026 13:27:38'!
== anObject
	^self _identityEquals: anObject
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beArrayed
	self _flagsSet: IsArrayed
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beBytes
	self _flagsSet: IsBytes
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beFirstGeneration
	self _flagsMask: IsSecondGenerationMask
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beLarge
	self _flagsMask: IsSmallMask
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beNamed
	self _flagsSet: IsNamed
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beNotRemembered
	self _flagsMask: IsRememberedMask
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beNotSpecial
	self _flagsMask: IsSpecialMask
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beRemembered
	self _flagsSet: IsRemembered
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beSecondGeneration
	self _flagsSet: IsSecondGeneration
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beSeen
	self _flagsSet: HasBeenSeen
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beSmall
	self _flagsSet: IsSmall
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beSpecial
	self _flagsSet: IsSpecial
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_beUnseen
	self _flagsMask: HasBeenSeenMask
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_cachedLookup: aSymbol
	^self _cachedLookup: aSymbol in: self behavior
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_cachedLookup: aSymbol in: behavior
	^GlobalDispatchCache current lookupAndCache: aSymbol in: behavior
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_copyBasicHeaderFrom: other
	self
		_basicULongAt: -1 put: (other _basicULongAt: -1);
		_basicULongAt: 0 put: (other _basicULongAt: 0)
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_copyHeaderSized: byteSize from: anObject
	byteSize = 16 ifTrue: [
		self
			_basicULongAt: -3 put: (anObject _basicULongAt: -3);
			_basicULongAt: -2 put: (anObject _basicULongAt: -2)].
	self
		_basicULongAt: -1 put: (anObject _basicULongAt: -1);
		_basicULongAt: 0 put: (anObject _basicULongAt: 0)
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_flagsMask: mask
	self _basicFlags: (self _basicFlags bitAnd: mask)
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_flagsSet: mask
	self _basicFlags: (self _basicFlags bitOr: mask)
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_hasBeenSeen
	^(self _basicFlags bitAnd: HasBeenSeen) == HasBeenSeen
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_hasNamedSlots
	^(self _basicFlags bitAnd: IsNamed) = IsNamed
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_headerSizeInBytes
	^self _isSmall ifTrue: [8] ifFalse: [16]
! !

!LMRProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_highHalf
	^self _oop bitShift: WordSize * 8 // -2
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_invoke: aNativeCode
	"
	senders of _invoke: MUST have at least 1 temporary. The argument of
	_invoke: is removed twice: once here and once again after returning from
	_invoke. If no temps are present, the second pop smashes the compiled
	method of the frame, which happens to be in the top of the stack. This
	would only be noticed by random crashes when executing debuggable
	methods (because they send a message after _invoke: and before returning)
	"
	^self _transferControlDiscardingLastArgTo: aNativeCode
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isArrayed
	^false == self _isFixed
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isBytes
	^(self _basicFlags bitAnd: IsBytes) = IsBytes
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isFixed
	^(self _basicFlags bitAnd: IsArrayed) == 0
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isLarge
	^(self _basicFlags bitAnd: IsSmall) == 0
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isProxy
	^self _hasBeenSeen
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isRemembered
	^(self _basicFlags bitAnd: IsRemembered) = IsRemembered
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isSecondGeneration
	^(self _basicFlags bitAnd: IsSecondGeneration) = IsSecondGeneration
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isSmall
	^(self _basicFlags bitAnd: IsSmall) = IsSmall
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isSpecial
	^(self _basicFlags bitAnd: IsSpecial) = IsSpecial
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_largeSize: size
	self _basicULongAt: _ExtendedSize put: size _asNative
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_lookup: aSymbol
	^self _lookup: aSymbol in: self behavior
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_lookup: aSymbol in: behavior
	| methods cm next |
	methods := behavior _basicAt: 2.
	cm := self _lookup: aSymbol inDictionary: methods.
	cm == nil ifFalse: [^cm].
	next := behavior _basicAt: 3.
	^next == nil ifFalse: [self _lookup: aSymbol in: next]
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
_lookup: aSymbol inDictionary: methodDictionary
	| table |
	table := methodDictionary _basicAt: 2.
	2
		to: table _size
		by: 2
		do: [:j | (table _basicAt: j) == aSymbol ifTrue: [^table _basicAt: j + 1]].
	^nil
! !

!LMRProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_low32
	^WordSize > 4 ifTrue: [self bitAnd: 0xFFFFFFFF] ifFalse: [self]
! !

!LMRProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_lowHalf
	^self _oop bitAnd: 16rFFFF
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_makeExtendedSize: size
	self
		_beLarge;
		_smallSize: 4;
		_largeSize: size;
		_basicULongAt: _Reserved put: 0 _asNative
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_nextBasePointer
	^self _asPointer + self _sizeInBytes _asPointer
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_objectFromBasePointer
	| offset |
	offset := (self _asObject _byteAt: 4) > 127 ifTrue: [8] ifFalse: [16].
	^(self + offset _asPointer) _asObject
! !

!LMRProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_oop
	^self _asPointer * 2
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_pointersSize
	^self _isBytes ifTrue: [0] ifFalse: [self _size]
! !

!LMRProtoObject methodsFor:  'raw access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_uLongAtValidOffset: offset put: anInteger
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _primitiveULongAtOffset: offset put: anInteger.
	^anInteger
! !

!LMRProtoObject methodsFor:  'unwinding' stamp: 'KenD 28/Jun/2026 13:27:38'!
_returnTo: aBeeFrame
	[#forceEnvironment].
	aBeeFrame _beCurrent.
	^self
! !

!LMRProtoObject methodsFor:  '*header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_size
	^self _isSmall ifTrue: [self _smallSize] ifFalse: [self _largeSize]
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_sizeInBytes
	| total |
	total := self _size.
	^self _isBytes
		ifTrue: [total + WordSize - 1 bitAnd: 0 - WordSize]
		ifFalse: [total * WordSize]
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
_strongPointersSize
	^(self _isBytes or: [self _isSpecial]) ifTrue: [0] ifFalse: [0 + self _size]
! !

!LMRProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
allReferences
	^Memory current collectAndCompactOldSpace; referencesTo: self
! !

!LMRProtoObject methodsFor:  '*system' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash
	| hash shifted |
	"
	LastHash := 1. 
	LFSR implementation (avoids 0 by definition)
	"
	hash := self _basicHash.
	hash == 0 ifFalse: [^hash].
	shifted := LastHash bitShift: -1.
	hash := (LastHash bitAnd: 1) = 0
		ifTrue: [shifted]
		ifFalse: [shifted bitXor: 16rB9C8].
	self _basicHash: hash.
	^LastHash := hash
! !

!LMRProtoObject methodsFor:  '*system' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash: anInteger
	self _basicHash: anInteger
! !

!LMRProtoObject methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
become: anotherObject
	Memory current make: self become: anotherObject
! !

!LMRProtoObject methodsFor:  '*meta accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
behavior
	^self _isSmallInteger
		ifTrue: [SmallInteger instanceBehavior]
		ifFalse: [self _basicULongAt: 0]
! !

!LMRProtoObject methodsFor:  '*meta accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
behavior: aBehavior
	^self _isSmallInteger
		ifTrue: [self error: 'can''t change behavior of a small integer']
		ifFalse: [
			aBehavior _holdRefererIfNeeded: self.
			self _basicULongAt: 0 put: aBehavior]
! !

!LMRProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
doesNotUnderstandSelector: selector
	| arguments message |
	arguments := StackFrameCursor top moveNext
		argumentsWithArity: selector arity.
	message := Message receiver: self selector: selector arguments: arguments.
	^self doesNotUnderstand: message
! !

!LMRProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
holdRefererIfNeeded: referent
	| memory |
	#savePreviousSelf.
	self _isSmallInteger ifTrue: [^self].
	referent _isRemembered ifTrue: [^self].
	memory := Memory current.
	(memory isYoungSafe: referent)
		ifFalse: [(memory isYoungSafe: self) ifTrue: [memory remember: referent]]
! !

!LMRProtoObject methodsFor:  'header access' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeExtended: aBoolean contentSize: size
	self _basicULongAt: -1 put: 0 _asNative.
	aBoolean
		ifTrue: [
			self
				_smallSize: 4;
				_basicULongAt: _ExtendedSize put: size _asNative;
				_basicULongAt: _Reserved put: 0 _asNative]
		ifFalse: [self _smallSize: size; _beSmall]
! !

!LMRProtoObject methodsFor:  'lookup' stamp: 'KenD 28/Jun/2026 13:27:38'!
lookupAndInvoke: aSymbol
	| cm |
	cm := self _cachedLookup: aSymbol.
	cm == nil ifTrue: [^self doesNotUnderstandSelector: aSymbol].
	cm prepareForExecution.
	self _transferControlDiscardingLastArgTo: cm validNativeCodeAddress _asNative
! !

!LMRProtoObject methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform: aSymbol withArguments: anArray
	| size |
	size := anArray basicSize.
	aSymbol arity = size ifFalse: [^self error: 'incorrect arity'].
	anArray _expandInStackSized: size.
	^self lookupAndInvoke: aSymbol
! !

!LMRProtoObject methodsFor:  '*accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveAt: i
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i]
		ifFalse: [self basicObjectAt: i]
! !

!LMRProtoObject methodsFor:  '*accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveAt: i put: anObject
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i put: anObject]
		ifFalse: [self basicObjectAt: i put: anObject]
! !

!LMRProtoObject methodsFor:  '*system' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveSize
	| size |
	self _isSmallInteger ifTrue: [^0].
	self _isArrayed ifFalse: [^0].
	size := self _size.
	^self _hasNamedSlots ifTrue: [size - self class instSize] ifFalse: [size]
! !

!LMRProtoObject methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
shouldBeInRememberedSet
	| m |
	m := Memory current.
	(m isYoung: self) ifTrue: [^false].
	(m isYoung: self behavior) ifTrue: [^true].
	1 to: self _pointersSize do: [:index | | ivar |
		ivar := self _basicAt: index.
		ivar _isSmallInteger ifFalse: [(m isYoung: ivar) ifTrue: [^true]]].
	^false
! !

!LMRProtoObject methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
smallOop
	^self _asPointer
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LMRProtoObject class' category: #Kernel!
LMRProtoObject class
	instanceVariableNames: ''!

!ProtoObject class methodsFor:  '*system' stamp: 'KenD 28/Jun/2026 13:27:38'!
undermethodSelectors
	^LMRProtoObject methodDictionary values asArray select: [:m | m selector beginsWith: '_']
! !


