'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SCascadeMessageNode category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SMessageNode subclass: #SCascadeMessageNode
	instanceVariableNames: 'cascade'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-SCompiler-Smalltalk-Parser'!
!SCascadeMessageNode methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:40'!
acceptVisitor: visitor
	^visitor visitCascadeMessage: self
! !

!SCascadeMessageNode methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
cascade: aCascadeNode
	cascade := aCascadeNode.
	receiver := cascade receiver
! !

!SCascadeMessageNode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
from: aMessageNode
	arguments := aMessageNode arguments.
	receiver := aMessageNode receiver.
	selector := aMessageNode selector.
	inlined := aMessageNode isInlined.
	stretch := aMessageNode stretch.
	comments := aMessageNode comments
! !

!SCascadeMessageNode methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isCascadeMessage
	^true
! !

!SCascadeMessageNode methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:40'!
nodesDo: aBlock includingDeclarations: aBoolean
	aBlock value: self.
	arguments do: [:arg | arg nodesDo: aBlock includingDeclarations: aBoolean]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SCascadeMessageNode class' category: #'Powerlang-Core-SCompiler-Smalltalk-Parser'!
SCascadeMessageNode class
	instanceVariableNames: ''!


