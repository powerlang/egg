'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #MessageLinker category: #Nativization!
Object subclass: #MessageLinker
	instanceVariableNames: 'filter'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!MessageLinker methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
canInline: aSymbol
	filter ifNil: [ ^true ].
	filter == aSymbol ifTrue: [ ^true ].
	^(filter includes: aSymbol)
! !

!MessageLinker methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
filter: anObject
	filter := anObject.
	filter isCollection ifTrue: [filter := filter asIdentitySet]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MessageLinker class' category: #Nativization!
MessageLinker class
	instanceVariableNames: ''!


