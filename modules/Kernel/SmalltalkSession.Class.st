'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #SmalltalkSession category: #Kernel!
Object subclass: #SmalltalkSession
	instanceVariableNames: 'name username args resources finalizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
args
	^args
! !

!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
args: anArray
	args := anArray
! !

!SmalltalkSession methodsFor:  'startup/shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
closeExternalResources
	resources do: [:object | object sessionShutdown]
! !

!SmalltalkSession methodsFor:  'startup/shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
ephemeronsDo: aBlock
	resources ephemeronsDo: aBlock.
	finalizer ephemeronsDo: aBlock.
! !

!SmalltalkSession methodsFor:  'shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
exit: code
	[self shutdown] ensure: [Kernel host exit: code]
! !

!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalizer
	^finalizer
! !

!SmalltalkSession methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	name := 'egg session'.
	finalizer := WeakIdentitySet new.
	resources := WeakIdentitySet new
! !

!SmalltalkSession methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeFinalizationBlocks
	finalizer finalizer: [:object | object finalize].
	resources finalizer: [:object | object finalize]
! !

!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^name
! !

!SmalltalkSession methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
rehashWeakRegistries
	resources rehash.
	finalizer rehash
! !

!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
resourceRegistry
	^resources
! !

!SmalltalkSession methodsFor:  'startup/shutdown' stamp: 'KenD 28/Jun/2026 13:27:38'!
startUp
	self initializeFinalizationBlocks.
	resources do: [:object | object sessionStartup]
! !

!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
username
	^username
! !

!SmalltalkSession methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
username: aString
	username := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SmalltalkSession class' category: #Kernel!
SmalltalkSession class
	instanceVariableNames: ''!


SmalltalkSession initialize!

