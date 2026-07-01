'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #BlockScope category: #'Powerlang-Core-SCompiler'!
ScriptScope subclass: #BlockScope
	instanceVariableNames: 'environments captured'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!BlockScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureArgument: anArgumentBinding
	| name |
	name := anArgumentBinding name.
	^captured at: name ifAbsentPut: [| transferred copy |
		transferred := self parent transferLocal: name.
		copy := self copyLocal: transferred.
		copy declaration: transferred declaration]
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureEnvironment: aScriptNode
	script == aScriptNode ifTrue: [^self].
	(environments includesIdentical: aScriptNode) ifTrue: [^self].
	self realParent captureEnvironment: aScriptNode.
	aScriptNode isMethod
		ifTrue: [environments addFirst: aScriptNode]
		ifFalse: [environments addLast: aScriptNode]
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureLocal: aLocalBinding
	(self defines: aLocalBinding name) ifTrue: [^aLocalBinding].
	^aLocalBinding isTemporary
		ifTrue: [self captureTemporary: aLocalBinding]
		ifFalse: [self captureArgument: aLocalBinding]
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureSelf
	captureSelf ifTrue: [^self].
	captureSelf := true.
	self parent captureSelf
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureTemporary: aTemporaryBinding
	| name |
	name := aTemporaryBinding name.
	(self defines: name) ifTrue: [^aTemporaryBinding].
	^captured at: name ifAbsentPut: [| parent declaration transferred copy |
		parent := self parent.
		declaration := parent scriptDefining: name.
		self realScope captureEnvironment: declaration realScript.
		transferred := parent transferLocal: name.
		copy := self copyLocal: transferred.
		copy isInArray ifTrue: [aTemporaryBinding beInArray].
		copy declaration: transferred declaration]
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
capturedArguments
	^captured select: [:b | b isArgument]
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
capturedEnvironmentIndexOf: aScriptNode
	| index |
	aScriptNode realScript == script realScript
		ifTrue: [ ^ nil ].
	index := environments indexOf: aScriptNode ifAbsent: nil.
	self ASSERT: index notNil.
	^self capturesSelf ifTrue: [ index + 1 ] ifFalse: [ index ]
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
capturedEnvironments
	^environments
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
capturesHome
	^self home notNil
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
copyLocal: binding
	^script isInlined ifTrue: [binding] ifFalse: [binding copy beInArray]
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentIndexOf: aScriptNode
	"
	temporal compatibility
	"
	(aScriptNode isKindOf: SScriptNode)
		ifFalse: [ self ASSERT: false. ^nil ].
	^self capturedEnvironmentIndexOf: aScriptNode
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentSizeUpToCapturedArguments
	^self environmentSizeUpToEnvironments + self capturedArguments size
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentSizeUpToEnvironments
	| receiver |
	receiver := self capturesSelf ifTrue: [ 1 ] ifFalse: [ 0 ].
	^receiver + environments size
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
environments
	"
	compatibility, removes the home environment
	"
	| first |
	environments isEmpty ifTrue: [^#()].
	first := environments first.
	^first isMethod ifTrue: [environments allButFirst] ifFalse: [environments]
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
home
	| first |
	environments isEmpty ifTrue: [^nil].
	first := environments first.
	^first isMethod ifTrue: [first]
! !

!BlockScope methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	captured := StaticBinder new.
	environments := OrderedCollection new
! !

!BlockScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
localBindings
	^super localBindings , captured values
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
parent
	^script parent scope
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionCapturedArgument: anArgumentBinding
	anArgumentBinding index: self growEnvironment
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionCapturedLocals
	script isInlined ifTrue: [^self].
	envSize := self environmentSizeUpToEnvironments.
	captured do: [:binding | 
		binding isArgument
			ifTrue: [self positionCapturedArgument: binding]
			ifFalse: [self positionCapturedTemporary: binding]]
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionCapturedTemporary: aTemporaryBinding
	| outest index declaration |
	outest := self scriptDefining: aTemporaryBinding name.
	index := self capturedEnvironmentIndexOf: outest realScript.
	aTemporaryBinding environmentIndex: index.
	declaration := outest scope resolve: aTemporaryBinding name.
	self ASSERT: declaration index isInteger.
	aTemporaryBinding index: declaration index
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionDefinedArgumentsIn: aScriptScope
	arguments do: [:binding | | index |
		index := binding isInArray
			ifTrue: [aScriptScope growEnvironment]
			ifFalse: [aScriptScope growStack].
		binding index: index]
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionDefinedLocals
	| real |
	script isInlined
		ifTrue: [
			real := self realScope.
			self
				positionDefinedTemporariesIn: real;
				positionDefinedArgumentsIn: real]
		ifFalse: [super positionDefinedLocals]
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
positionLocals
	self positionCapturedLocals.
	super positionLocals
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
realParent
	^script realParent scope
! !

!BlockScope methodsFor:  'binding' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolve: aString
	(self resolveLocal: aString) ifNotNil: [:binding | ^binding].
	^self parent resolve: aString
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolveLocal: aString
	(super resolveLocal: aString) ifNotNil: [:binding | ^binding].
	^captured at: aString
! !

!BlockScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
scriptDefining: aString
	(self defines: aString) ifTrue: [^script].
	^self parent scriptDefining: aString
! !

!BlockScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
transferLocal: name
	| binding copy |
	(self resolveLocal: name) ifNotNil: [:b | ^b].
	binding := self parent transferLocal: name.
	copy := self copyLocal: binding.
	captured at: name put: copy.
	^copy
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockScope class' category: #'Powerlang-Core-SCompiler'!
BlockScope class
	instanceVariableNames: ''!


BlockScope initialize!

