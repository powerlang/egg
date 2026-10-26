'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ParagraphEditorWithBindings category: 'SqueakNOS-FileSupport'!
Object subclass: #ParagraphEditorWithBindings
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!ParagraphEditorWithBindings methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
bindingOf: key
	model ifNil: [model := Dictionary new].
	(model includesKey: key) ifFalse: [model at: key put: nil].
	^ model associationAt: key
! !

!ParagraphEditorWithBindings methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
evaluate: aString
	paragraph := aString asParagraph.
	self selectAll.
	^ self evaluateSelection
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ParagraphEditorWithBindings class' category: 'SqueakNOS-FileSupport'!
ParagraphEditorWithBindings class
	instanceVariableNames: ''!


