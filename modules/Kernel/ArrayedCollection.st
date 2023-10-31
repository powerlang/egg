"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ArrayedCollection,
	#superclass : #SequenceableCollection,
	#category : #Kernel
}

{ #category : #'instance creation' }
ArrayedCollection class >> with: anObject [
	| array |
	array := self new: 1.
	array at: 1 put: anObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject with: secondObject [
	| array |
	array := self new: 2.
	array
		at: 1 put: firstObject;
		at: 2 put: secondObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject with: secondObject with: thirdObject [
	| array |
	array := self new: 3.
	array
		at: 1 put: firstObject;
		at: 2 put: secondObject;
		at: 3 put: thirdObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: firstObject
with: secondObject
with: thirdObject
with: fourthObject [
	| array |
	array := self new: 4.
	array
		at: 1 put: firstObject;
		at: 2 put: secondObject;
		at: 3 put: thirdObject;
		at: 4 put: fourthObject.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> with: anObject withAll: aCollection [
	| array |
	array := self new: aCollection size + 1.
	array
		at: 1 put: anObject;
		replaceFrom: 2 to: array size with: aCollection.
	^array
]

{ #category : #'instance creation' }
ArrayedCollection class >> withAll: aCollection with: anObject [
	| instance |
	instance := self new: aCollection size + 1.
	instance
		replaceFrom: 1 to: instance size - 1 with: aCollection;
		at: instance size put: anObject.
	^instance
]

{ #category : #adding }
ArrayedCollection >> add: anObject [
	^self shouldNotImplement
]

{ #category : #enumerating }
ArrayedCollection >> collect: aBlock [
	| array size |
	size := self size.
	array := self species new: size.
	1
		to: size
		do: [:index | array at: index put: (aBlock evaluateWith: (self at: index))].
	^array
]

{ #category : #enumerating }
ArrayedCollection >> collect: collectBlock thenSelect: selectBlock [
	| array size |
	array := OrderedCollection new: self size.
	self do: [:x | | fx |
		fx := collectBlock evaluateWith: x.
		(selectBlock evaluateWith: fx) ifTrue: [array add: fx]].
	size := array size.
	^(self species new: size) replaceFrom: 1 to: size with: array
]

{ #category : #services }
ArrayedCollection >> concurrentCollect: aBlock [
	| answer size token |
	size := self size.
	token := Object new.
	answer := self species new: size.
	answer atAllPut: token.
	1
		to: size
		do: [:index | [| x y |
			x := self at: index.
			y := aBlock evaluateWith: x.
			answer at: index put: y] forkThread launch].
	[answer includes: token] whileTrue: [].
	^answer
]

{ #category : #copying }
ArrayedCollection >> copyReplaceFrom: start to: stop with: aCollection [
	| copy n size |
	n := aCollection size.
	size := self size + n - (stop - start + 1).
	copy := self species new: size.
	^copy
		replaceFrom: 1 to: start - 1 with: self startingAt: 1;
		replaceFrom: start to: start + n - 1 with: aCollection;
		replaceFrom: start + n to: size with: self startingAt: stop + 1
]

{ #category : #copying }
ArrayedCollection >> deepCopy [
	^self objectDeepCopy
]

{ #category : #marshalling }
ByteArray >> largeAtOffset: offset [
	| integer lo hi |
	(self at: offset + 8) >= 16r80 ifTrue: [
		integer := 0.
		offset + 8
			to: offset + 1
			by: -1
			do: [:i | integer := (integer bitShift: 8) + ((self at: i) bitXor: 16rFF)].
		^(integer + 1) negated].
	lo := self uLongAtOffset: 0.
	hi := self uLongAtOffset: 4.
	^(hi bitShift: 32) + lo
]

{ #category : #marshalling }
ByteArray >> longAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self longAtValidOffset: offset
]

{ #category : #marshalling }
ByteArray >> longAtOffset: offset put: anInteger [
	| ulong |
	ulong := anInteger < 0
		ifTrue: [16r100000000 + anInteger]
		ifFalse: [anInteger].
	self uLongAtOffset: offset put: ulong
]

{ #category : #accessing }
ArrayedCollection >> longAtValidOffset: offset [
	| lo hi sign |
	lo := self uShortAtValidOffset: offset.
	hi := self uShortAtValidOffset: offset + 2.
	sign := hi bitAnd: 16r8000.
	hi := hi - (sign * 2).
	^hi * 16r10000 + lo
]

{ #category : #accessing }
ArrayedCollection >> pointerAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 7 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLargeAtValidOffset: offset
]

{ #category : #accessing }
ArrayedCollection >> pointerAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 7 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLargeAtValidOffset: offset put: anInteger
]

{ #category : #removing }
ArrayedCollection >> remove: anObject ifAbsent: aBlock [
	^self shouldNotImplement
]

{ #category : #accessing }
ArrayedCollection >> reversed [
	| limit result |
	limit := self size + 1.
	result := self species new: limit - 1.
	1 to: limit - 1 do: [:i | result at: i put: (self at: limit - i)].
	^result
]

{ #category : #enumerating }
ArrayedCollection >> select: aBlock [
	| size selected |
	size := self size.
	selected := OrderedCollection new: size.
	1 to: size do: [:i | | element |
		element := self at: i.
		(aBlock evaluateWith: element) ifTrue: [selected add: element]].
	size := selected size.
	^(self species new: size) replaceFrom: 1 to: size with: selected
]

{ #category : #enumerating }
ArrayedCollection >> select: selectBlock thenCollect: collectBlock [
	| size selected |
	size := self size.
	selected := OrderedCollection new: size.
	1 to: size do: [:i | | element |
		element := self at: i.
		(selectBlock evaluateWith: element)
			ifTrue: [selected add: (collectBlock evaluateWith: element)]].
	size := selected size.
	^(self species new: size) replaceFrom: 1 to: size with: selected
]

{ #category : #marshalling }
ByteArray >> shortAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 2 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self shortAtValidOffset: offset
]

{ #category : #accessing }
ArrayedCollection >> shortAtValidOffset: offset [
	| lo hi sign |
	lo := self byteAtValid: offset + 1.
	hi := self byteAtValid: offset + 2.
	sign := hi bitAnd: 16r80.
	hi := hi - (sign * 2).
	^hi * 16r100 + lo
]

{ #category : #accessing }
ArrayedCollection >> size [
	^self primitiveSize
]

{ #category : #printing }
ArrayedCollection >> storeOn: aStream [
	| size index firstTime |
	Recursion checkOn: self while: [
		self literalString ifNotNil: [:s | 
			aStream nextPutAll: s.
			^self].
		size := self size.
		size <= 7
			ifTrue: [
				size = 0 ifTrue: [aStream nextPutAll: '#()'] ifFalse: [
					aStream nextPutAll: '('; nextPutAll: self class name.
					self do: [:item | 
						aStream nextPutAll: ' with: '.
						item storeOn: aStream].
					aStream nextPut: $)]]
			ifFalse: [
				aStream
					nextPutAll: '((';
					nextPutAll: self class name;
					nextPutAll: ' new: '.
				size printOn: aStream.
				aStream nextPut: $).
				index := 1.
				firstTime := true.
				[index <= size] whileTrue: [
					firstTime ifFalse: [aStream nextPut: $;].
					firstTime := false.
					aStream nextPutAll: ' at: '.
					index printOn: aStream.
					aStream nextPutAll: ' put: '.
					(self at: index) storeOn: aStream.
					index := index + 1].
				firstTime ifFalse: [aStream nextPutAll: '; yourself'].
				aStream nextPut: $)]]
]

{ #category : #marshalling }
ArrayedCollection >> uLargeAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 7 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLargeAtValidOffset: offset
]

{ #category : #marshalling }
ArrayedCollection >> uLargeAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 7 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLargeAtValidOffset: offset put: anInteger
]

{ #category : #private }
ArrayedCollection >> uLargeAtValidOffset: offset [
	^(self _uLargeAtOffset: offset)
		ifNil: [self _uLargeAtOffset: offset into: (LargePositiveInteger new: 8)]
]

{ #category : #marshalling }
ArrayedCollection >> uLargeAtValidOffset: offset put: anInteger [
	anInteger size > 8 ifTrue: [self error: 'does not fit in 64 bits'].
	self _uLargeAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #marshalling }
ArrayedCollection >> uLongAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLongAtValidOffset: offset
]

{ #category : #unclassified }
ArrayedCollection >> uLongAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self _uLongAtValidOffset: offset put: anInteger
]

{ #category : #accessing }
ArrayedCollection >> uLongAtValidOffset: offset [
	^(self _uLongAtOffset: offset)
		ifNil: [self _uLongAtOffset: offset into: (LargePositiveInteger new: 4)]
]

{ #category : #accessing }
ArrayedCollection >> uLongAtValidOffset: offset put: anInteger [
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _uLongAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #marshalling }
ArrayedCollection >> uShortAtOffset: offset [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 1 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uShortAtValidOffset: offset
]

{ #category : #marshalling }
ArrayedCollection >> uShortAtOffset: offset put: anInteger [
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 1 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uShortAtValidOffset: offset put: anInteger
]

{ #category : #accessing }
ArrayedCollection >> uShortAtValidOffset: offset [
	^(self byteAtValid: offset + 2) * 16r100 + (self byteAtValid: offset + 1)
]

{ #category : #unclassified }
ArrayedCollection >> uShortAtValidOffset: offset put: anInteger [
	anInteger size > 2 ifTrue: [self error: 'does not fit in 16 bits'].
	self _uShortAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #accessing }
ArrayedCollection >> validShortAtValidOffset: offset put: anInteger [
	| hi lo |
	hi := anInteger bitShift: -8.
	lo := anInteger bitAnd: 16rFF.
	self
		_byteAt: offset + 1 put: lo;
		_byteAt: offset + 2 put: hi.
	^anInteger
]

{ #category : #enumerating }
ArrayedCollection >> withIndexCollect: aBlock [
	| answer size |
	size := self size.
	answer := self class new: size.
	1 to: size do: [:index |
		answer at: index put: (aBlock value: (self at: index) value: index)].
	^answer
]

