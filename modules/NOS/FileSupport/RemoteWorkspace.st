Class {
	#name : #RemoteWorkspace,
	#superclass : #Workspace,
	#instVars : [
		'remote'
	],
	#category : 'SqueakNOS-FileSupport'
}

{ #category : #'as yet unclassified' }
RemoteWorkspace >> evaluate: aStream [
	^ remote remotePerform: #evaluate: with: aStream upToEnd.
]

{ #category : #'as yet unclassified' }
RemoteWorkspace >> initialize [
	super initialize.
	remote := RemoteObjectChannel for: self using: 'ParagraphEditorWithBindings new'
]

{ #category : #'as yet unclassified' }
RemoteWorkspace >> isRemote [
	^ true
]
