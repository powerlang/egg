'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #EventHandlerMessage category: #Kernel!
MessageSend subclass: #EventHandlerMessage
	instanceVariableNames: 'arity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!EventHandlerMessage commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!EventHandlerMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arity
	^arity
! !

!EventHandlerMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol arguments: anArray
	super receiver: anObject selector: aSymbol arguments: anArray.
	arity := selector arity.
	arguments size > arity ifTrue: [
		self
			error: 'The event expects no more than ' , arity asString
				, (' argument' pluralize: arity > 1)]
! !

!EventHandlerMessage methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
selector: aSymbol
	self ASSERT: false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EventHandlerMessage class' category: #Kernel!
EventHandlerMessage class
	instanceVariableNames: ''!

!EventHandlerMessage class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject selector: aSymbol
	^self new receiver: anObject; selector: aSymbol
! !


