'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!Integer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
externalBytes
	^ExternalMemory allocate: self
! !

!Integer methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
externalCharacters
	^ExternalMemory allocate: self + 1 * 2
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
pointedMemory
	^ExternalMemory at: self
! !


