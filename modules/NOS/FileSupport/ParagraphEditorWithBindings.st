Class {
	#name : #ParagraphEditorWithBindings,
	#superclass : #Object,
	#category : 'SqueakNOS-FileSupport'
}

{ #category : #'as yet unclassified' }
ParagraphEditorWithBindings >> bindingOf: key [
	model ifNil: [model := Dictionary new].
	(model includesKey: key) ifFalse: [model at: key put: nil].
	^ model associationAt: key
]

{ #category : #'as yet unclassified' }
ParagraphEditorWithBindings >> evaluate: aString [
	paragraph := aString asParagraph.
	self selectAll.
	^ self evaluateSelection
]
