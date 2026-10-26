'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #IdAdaptor category: #JSON!
DataAdaptor subclass: #IdAdaptor
	instanceVariableNames: 'selector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!IdAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!IdAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
dataFrom: anObject
	anObject isNil ifTrue: [^nil].
	anObject isInteger ifTrue: [^anObject].
	anObject isString ifTrue: [^anObject].
	^selector evaluateWith: anObject
! !

!IdAdaptor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	selector := #id
! !

!IdAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: anInteger
	^anInteger
! !

!IdAdaptor methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
selector: aSymbol
	selector := aSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IdAdaptor class' category: #JSON!
IdAdaptor class
	instanceVariableNames: ''!

!IdAdaptor class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:41'!
forName
	^self new selector: #name
! !


IdAdaptor initialize!

