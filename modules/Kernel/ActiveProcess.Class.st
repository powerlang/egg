'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ActiveProcess category: #Kernel!
Process subclass: #ActiveProcess
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ActiveProcess commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
backtrace
	^self reifiedCopy backtrace
! !

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
beInactive
	self changeClassTo: SuspendedProcess
! !

!ActiveProcess methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isActive
	^true
! !

!ActiveProcess methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
canReturnTo: homeFrame

	| method env |
	homeFrame == nil ifTrue: [^false].
	homeFrame < self nativeStack bp ifTrue: [^false].
	^true
	"method := self codeAt: homeFrame.
	homeFrame hasBlocks ifFalse: [^false].
	env := self methodEnvironment.
	homeFrame environment == env ifTrue: [^true].
	^homeFrame methodEnvironment == env"
! !

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
drop
	"
		Suspend this process without saving current state (if resumed the last resumption point will be used)
	"

	Processor dropActive
! !

!ActiveProcess methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluate: aClosure ensuring: ensuredClosure
	"
	Ensure is easy: when the closure is being evaluated, the only way to skip
	the ensuredClosure would be through a non-local return, so we can delegate
	ensure mechanism to the code that does non-local returns.
	The non-local returns check for protected frames, evaluate all of them
	between return source and home frames, and then does the unwinding.
	The local `cursor` is needed-by and special-to the debugger, because it might
	have to update the frame indices if the stack frames are changed.
	"
	| cursor result prev |
	cursor := self nativeStack bp.
	protectedFrames push: cursor.
	result := aClosure value.
	prev := protectedFrames pop.
	prev == cursor
		ifFalse: [self
			_error: 'protected frame popped is not the same that was pushed originally'].
	ensuredClosure value.
	^result
! !

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluateEnsuredUpTo: framePointer
	"
	Marked as atomic because the protected frames are removed on
	denativization and recreated on nativization, so stepping through the
	loop in this method could have undesired consequences.
	Ensured closure is the argument to the evaluate:ensuring: method, which protectedFrames
	point to.
	"
	| ensured |
	#atomic.
	[
		protectedFrames notEmpty and: [protectedFrames last <= framePointer]]
			whileTrue: [
				ensured := self nativeStack lastArgumentOf: protectedFrames pop.
				ensured value].
! !

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
launch: aMessage
	exceptionHandler := nil.
	aMessage evaluate.
	self drop; ASSERT: false
! !

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nonLocalReturn: anObject home: framePointer
	"
		The home frame of closure is the start of the chain (might be another
		cloure). We look for the method frame, evaluate any protected blocks
		in the way and return.

		We assume homeFrame is a valid index, which is guaranteed because:
		- it is captured in the active process
		- it is niled out when putting the process to sleep
		- it is refreshed when process is reactivated
	"
	(self canReturnTo: framePointer) 
		ifFalse: [self error: 'cannot return to a frame outside current stack chunk'].

	self evaluateEnsuredUpTo: framePointer.
	^anObject _returnTo: framePointer
! !

!ActiveProcess methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
snapshot
	"
		Saves current state to allow resuming later
	"
	^self nativeStack snapshot
! !

!ActiveProcess methodsFor:  'unassigned' stamp: 'KenD 28/Jun/2026 13:27:38'!
useExceptionHandler: anExceptionHandler while: aBlock
	| handler |
	handler := exceptionHandler.
	exceptionHandler := anExceptionHandler.
	^aBlock ensure: [exceptionHandler := handler]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ActiveProcess class' category: #Kernel!
ActiveProcess class
	instanceVariableNames: ''!


