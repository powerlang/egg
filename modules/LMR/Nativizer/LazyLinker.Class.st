'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #LazyLinker category: #Nativization!
LookupLinker subclass: #LazyLinker
	instanceVariableNames: 'sends'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!LazyLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSend: aSymbol using: anAssembler
	| send |
	send := super emitSend: aSymbol using: anAssembler.
	sends add: send
! !

!LazyLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	sends := OrderedCollection new

! !

!LazyLinker methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
sends
	^sends

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LazyLinker class' category: #Nativization!
LazyLinker class
	instanceVariableNames: ''!


LazyLinker initialize!

