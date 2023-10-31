"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #ProtoObject }

{ #category : #'*system' }
ProtoObject >> == anObject [
	^self _identityEquals: anObject
]

{ #category : #'*header access' }
ProtoObject >> _beArrayed [
	self _flagsSet: IsArrayed
]

{ #category : #'*header access' }
ProtoObject >> _beBytes [
	self _flagsSet: IsBytes
]

{ #category : #'*header access' }
ProtoObject >> _beFirstGeneration [
	self _flagsMask: IsSecondGenerationMask
]

{ #category : #'*header access' }
ProtoObject >> _beLarge [
	self _flagsMask: IsSmallMask
]

{ #category : #'*header access' }
ProtoObject >> _beNamed [
	self _flagsSet: IsNamed
]

{ #category : #'*header access' }
ProtoObject >> _beNotRemembered [
	self _flagsMask: IsRememberedMask
]

{ #category : #'*header access' }
ProtoObject >> _beNotSpecial [
	self _flagsMask: IsSpecialMask
]

{ #category : #'*header access' }
ProtoObject >> _beRemembered [
	self _flagsSet: IsRemembered
]

{ #category : #'*header access' }
ProtoObject >> _beSecondGeneration [
	self _flagsSet: IsSecondGeneration
]

{ #category : #'*header access' }
ProtoObject >> _beSeen [
	self _flagsSet: HasBeenSeen
]

{ #category : #'*header access' }
ProtoObject >> _beSmall [
	self _flagsSet: IsSmall
]

{ #category : #'*header access' }
ProtoObject >> _beSpecial [
	self _flagsSet: IsSpecial
]

{ #category : #'*header access' }
ProtoObject >> _beUnseen [
	self _flagsMask: HasBeenSeenMask
]

{ #category : #'*header access' }
ProtoObject >> _copyBasicHeaderFrom: other [
	self
		_basicULongAt: -1 put: (other _basicULongAt: -1);
		_basicULongAt: 0 put: (other _basicULongAt: 0)
]

{ #category : #'*header access' }
ProtoObject >> _copyHeaderSized: byteSize from: anObject [
	byteSize = 16 ifTrue: [
		self
			_basicULongAt: -3 put: (anObject _basicULongAt: -3);
			_basicULongAt: -2 put: (anObject _basicULongAt: -2)].
	self
		_basicULongAt: -1 put: (anObject _basicULongAt: -1);
		_basicULongAt: 0 put: (anObject _basicULongAt: 0)
]

{ #category : #'header access' }
ProtoObject >> _flagsMask: mask [
	self _basicFlags: (self _basicFlags bitAnd: mask)
]

{ #category : #'header access' }
ProtoObject >> _flagsSet: mask [
	self _basicFlags: (self _basicFlags bitOr: mask)
]

{ #category : #'header access' }
ProtoObject >> _hasBeenSeen [
	^(self _basicFlags bitAnd: HasBeenSeen) == HasBeenSeen
]

{ #category : #'header access' }
ProtoObject >> _hasNamedSlots [
	^(self _basicFlags bitAnd: IsNamed) = IsNamed
]

{ #category : #'header access' }
ProtoObject >> _headerSizeInBytes [
	^self _isSmall ifTrue: [8] ifFalse: [16]
]

{ #category : #underprimitives }
ProtoObject >> _highHalf [
	^self _oop bitShift: WordSize * 8 // -2
]

{ #category : #lookup }
ProtoObject >> _invoke: aNativeCode [
	"
	senders of _invoke: MUST have at least 1 temporary. The argument of
	_invoke: is removed twice: once here and once again after returning from
	_invoke. If no temps are present, the second pop smashes the compiled
	method of the frame, which happens to be in the top of the stack. This
	would only be noticed by random crashes when executing debuggable
	methods (because they send a message after _invoke: and before returning)
	"
	^self _transferControlDiscardingLastArgTo: aNativeCode
]

{ #category : #'header access' }
ProtoObject >> _isArrayed [
	^false == self _isFixed
]

{ #category : #'header access' }
ProtoObject >> _isBytes [
	^(self _basicFlags bitAnd: IsBytes) = IsBytes
]

{ #category : #'header access' }
ProtoObject >> _isFixed [
	^(self _basicFlags bitAnd: IsArrayed) == 0
]

{ #category : #'header access' }
ProtoObject >> _isLarge [
	^(self _basicFlags bitAnd: IsSmall) == 0
]

{ #category : #'header access' }
ProtoObject >> _isProxy [
	^self _hasBeenSeen
]

{ #category : #'header access' }
ProtoObject >> _isRemembered [
	^(self _basicFlags bitAnd: IsRemembered) = IsRemembered
]

{ #category : #'header access' }
ProtoObject >> _isSecondGeneration [
	^(self _basicFlags bitAnd: IsSecondGeneration) = IsSecondGeneration
]

{ #category : #'header access' }
ProtoObject >> _isSmall [
	^(self _basicFlags bitAnd: IsSmall) = IsSmall
]

{ #category : #'header access' }
ProtoObject >> _isSpecial [
	^(self _basicFlags bitAnd: IsSpecial) = IsSpecial
]

{ #category : #'header access' }
ProtoObject >> _largeSize: size [
	self _basicULongAt: _ExtendedSize put: size _asNative
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol [
	^self _lookup: aSymbol in: self behavior
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol in: behavior [
	| methods cm next |
	methods := behavior _basicAt: 2.
	cm := self _lookup: aSymbol inDictionary: methods.
	cm == nil ifFalse: [^cm].
	next := behavior _basicAt: 3.
	^next == nil ifFalse: [self _lookup: aSymbol in: next]
]

{ #category : #lookup }
ProtoObject >> _lookup: aSymbol inDictionary: methodDictionary [
	| table |
	table := methodDictionary _basicAt: 2.
	2
		to: table _size
		by: 2
		do: [:j | (table _basicAt: j) == aSymbol ifTrue: [^table _basicAt: j + 1]].
	^nil
]

{ #category : #underprimitives }
ProtoObject >> _low32 [
	^WordSize > 4 ifTrue: [self bitAnd: 0xFFFFFFFF] ifFalse: [self]
]

{ #category : #underprimitives }
ProtoObject >> _lowHalf [
	^self _oop bitAnd: 16rFFFF
]

{ #category : #'header access' }
ProtoObject >> _makeExtendedSize: size [
	self
		_beLarge;
		_smallSize: 4;
		_largeSize: size;
		_basicULongAt: _Reserved put: 0 _asNative
]

{ #category : #'header access' }
ProtoObject >> _nextBasePointer [
	^self _asPointer + self _sizeInBytes _asPointer
]

{ #category : #'header access' }
ProtoObject >> _objectFromBasePointer [
	| offset |
	offset := (self _asObject _byteAt: 4) > 127 ifTrue: [8] ifFalse: [16].
	^(self + offset _asPointer) _asObject
]

{ #category : #underprimitives }
ProtoObject >> _oop [
	^self _asPointer * 2
]

{ #category : #'header access' }
ProtoObject >> _pointersSize [
	^self _isBytes ifTrue: [0] ifFalse: [self _size]
]

{ #category : #unwinding }
ProtoObject >> _returnTo: aBeeFrame [
	[#forceEnvironment].
	aBeeFrame _beCurrent.
	^self
]

{ #category : #'*header access' }
ProtoObject >> _size [
	^self _isSmall ifTrue: [self _smallSize] ifFalse: [self _largeSize]
]

{ #category : #'header access' }
ProtoObject >> _sizeInBytes [
	| total |
	total := self _size.
	^self _isBytes
		ifTrue: [total + WordSize - 1 bitAnd: 0 - WordSize]
		ifFalse: [total * WordSize]
]

{ #category : #'header access' }
ProtoObject >> _strongPointersSize [
	^(self _isBytes or: [self _isSpecial]) ifTrue: [0] ifFalse: [0 + self _size]
]

{ #category : #'*system' }
ProtoObject >> basicHash [
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
]

{ #category : #'*system' }
ProtoObject >> basicHash: anInteger [
	self _basicHash: anInteger
]

{ #category : #'*meta accessing' }
ProtoObject >> behavior [
	^self _isSmallInteger
		ifTrue: [SmallInteger instanceBehavior]
		ifFalse: [self _basicULongAt: 0]
]

{ #category : #'*meta accessing' }
ProtoObject >> behavior: aBehavior [
	^self _isSmallInteger
		ifTrue: [self error: 'can''t change behavior of a small integer']
		ifFalse: [
			aBehavior _holdRefererIfNeeded: self.
			self _basicULongAt: 0 put: aBehavior]
]

{ #category : #'header access' }
ProtoObject >> initializeExtended: aBoolean contentSize: size [
	self _basicULongAt: -1 put: 0 _asNative.
	aBoolean
		ifTrue: [
			self
				_smallSize: 4;
				_basicULongAt: _ExtendedSize put: size _asNative;
				_basicULongAt: _Reserved put: 0 _asNative]
		ifFalse: [self _smallSize: size; _beSmall]
]

{ #category : #'*system' }
ProtoObject >> primitiveSize [
	| size |
	self _isSmallInteger ifTrue: [^0].
	self _isArrayed ifFalse: [^0].
	size := self _size.
	^self _hasNamedSlots ifTrue: [size - self class instSize] ifFalse: [size]
]

{ #category : #'*accessing' }
ProtoObject >> primitiveAt: i [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i]
		ifFalse: [self basicObjectAt: i]
]

{ #category : #'*accessing' }
ProtoObject >> primitiveAt: i put: anObject [
	self _isSmallInteger ifTrue: [^self shouldNotImplement].
	^self _isBytes
		ifTrue: [self basicByteAt: i put: anObject]
		ifFalse: [self basicObjectAt: i put: anObject]
]

