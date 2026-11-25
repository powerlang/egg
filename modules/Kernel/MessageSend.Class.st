'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #MessageSend category: #Kernel!
Message subclass: #MessageSend
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!MessageSend commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MessageSend methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aMessage
	super = aMessage ifFalse: [^false].
	^self receiver == aMessage receiver
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluate
	^self perform
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateFor: anObject
	^self evaluateWithArguments: {anObject}
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: argObject
	^selector arity = 1
		ifTrue: [receiver perform: selector with: argObject]
		ifFalse: [super evaluateWith: argObject]
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWithArguments: anArray
	| args |
	args := self buildArguments: anArray.
	^receiver perform: selector withArguments: args
! !

!MessageSend methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^receiver hashWith: selector with: arguments
! !

!MessageSend methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
newProcess
	^Process new evaluating: self
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
perform
	^self performOn: receiver
! !

!MessageSend methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: receiver class printString;
		nextPutAll: '>>';
		nextPutAll: selector printString;
		nextPut: $)
! !

!MessageSend methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver
	^receiver
! !

!MessageSend methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject
	receiver := anObject
! !

!MessageSend methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol arguments: anArray
	receiver := anObject.
	selector := aSymbol.
	arguments := anArray
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
value
	^self perform
! !

!MessageSend methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: value1 value: value2
	arguments
		at: 1 put: value1;
		at: 2 put: value2.
	^self perform
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MessageSend class' category: #Kernel!
MessageSend class
	instanceVariableNames: ''!

!MessageSend class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol arguments: anArray
	^self new receiver: anObject selector: aSymbol arguments: anArray
! !


