'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Stream category: #Kernel!
Object subclass: #Stream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Stream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Stream methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asStream
	^self
! !

!Stream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atEnd
	self shouldNotImplement
! !

!Stream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
close
	
! !

!Stream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectorClass
	^self shouldNotImplement
! !

!Stream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eol
	^String crlf
! !

!Stream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isStream
	^true
! !

!Stream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
position
	self shouldNotImplement
! !

!Stream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
position: anInteger
	self shouldNotImplement
! !

!Stream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
reset
	self position: 0
! !

!Stream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
setToEnd
	self position: self size
! !

!Stream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeToEnd
	^self size - self position
! !

!Stream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
skip
	self skip: 1
! !

!Stream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
skip: n
	| p |
	p := self position + n min: self size.
	p := p max: 0.
	self position: p
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Stream class' category: #Kernel!
Stream class
	instanceVariableNames: ''!

!Stream class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializePools
	self addNamespace: Character namedCharacters
! !

!Stream class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aCollection
	^self new on: aCollection
! !


