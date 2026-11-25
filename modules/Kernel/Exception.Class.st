'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Exception category: #Kernel!
Object subclass: #Exception
	instanceVariableNames: 'description activeHandler signalContext resumeBlock resignaledException'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Exception commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Exception methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
activeHandler
	^activeHandler
! !

!Exception methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
activeHandler: anExceptionHandler
	activeHandler := anExceptionHandler
! !

!Exception methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
defaultAction
	Kernel unhandledException: self
! !

!Exception methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
defaultDescription
	^self class name
! !

!Exception methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
defaultValue
	^nil
! !

!Exception methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
description
	^description ifNil: [self defaultDescription]
! !

!Exception methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
description: aString
	description := aString
! !

!Exception methodsFor:  'process flow' stamp: 'KenD 28/Jun/2026 13:27:39'!
doDefaultAction
	^self defaultAction
! !

!Exception methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:39'!
doSignal
	self isActive ifTrue: [^self ASSERT: false].
	signalContext := Processor activeProcess.
	^self outer
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
evaluateHandler: anExceptionHandler
	| prev result |
	prev := activeHandler.
	activeHandler := anExceptionHandler.
	[
		result := anExceptionHandler isNil
			ifTrue: [self doDefaultAction]
			ifFalse: [anExceptionHandler handle: self]]
		ensure: [activeHandler := prev].
	^result
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
evaluateHandlers
	| handler |
	handler := Processor activeProcess findHandlerFor: self.
	^self evaluateHandler: handler
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
exit
	self exit: self defaultValue
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
exit: value
	self isResumable ifTrue: [self resume: value] ifFalse: [self return: value]
! !

!Exception methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasNextHandler
	^self nextHandler notNil
! !

!Exception methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isActive
	^activeHandler notNil
! !

!Exception methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isHandled
	| handler |
	handler := Processor activeProcess findHandlerFor: self.
	^handler notNil
! !

!Exception methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isResumable
	^true
! !

!Exception methodsFor:  'process flow' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextHandler
	^activeHandler notNil ifTrue: [activeHandler nextHandlerFor: self]
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
outer
	| prev result |
	prev := resumeBlock.
	[
		resumeBlock := [:res | ^res].
		result := self evaluateHandlers]
		ensure: [resumeBlock := prev].
	^result
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
pass
	self resume: self evaluateHandlers
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	activeHandler := signalContext := nil
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
resignal
	self resignalAs: self shallowCopy reset
! !

!Exception methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:39'!
resignalAs: anException
	resignaledException := anException.
	self resume: nil
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
resume
	self resume: self defaultValue
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
resume: value
	self isResumable
		ifFalse: [Error signal: 'cannot resume from a non-resumable exception'].
	resumeBlock value: value
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
retry
	activeHandler retry
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
retryUsing: aBlock
	activeHandler retryUsing: aBlock
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
return
	self return: self defaultValue
! !

!Exception methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:27:39'!
return: value
	signalContext := nil.
	activeHandler return: value
! !

!Exception methodsFor:  'signaling' stamp: 'KenD 28/Jun/2026 13:27:39'!
signal
	| signaller result |
	signaller := self.
	[signaller notNil] whileTrue: [
		resignaledException := nil.
		result := signaller doSignal.
		signaller := resignaledException].
	^result
! !

!Exception methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
stacktrace
	^signalContext backtrace.
! !

!Exception methodsFor:  'sunit' stamp: 'KenD 28/Jun/2026 13:27:39'!
sunitRetry
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Exception class' category: #Kernel!
Exception class
	instanceVariableNames: ''!

!Exception class methodsFor:  'composition' stamp: 'KenD 28/Jun/2026 13:27:39'!
, aClass
	^ExceptionSet with: self with: aClass
! !

!Exception class methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
includesException: anException
	^anException isKindOf: self
! !

!Exception class methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
isHandled
	^self basicNew isHandled
! !

!Exception class methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldBeHidden: aSymbol
	^#(#pass #signal) includes: aSymbol
! !

!Exception class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
signal
	^self new signal
! !

!Exception class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
signal: aString
	^self new description: aString; signal
! !


