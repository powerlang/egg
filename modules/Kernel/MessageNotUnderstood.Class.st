'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #MessageNotUnderstood category: #Kernel!
Error subclass: #MessageNotUnderstood
	instanceVariableNames: 'message receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!MessageNotUnderstood commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!MessageNotUnderstood methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultAction
	super defaultAction.
	^message performOn: receiver
! !

!MessageNotUnderstood methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultDescription
	| selector |
	message isNil ifTrue: [^super defaultDescription].
	selector := message selector ifNil: [^super defaultDescription].
	receiver isNil ifTrue: [^selector storeString , ' was sent to nil'].
	^selector storeString , ' not understood by ' , receiver printString
! !

!MessageNotUnderstood methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isResumable
	^message notNil and: [receiver respondsTo: message selector]
! !

!MessageNotUnderstood methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
message
	^message
! !

!MessageNotUnderstood methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
message: aMessage
	message := aMessage
! !

!MessageNotUnderstood methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: self class name withArticle.
	message ifNotNil: [
		aStream
			cr; nextPutAll: 'selector: '; print: message selector;
			cr; nextPutAll: 'arguments: '; print: message arguments].
	receiver ifNotNil: [
		aStream cr; nextPutAll: 'receiver: '; print: receiver].
	aStream cr.
! !

!MessageNotUnderstood methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver
	^receiver
! !

!MessageNotUnderstood methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject
	receiver := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MessageNotUnderstood class' category: #Kernel!
MessageNotUnderstood class
	instanceVariableNames: ''!

!MessageNotUnderstood class methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
message: aMessage
	^self new message: aMessage; signal
! !

!MessageNotUnderstood class methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
message: aMessage receiver: anObject
	^self new message: aMessage; receiver: anObject; signal
! !


