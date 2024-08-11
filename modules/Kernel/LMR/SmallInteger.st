"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRSmallInteger,
	#superclass : #SmallInteger,
	#category : #Kernel
}

{ #category : '*Primitives' }
LMRSmallInteger >> - aNumber [
	aNumber _isSmallInteger ifFalse: [^(aNumber - self) negated].	
	^(self _smiMinus: aNumber) ifNil: [self asLargeInteger - aNumber]
]

{ #category : '*Primitives' }
LMRSmallInteger >> != aNumber [
	aNumber _isSmallInteger ifFalse: [^aNumber != self].
	^(self == aNumber) not
]

{ #category : #arithmetic }
SmallInteger >> * aNumber [
	aNumber _isSmallInteger ifFalse: [^aNumber * self].
	(self _smiTimes: aNumber) ifNotNil: [:res | ^res].
	
	size := self sizeInBytes + aNumber sizeInBytes.
	result := self positive = aNumber positive
		ifTrue: [LargePositiveInteger new: size]
		ifFalse: [LargeNegativeInteger new: size].
	^(self _smiTimes: aNumber into: result) reduced
]

{ #category : '*Primitives' }
LMRSmallInteger >> // aNumber [
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #'//'].
	aNumber _isSmallInteger
		ifTrue: [
			result := self _quotientTowardZero: aNumber.
			^(self >= 0 = (aNumber >= 0) or: [result * aNumber = self])
				ifTrue: [result]
				ifFalse: [result - 1]]
		ifFalse: [
			aNumber isInteger
				ifTrue: [^self = 0 | (self positive = aNumber positive)
					ifTrue: [0]
					ifFalse: [-1]].
			quotient := self / aNumber.
			answer := quotient truncated.
			^(quotient < 0 and: [quotient != answer])
				ifTrue: [answer - 1]
				ifFalse: [answer]]
]

{ #category : #arithmetic }
LMRSmallInteger >> \\ aNumber [
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #'\\'].
	aNumber _isSmallInteger
		ifTrue: [^self _remainderTowardZero: aNumber]
		ifFalse: [
			aNumber isLargeInteger
				ifTrue: [aNumber positive == self positive ifTrue: [^self]].
			^super \\ aNumber]
]

{ #category : '*Primitives' }
LMRSmallInteger >> + aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self asLargeInteger + aNumber]
		ifFalse: [aNumber + self]
]

{ #category : #comparing }
LMRSmallInteger >> = aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiEquals: aNumber] 
		ifFalse: [aNumber = self]
]

{ #category : #comparing }
LMRSmallInteger >> > aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiGreaterThan: aNumber] 
		ifFalse: [aNumber < self]
]

{ #category : #comparing }
LMRSmallInteger >> >= aNumber [
	^aNumber _isSmallInteger
		ifTrue: [self _smiGreaterEqualThan: aNumber] 
		ifFalse: [aNumber <= self]
]

{ #category : #accessing }
LMRSmallInteger >> sizeInBytes [
	^self = 0
		ifTrue: [1]
		ifFalse: [WordSize - (self _leadingZeroBitCount _bitShiftRight: 3)]
]

