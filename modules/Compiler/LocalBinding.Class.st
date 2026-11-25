'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #LocalBinding category: #'Powerlang-Core-SCompiler-Bindings'!
Binding subclass: #LocalBinding
	instanceVariableNames: 'index environment declaration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Bindings'!
!LocalBinding methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:40'!
beInArray
	environment := ArrayEnvironment new
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
declaration
	^declaration
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
declaration: anIdentifierNode
	declaration := anIdentifierNode
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environment
	^environment index
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentIndex
	^environment index
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentIndex: anInteger
	environment index: anInteger
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentObject
	^environment
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentCaptureType
	^environment captureType
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index
	^index
! !

!LocalBinding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
index: aNumber
	index := aNumber
! !

!LocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInArray
	^self isInStack not
! !

!LocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isInStack
	^environment isStack
! !

!LocalBinding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isLocal
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LocalBinding class' category: #'Powerlang-Core-SCompiler-Bindings'!
LocalBinding class
	instanceVariableNames: ''!


