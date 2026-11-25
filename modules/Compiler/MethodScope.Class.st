'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #MethodScope category: #'Powerlang-Core-SCompiler'!
ScriptScope subclass: #MethodScope
	instanceVariableNames: 'pseudo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler'!
!MethodScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureEnvironment: aScriptNode
	self ASSERT: aScriptNode == script
! !

!MethodScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureLocal: aLocalBinding
	self ASSERT: (self resolveLocal: aLocalBinding name) notNil.
	^aLocalBinding
! !

!MethodScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
captureSelf
	captureSelf := true.

! !

!MethodScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
environmentIndexOf: aScriptNode
	self ASSERT: aScriptNode == script.
	^nil
! !

!MethodScope methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	self initializePseudoVars
! !

!MethodScope methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializePseudoVars
	pseudo := StaticBinder new.
	pseudo
		at: 'nil' put: NilBinding new;
		at: 'true' put: TrueBinding new;
		at: 'false' put: FalseBinding new;
		at: 'self' put: SelfBinding new;
		at: 'super' put: SuperBinding new
! !

!MethodScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolve: aString
	(self resolveLocal: aString) ifNotNil: [ :binding | ^ binding ].
	(self resolvePseudo: aString) ifNotNil: [ :binding | ^ binding ].
	^ DynamicBinding named: aString
! !

!MethodScope methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolvePseudo: aString
	^pseudo at: aString

! !

!MethodScope methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
scriptDefining: aString
	(self resolveLocal: aString) ifNotNil: [^script].
	self ASSERT: false.
	^nil
! !

!MethodScope methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
transferLocal: name
	^self resolveLocal: name
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MethodScope class' category: #'Powerlang-Core-SCompiler'!
MethodScope class
	instanceVariableNames: ''!


MethodScope initialize!

