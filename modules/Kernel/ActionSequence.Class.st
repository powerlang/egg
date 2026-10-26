'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ActionSequence category: #Kernel!
Array subclass: #ActionSequence
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ActionSequence commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ActionSequence methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
& anActionSequence
	^anActionSequence notNil ifTrue: [self , anActionSequence] ifFalse: [self]
! !

!ActionSequence methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
&& anObject
	^anObject notNil ifTrue: [self copyWith: anObject]
! !

!ActionSequence methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asActionSequence
	^self
! !

!ActionSequence methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asArray
	| array |
	array := Array new: self size.
	self withIndexDo: [:ai :i | array at: i put: ai].
	^array
! !

!ActionSequence methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
compressed
	^self isEmpty ifFalse: [self size = 1 ifTrue: [self first] ifFalse: [self]]
! !

!ActionSequence methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluate
	| value |
	self do: [:action | value := action evaluate].
	^value
! !

!ActionSequence methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWithArguments: anArray
	| value |
	self do: [:action | value := action evaluateWithArguments: anArray].
	^value
! !

!ActionSequence methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPutAll: self class name; space.
	super printOn: aStream
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ActionSequence class' category: #Kernel!
ActionSequence class
	instanceVariableNames: ''!


