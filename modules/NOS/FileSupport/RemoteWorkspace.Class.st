'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #RemoteWorkspace category: 'SqueakNOS-FileSupport'!
Workspace subclass: #RemoteWorkspace
	instanceVariableNames: 'remote'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-FileSupport'!
!RemoteWorkspace methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
evaluate: aStream
	^ remote remotePerform: #evaluate: with: aStream upToEnd.
! !

!RemoteWorkspace methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize.
	remote := RemoteObjectChannel for: self using: 'ParagraphEditorWithBindings new'
! !

!RemoteWorkspace methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
isRemote
	^ true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RemoteWorkspace class' category: 'SqueakNOS-FileSupport'!
RemoteWorkspace class
	instanceVariableNames: ''!


RemoteWorkspace initialize!

