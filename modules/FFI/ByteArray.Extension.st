'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!ByteArray methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:37'!
copyToMemory: anExternalMemory
	anExternalMemory replaceFrom: 1 to: self size with: self startingAt: 1
! !

!ByteArray methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:37'!
externalCopy
	^ExternalMemory fromByteArray: self
! !

!ByteArray methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
pointedMemory
	^ExternalMemory at: self
! !

!ByteArray class methodsFor:  '*instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
fromMemory: anExternalMemory length: anInteger
	^self fromBytes: anExternalMemory length: anInteger
! !


