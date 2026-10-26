'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Message category: #Kernel!
Object subclass: #Message
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Message commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Message methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aMessage
	self == aMessage ifTrue: [^true].
	self class == aMessage class ifFalse: [^false].
	self selector == aMessage selector ifFalse: [^false].
	^self arguments = aMessage arguments
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentAt: anInteger
	^arguments at: anInteger
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
argumentAt: anInteger put: anObject
	arguments at: anInteger put: anObject
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arguments
	^arguments
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arguments: anArray
	arguments := anArray
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arity
	^selector isNil
		ifTrue: [arguments size]
		ifFalse: [selector arity]
! !

!Message methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
buildArguments: aCollection
	| predefined args |
	predefined := self arguments.
	aCollection size = predefined size ifTrue: [^aCollection].
	args := predefined isNil
		ifTrue: [Array new: selector arity]
		ifFalse: [predefined copy].
	^args
		replaceFrom: 1
		to: (aCollection size min: args size)
		with: aCollection
		startingAt: 1
! !

!Message methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^selector hashWith: arguments
! !

!Message methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMessage
	^true
! !

!Message methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
performOn: anObject
	^anObject perform: selector withArguments: arguments
! !

!Message methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: selector printString;
		nextPut: $)
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver
	^nil
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector
	^selector
! !

!Message methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector: aSymbol
	selector := aSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Message class' category: #Kernel!
Message class
	instanceVariableNames: ''!

!Message class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol
	| arguments |
	arguments := Array new: aSymbol arity.
	^self receiver: anObject selector: aSymbol arguments: arguments
! !

!Message class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol argument: anotherObject
	^self receiver: anObject selector: aSymbol arguments: {anotherObject}
! !

!Message class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol arguments: anArray
	^MessageSend new receiver: anObject selector: aSymbol arguments: anArray
! !

!Message class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector: aSymbol
	^self selector: aSymbol arguments: #()
! !

!Message class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector: aSymbol argument: anObject
	^self selector: aSymbol arguments: {anObject}
! !

!Message class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector: aSymbol arguments: anArray
	^self new selector: aSymbol; arguments: anArray
! !


