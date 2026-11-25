'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #ArrayEnvironment category: #'Powerlang-Core-SCompiler'!
LocalEnvironment subclass: #ArrayEnvironment
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!ArrayEnvironment methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureType
	^CaptureEnvironmentValue
! !

!ArrayEnvironment methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^index
! !

!ArrayEnvironment methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: anInteger
	index := anInteger
! !

!ArrayEnvironment methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCurrent
	^index isNil
! !

!ArrayEnvironment methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isIndirect
	^self isCurrent not
! !

!ArrayEnvironment methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isStack
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ArrayEnvironment class' category: #'Powerlang-Core-SCompiler'!
ArrayEnvironment class
	instanceVariableNames: ''!


