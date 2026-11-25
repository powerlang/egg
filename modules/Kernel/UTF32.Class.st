'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #UTF32 category: #Kernel!
Unicode subclass: #UTF32
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!UTF32 commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!UTF32 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decode: aByteArray
	^WideString newFrom: aByteArray
! !

!UTF32 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encode: aCharacter on: aStream
	aStream nextULongPut: aCharacter codePoint
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UTF32 class' category: #Kernel!
UTF32 class
	instanceVariableNames: ''!

!UTF32 class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prefix
	^#[16rFE 16rFF 0 0]
! !


