"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ActiveProcess,
	#superclass : #Process,
	#category : #Kernel
}

{ #category : #private }
ActiveProcess >> backtrace [
	^self reifiedCopy backtrace
]

{ #category : #private }
ActiveProcess >> beInactive [
	self changeClassTo: SuspendedProcess
]

{ #category : #private }
ActiveProcess >> drop [
	"
		Suspend this process without saving current state (if resumed the last resumption point will be used)
	"

	Processor dropActive
]

{ #category : #services }
ActiveProcess >> evaluate: aClosure ensuring: ensuredClosure [
	"
	Ensure is easy: when the closure is being evaluated, the only way to skip
	the ensuredBlock would be through a non-local return, so we can delegate
	ensure mechanism to the code that does non-local returns.
	The non-local returns check for protected frames, evaluate all of them
	between return source and home frames, and then does the unwinding.
	The local `cursor` is needed-by and special-to the debugger, because it might
	have to update the frame indices if the stack frames are changed.
	"
	| cursor result prev |
	cursor := nativeStack currentBP.
	protectedFrames push: cursor.
	result := aBlock value.
	prev := protectedFrames pop.
	prev == cursor
		ifFalse: [self
			_error: 'protected frame popped is not the same that was pushed originally'].
	ensuredBlock value.
	^result
]

{ #category : #private }
ActiveProcess >> launch: aMessage [
	exceptionHandler := nil.
	aMessage evaluate.
	self drop; ASSERT: false
]

{ #category : #private }
ActiveProcess >> suspend [
	"
		Saves current state to allow resuming later
	"
	self shouldBeImplemented
]

ActiveProcess >> useExceptionHandler: anExceptionHandler while: aBlock [
	| handler |
	handler := exceptionHandler.
	exceptionHandler := anExceptionHandler.
	^aBlock ensure: [exceptionHandler := handler]
]


