'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LMRClosure category: #Kernel!
Closure subclass: #LMRClosure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LMRClosure commentStamp: '<historical>' prior: 0!

	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateAtomically
	| enabled |
	enabled := Processor enableInterrupts: false.
	^self ensure: [Processor enableInterrupts: enabled]
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: value
	block argumentCount = 1 ifFalse: [^self arityError: 1].
	self _transferControlTo: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateWith: anObject with: anotherObject
	block argumentCount = 2
		ifFalse: [^super evaluateWith: anObject with: anotherObject].
	self _transferControlTo: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value
	block argumentCount = 0 ifFalse: [^self arityError: 0].
	self _transferControlTo: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: first
	block argumentCount = 1 ifFalse: [^self arityError: 1].
	self _transferControlTo: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: first value: second
	block argumentCount = 2 ifFalse: [^self arityError: 2].
	self _transferControlTo: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: first value: second value: third
	block argumentCount = 3 ifFalse: [^self arityError: 3].
	self _transferControlTo: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
valueWithArguments: arguments
	| size |
	size := arguments basicSize.
	block argumentCount = size ifFalse: [^self arityError: size].
	arguments _expandInStackSized: size.
	^self _invoke: block blockNativeCode
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileFalse: aBlock
	self value ifTrue: [^nil].
	aBlock value.
	self _restart
! !

!LMRClosure methodsFor:  '*handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
whileTrue: aBlock
	self value ifFalse: [^nil].
	aBlock value.
	self _restart
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LMRClosure class' category: #Kernel!
LMRClosure class
	instanceVariableNames: ''!


