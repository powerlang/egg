'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PhysicalRegionDescriptorTable category: #'SqueakNOS-Devices-Storage'!
Object subclass: #PhysicalRegionDescriptorTable
	instanceVariableNames: 'address nextEntry'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
address
	^address asInteger 

! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
advanceEntry
	nextEntry := nextEntry = self size ifTrue: [ 1 ] ifFalse: [ nextEntry + 1 ].
 
! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
atNextFreeEntryPutSize: size address: target
	| offset encoded |
	offset := self offsetOfEntry: nextEntry.
	encoded := size = 65536 ifTrue: [ 0 ] ifFalse:  [ size ].
	address unsignedLongAt: 1 + offset put: target; unsignedLongAt: 1 + offset + 4 put: encoded.
! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
beEndOfTransferAt: entry
	| offset |
	offset := self offsetOfEntry: entry.
	address byteAt: 1 + offset + 7 put: 16r80.
! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	| size aligned |
	nextEntry := 1.
	size := 64 * 1024.
	address := ExternalAddress allocate: size * 2 - 1.
	aligned := address asInteger alignedTo: size.
	address fromInteger: aligned.
	"1 to: size do: [:i | address byteAt: i put: 0 ]"
! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
markEndOfTransfer
	| entry |
	entry := nextEntry = 1 ifTrue: [ self size ] ifFalse: [ nextEntry - 1 ].
	self beEndOfTransferAt: entry 
! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
offsetOfEntry: entry
	^entry - 1 * 8
! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
reset
	nextEntry := 1.

! !

!PhysicalRegionDescriptorTable methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
size
	^64 * 1024 // 8
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PhysicalRegionDescriptorTable class' category: #'SqueakNOS-Devices-Storage'!
PhysicalRegionDescriptorTable class
	instanceVariableNames: ''!


PhysicalRegionDescriptorTable initialize!

