'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPRepeatingParser category: #Parsers!
PPDelegateParser subclass: #PPRepeatingParser
	instanceVariableNames: 'min max'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPRepeatingParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPRepeatingParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPlus
	^min = 1 and: [max = SmallInteger maximum]
! !

!PPRepeatingParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStar
	^min = 0 and: [max = SmallInteger maximum]
! !

!PPRepeatingParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
max
	"Answer the maximum number of repetitions."

	^ max
! !

!PPRepeatingParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
min
	"Answer the minimum number of repetitions."

	^ min
! !

!PPRepeatingParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| start element elements |
	start := aStream position.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure ifTrue: [
			aStream position: start.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
		(element := parser parseOn: aStream) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray
! !

!PPRepeatingParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	self name ifNotNil: [^self printNameOn: aStream].
	aStream nextPut: $(.
	parser printOn: aStream.
	aStream nextPutAll: ') '.
	self isStar ifTrue: [^aStream nextPutAll: 'star'].
	self isPlus ifTrue: [^aStream nextPutAll: 'plus'].
	aStream
		nextPutAll: ' [';
		print: min;
		nextPutAll: ', ';
		nextPutAll: (max = SmallInteger maximum
			ifTrue: ['*']
			ifFalse: [max printString]);
		nextPut: $]
! !

!PPRepeatingParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	| stop |
	self name ifNotNil: [^self printNameOn: rtf].
	parser printSmalltalkReceiverOn: rtf.
	self isStar ifTrue: [^rtf nextPutAll: ' star'].
	self isPlus ifTrue: [^rtf nextPutAll: ' plus'].
	stop := max = SmallInteger maximum ifTrue: ['*'] ifFalse: [max printString].
	rtf
		nextPutAll: ' rep [';
		print: min;
		nextPutAll: ', ';
		nextPutAll: stop;
		nextPut: $]
! !

!PPRepeatingParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setMin: aMinInteger max: aMaxInteger
	min := aMinInteger.
	max := aMaxInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPRepeatingParser class' category: #Parsers!
PPRepeatingParser class
	instanceVariableNames: ''!

!PPRepeatingParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser
	^(super on: aParser) setMin: 0 max: SmallInteger maximum
! !

!PPRepeatingParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser max: aMaxInteger
	^ (self on: aParser) setMin: 0 max: aMaxInteger
! !

!PPRepeatingParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser min: aMinInteger
	^(self on: aParser) setMin: aMinInteger max: SmallInteger maximum
! !

!PPRepeatingParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser min: aMinInteger max: aMaxInteger
	^ (self on: aParser) setMin: aMinInteger max: aMaxInteger
! !


