'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #CompilerModule category: #'Powerlang-Core-LMR'!
Module subclass: #CompilerModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-LMR'!
!CompilerModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
!

!CompilerModule methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	TreecodeEncoder initializeBindingIds; initializeTreecodeIds.
	self initializeClosureElementIds
! !

!CompilerModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#Kernel -> #(Error ByteArray CompiledBlock Module NumberParser Species OrderedDictionary)
	}
! !

!CompilerModule methodsFor:  'class initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeClosureElementIds
	self namespace
		at: #CaptureSelf put: 0;
		at: #CaptureLocalArgument put: 1;
		at: #CaptureEnvironment put: 2;
		at: #CaptureEnvironmentValue put: 3;
		at: #CaptureInlinedArgument put: 4
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CompilerModule class' category: #'Powerlang-Core-LMR'!
CompilerModule class
	instanceVariableNames: ''!


CompilerModule initialize!

