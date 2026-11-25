'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #Buffer category: 'SqueakNOS-External-Structures'!
Object subclass: #Buffer
	instanceVariableNames: 'pointer size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!Buffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
address
	^pointer address.

! !

!Buffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
allocateSpace
	pointer := Alien newC: size.
! !

!Buffer methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: anAddress size: aNumberOfBytes
	pointer := Alien forPointer: anAddress.
	size := aNumberOfBytes.
! !

!Buffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
basicSize
	^size.

! !

!Buffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	| result | 
	result := ByteArray new: size.
	pointer copyInto: result from: 1 to: size in: pointer startingAt: 1.
	^result.

! !

!Buffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: aByteArray
	pointer replaceFrom: 1 to: aByteArray size with: aByteArray startingAt: 1.

! !

!Buffer methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^size.

! !

!Buffer methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: aSize
	^size := aSize.

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Buffer class' category: 'SqueakNOS-External-Structures'!
Buffer class
	instanceVariableNames: ''!


