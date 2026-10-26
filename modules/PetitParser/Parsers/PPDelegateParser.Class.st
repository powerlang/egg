'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPDelegateParser category: #Parsers!
PPParser subclass: #PPDelegateParser
	instanceVariableNames: 'parser'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPDelegateParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPDelegateParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
children
	^{parser}
! !

!PPDelegateParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	^ parser parseOn: aStream
! !

!PPDelegateParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setParser: aParser
	parser := aParser
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPDelegateParser class' category: #Parsers!
PPDelegateParser class
	instanceVariableNames: ''!

!PPDelegateParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aParser
	^ self new setParser: aParser
! !


