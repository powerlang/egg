'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #TemplateJIT category: #'Nativization-Tests'!
Object subclass: #TemplateJIT
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization-Tests'!
!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativize: aCompiledMethod
	^ NativizationEnvironment forTesting newTemplateJIT
		nativize: aCompiledMethod
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyFor: aCompiledMethod
	^ NativizationEnvironment forTesting
		newTemplateJIT nativize: aCompiledMethod
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForBlock
	^self assemblyForSource: 'foo [1] value'
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForIfTrue
	^self assemblyForSource: 'foo x ifTrue: [1]' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForMessage
	^self assemblyForSource: 'foo self bar'
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForMessageCascade
	^self assemblyForSource: 'foo self bar; baz'
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForMethod: aCompiledMethod

^	self
		assemblyForSource: aCompiledMethod sourceCode
		in: aCompiledMethod classBinding value.

! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_1_plus_y
	^self assemblyForSource: 'foo 1 + y' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_ret_x_eq_1
	^ self assemblyForSource: 'foo ^x = 1' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_x
	^ self assemblyForMethod: Point >> #x
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_x_eq_1
	^self assemblyForSource: 'foo x = 1' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_x_eq_eq_1
	^self assemblyForSource: 'foo x == 1' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_x_plus_1
	^self assemblyForSource: 'foo x + 1' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForPoint_x_plus_y
	^self assemblyForSource: 'foo x + y' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForSource: aString
	^self assemblyForSource: aString in: UndefinedObject
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForSource: aString in: aSpecies
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self assemblyFor: method
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForSourceOrig: aString
	^self assemblyForSourceOrig: aString in: UndefinedObject
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForSourceOrig: aString in: aSpecies
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self assemblyOrigFor: method
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyForWhileTrue
	^self assemblyForSource: 'foo [x := x + 1. true] whileTrue' in: Point
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemblyOrigFor: aCompiledMethod
	^ NativizationEnvironment forTesting nativize:
		  aCompiledMethod
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodBasicAdd
	| source |
	source := 'basicAdd: anObject
	end = contents size ifTrue: [self makeRoomBehind].
	end := end + 1.
	contents at: end put: anObject.
	^anObject'.
	^self methodForSource: source in: OrderedCollection
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodForSource: aString
	^self methodForSource: aString in: UndefinedObject
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodForSource: aString in: aSpecies
	| method |
	method := SCompiler compile: aString in: aSpecies.
	^self nativize: method
! !

!TemplateJITTest methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodWithBlock
	^self methodForSource: 'foo [1] value'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TemplateJIT class' category: #'Nativization-Tests'!
TemplateJIT class
	instanceVariableNames: ''!


