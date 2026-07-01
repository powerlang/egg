'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OVariable category: #IR!
Object subclass: #OVariable
	instanceVariableNames: 'binding'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OVariable commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureBoundBy: aVariableBinder
	binding isPoolVariableBinding
		ifTrue: [^aVariableBinder bindPoolVariable: self with: binding].
	binding isTemporary
		ifTrue: [^aVariableBinder bindTemporary: self with: binding].
	(binding isLiteral or: [binding isPseudo])
		ifTrue: [^aVariableBinder bindSpecial: self with: binding].
	self halt
! !

!OVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
binding: aBinding
	binding := aBinding
! !

!OVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isConstant
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OVariable class' category: #IR!
OVariable class
	instanceVariableNames: ''!

!OVariable class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: aParseNode
	^self new binding: aParseNode binding
! !


