'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SCascadeNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SParseNode subclass: #SCascadeNode
	instanceVariableNames: 'receiver messages optimized'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SCascadeNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitCascade: self
! !

!SCascadeNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
hasAssign
	receiver hasAssign ifTrue: [^true].
	messages detect: [:msg | msg hasAssign] ifNone: [^false].
	^true
! !

!SCascadeNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCascade
	^true
! !

!SCascadeNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
messages
	^messages
! !

!SCascadeNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
messages: aCollection
	messages := aCollection
! !

!SCascadeNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
nodesDo: aBlock includingDeclarations: aBoolean
	super nodesDo: aBlock includingDeclarations: aBoolean.
	receiver nodesDo: aBlock includingDeclarations: aBoolean.
	messages do: [:msg | msg nodesDo: aBlock includingDeclarations: aBoolean]
! !

!SCascadeNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
receiver
	^receiver
! !

!SCascadeNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
receiver: rcvr
	receiver := rcvr
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCascadeNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SCascadeNode class
	instanceVariableNames: ''!


