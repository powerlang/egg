'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Context category: #Kernel!
Object subclass: #Context
	instanceVariableNames: 'caller callee code pc receiver stack environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Context commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
arguments
	size := code argumentCount.
	size = 0 ifTrue: [^#()].
	^caller stackTop: size 
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
callee
	^callee
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
callee: aContext
	callee := aContext
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
caller
	^caller
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
caller: aContext
	caller := aContext
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
code
	^code
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
code: anExecutableCode method: aCompiledMethod
	| temps |
"	code := anExecutableCode."
	code := aCompiledMethod.
	temps := aCompiledMethod tempCount.
	stack := OrderedCollection new: temps + 5.
	stack stretchTo: temps.
	aCompiledMethod hasEnvironment 
		ifTrue: [environment := Array new: aCompiledMethod environmentCount].
	pc := 0.
! !

!Context methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyAllTo: aProcessStack
	| start |
	start := caller copyAllTo: aProcessStack.
	^self copyTo: aProcessStack at: start
! !

!Context methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyEnvironmentTo: aProcessStack at: start
	"environment ifNil: [^2]."
	aProcessStack
		at: start - 2 put: self previousEnvironment;
		at: start - 3 put: environment.
	^4
! !

!Context methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyTo: aProcessStack at: start
	| delta |
	aProcessStack
		at: start put: receiver;
		at: start - 1 put: code.

	delta := self copyEnvironmentTo: aProcessStack at: start.

	stack do: [:temp |
		aProcessStack at: start - delta put: temp.
		delta := delta + 1 ].
	
	aProcessStack
		pcAt: start - delta put: pc of: code;
		bpAt: start - delta - 1 put: start + 1.

	^start - delta - 2
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
environment
	^environment
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
environment: anObject
	"The environment can be either nil (default), an array or a closure"
	environment := anObject
! !

!Context methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
lastEnvironment
	"environment ifNotNil: [^environment].
	^caller ifNotNil: [caller lastEnvironment]"
	^environment
! !

!Context methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
previousEnvironment
	^caller lastEnvironment
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
receiver: anObject
	receiver := anObject
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
stack
	^stack
! !

!Context methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
stackTop: anInteger
	^stack last: anInteger
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempAt: anInteger
	^stack at: anInteger
! !

!Context methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tempAt: anInteger put: anObject
	^stack at: anInteger put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Context class' category: #Kernel!
Context class
	instanceVariableNames: ''!


