'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SCompilationError category: #'Powerlang-Core-SCompiler'!
Error subclass: #SCompilationError
	instanceVariableNames: 'compiler resumable retryable stretch'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beFatal
	resumable := retryable := false
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beResumable
	resumable := true
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
beWarning
	resumable := true
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler
	^compiler
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compiler: aCompiler
	compiler := aCompiler.
	compiler result error: self
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
description: aString
	description := aString
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isResumable
	^resumable

! !

!SCompilationError methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isUndeclaredAccess
	^false
! !

!SCompilationError methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isUndeclaredAssignment
	^ false
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
proceed
	retryable := false.
	compiler result beSuccessful.
	self isResumable ifTrue: [ self resume ] ifFalse: [ self return ]
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
source
	^compiler sourceCode copyFrom: stretch start to: stretch end
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stretch
	^stretch
! !

!SCompilationError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
stretch: aStretch
	stretch := aStretch
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCompilationError class' category: #'Powerlang-Core-SCompiler'!
SCompilationError class
	instanceVariableNames: ''!


