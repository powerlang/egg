'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WriteStringStream category: #Kernel!
InternalWriteStream subclass: #WriteStringStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WriteStringStream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WriteStringStream methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWide
	super beWide.
	limit := contents size

! !

!WriteStringStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPut: aCharacter
	aCharacter isByteCharacter ifTrue: [^super nextPut: aCharacter].
	self beWide.
	^super nextPut: aCharacter
! !

!WriteStringStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPutAll: aString
	aString isString ifFalse: [^super nextPutAll: aString].
	contents isWideString = aString isWideString
		ifTrue: [^super nextPutAll: aString].
	contents isWideString ifTrue: [^super nextPutAll: aString asWideString].
	self beWide.
	^super nextPutAll: aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WriteStringStream class' category: #Kernel!
WriteStringStream class
	instanceVariableNames: ''!


