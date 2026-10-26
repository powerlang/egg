'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Recursion category: #Kernel!
Error subclass: #Recursion
	instanceVariableNames: 'object'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Recursion commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!Recursion methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
description
	^'recursive structure found at ' , object class name withArticle
! !

!Recursion methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalOn: anObject
	object := anObject.
	^self signal
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Recursion class' category: #Kernel!
Recursion class
	instanceVariableNames: ''!

!Recursion class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
check: anObject in: aSet while: aBlock
	^(aSet includes: anObject) ifTrue: [self signalOn: anObject] ifFalse: [
		aSet add: anObject.
		aBlock ensure: [aSet remove: anObject]]
! !

!Recursion class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
checkOn: anObject while: aBlock
	^self check: anObject in: Recursion recursionSet while: aBlock
! !

!Recursion class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
checkOn: anObject while: aBlock onSignal: exceptionBlock
	| set |
	set := Recursion recursionSet.
	^[self check: anObject in: set while: aBlock] on: self do: exceptionBlock
! !

!Recursion class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
recursionSet
	| handler set |
	handler := Processor activeProcess.
	[
		handler := handler notNil ifTrue: [handler findHandlerFor: self new].
		handler notNil
			ifTrue: [set := handler propertyAt: #recursionSet ifAbsent: nil].
		handler notNil and: [set isNil]]
		whileTrue: [handler := handler nextHandler].
	^set ifNil: [
		Processor activeProcess exceptionHandler
			propertyAt: #recursionSet
			ifAbsentPut: [IdentitySet new]]
! !

!Recursion class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
signalOn: anObject
	^self new signalOn: anObject
! !


