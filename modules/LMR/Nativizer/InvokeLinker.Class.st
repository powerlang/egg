'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #InvokeLinker category: #Nativization!
MessageLinker subclass: #InvokeLinker
	instanceVariableNames: 'invoker sends'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!InvokeLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMethod: aCompiledMethod
	self addMethod: aCompiledMethod for: aCompiledMethod selector
! !

!InvokeLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMethod: aCompiledMethod for: aSymbol
	| instructions send |
	filter add: aSymbol.
	instructions := invoker ifNil: [ aCompiledMethod nativeCode code ].
	send := SendSite invoking: aCompiledMethod using: instructions.
	sends at: aSymbol put: send
! !

!InvokeLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMethods: aCollection
	aCollection do: [:m | self addMethod: m]
! !

!InvokeLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
emitSend: aSymbol using: anAssembler
	| send |
	send := sends at: aSymbol.
	anAssembler
		loadAwithLiteral: send;
		callIndirectA;
		discardArguments: aSymbol arity
! !

!InvokeLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	sends := Dictionary new.
	self filter: #()
! !

!InvokeLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
invoker: aNativeCode
	invoker := aNativeCode
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InvokeLinker class' category: #Nativization!
InvokeLinker class
	instanceVariableNames: ''!


InvokeLinker initialize!

