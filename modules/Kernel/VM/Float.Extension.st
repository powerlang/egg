'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!


!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	<primitive: FloatMinus>
	^aNumber isFloat
		ifTrue: [self errorOn: #'-']
		ifFalse: [self - aNumber asFloat]
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	<primitive: FloatMultiply>
	^aNumber isFloat
		ifTrue: [self errorOn: #'*']
		ifFalse: [self * aNumber asFloat]

! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	<primitive: FloatDiv>
	^aNumber isFloat
		ifTrue: [self errorOn: #'/']
		ifFalse: [self / aNumber asFloat]
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	<primitive: FloatPlus>
	^aNumber isFloat
		ifTrue: [ self errorOn: #'+']
		ifFalse: [aNumber addTo: self]
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aNumber
	<primitive: FloatLess>
	^aNumber isFloat
		ifTrue: [self errorOn: #'<']
		ifFalse: [self < aNumber asFloat]
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
	| nan status |
	<primitive: FloatEqual>
	^aNumber isFloat
		ifTrue: [
			status := Float status.
			nan := self isNaN.
			(nan and: [aNumber isNaN]) ifTrue: [^true].
			(nan or: [aNumber isNaN]) ifTrue: [^false].
			self errorOn: #'=' status: status]
		ifFalse: [aNumber isNumber
			ifTrue: [self = aNumber asFloat]
			ifFalse: [false]]
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	<primitive: At>
	^self primitiveFailed
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: index
	<primitive: At>
	^self primitiveFailed
! !

!Float methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorOn: aSymbol
	^self errorOn: aSymbol status: Float status
! !

!Float methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
fractionPart
	<primitive: FloatFractionPart>
	self errorOn: #fractionPart
! !

!Float methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeWith: bytes
	self replaceBytesFrom: 1 to: 8 with: bytes startingAt: 1
! !

!Float methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
significand
	<primitive: FloatSignificand>
	^self errorOn: #significand
! !

!Float methodsFor:  'functions' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrt
	<primitive: FloatSqrt>
	^self errorOn: #sqrt status: status
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
timesTwoPower: anInteger
	<primitive: FloatTimesTwoPower>
	^self errorOn: #timesTwoPower status: 0
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
	<primitive: FloatTruncated>
	^self errorOn: #truncated status: 0
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromInteger: anInteger
	<primitive: FloatNewFromInteger>
! !

!Float class methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	<primitive: FloatNew>
! !

!Float class methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
status
	" Returns the processor's float status register of the last primitive operation "
	<primitive: FloatStatus>
! !


