'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #LookupLinker category: #Nativization!
MessageLinker subclass: #LookupLinker
	instanceVariableNames: 'lookup lookupSuper'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!LookupLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
emitSend: aSymbol using: anAssembler
	| send |
	send := SendSite new lookup: aSymbol using: lookup.
	anAssembler
		loadAwithLiteral: send;
		callIndirectA;
		discardArguments: aSymbol arity.
	^send
! !

!LookupLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
emitSendSuper: aSymbol from: aClass using: anAssembler
	| send behavior |
	send := SendSite new lookup: aSymbol using: lookupSuper; beSuperSend.
	behavior := aClass superclass map instanceBehavior.
	anAssembler
		loadAwithLiteral: send;
		loadTwithLiteral: behavior;
		callIndirectA;
		discardArguments: aSymbol arity.
	^send
! !

!LookupLinker methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeFrom: anLMRModule
	lookup := anLMRModule lookupStub.
	lookupSuper := anLMRModule lookupSuperStub.

! !

!LookupLinker methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookup: aByteArray
	lookup := aByteArray
! !

!LookupLinker methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
lookupSuper: aByteArray
	lookupSuper := aByteArray
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LookupLinker class' category: #Nativization!
LookupLinker class
	instanceVariableNames: ''!


