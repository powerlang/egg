'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #CompositeMessageLinker category: #Nativization!
MessageLinker subclass: #CompositeMessageLinker
	instanceVariableNames: 'candidates'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!CompositeMessageLinker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
add: aMessageLinker
	candidates add: aMessageLinker
! !

!CompositeMessageLinker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
dispatchLinkerFor: selector
	^candidates
		detect: [:linker | linker canInline: selector]
		ifNone: [self error: 'cannot dispatch ', selector storeString]
! !

!CompositeMessageLinker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
emitSend: selector using: anAssembler
	| linker |
	linker := self dispatchLinkerFor: selector.
	linker emitSend: selector using: anAssembler

! !

!CompositeMessageLinker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
emitSendSuper: selector from: aClass using: anAssembler
	| linker |
	linker := self dispatchLinkerFor: selector.
	linker emitSendSuper: selector from: aClass using: anAssembler
! !

!CompositeMessageLinker methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	candidates := OrderedCollection new
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CompositeMessageLinker class' category: #Nativization!
CompositeMessageLinker class
	instanceVariableNames: ''!


CompositeMessageLinker initialize!

