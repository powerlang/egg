'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageTableEntry category: 'SqueakNOS-MemoryManager-Paging'!
Object subclass: #PageTableEntry
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-MemoryManager-Paging'!
!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
clean
	handle unsignedLongAt: 1 put: 0
! !

!PageTableEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
handle: anExternalHandler
	handle := anExternalHandler
! !

!PageTableEntry methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:24'!
handledBy: externalHandle
	^self new handle: externalHandle
! !

!PageTableEntry methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPresent
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000001.
	^value = 16r1 
! !

!PageTableEntry methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPresentAndAllowed
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000003.
	^value = 16r3 
! !

!PageTableEntry methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPresentAndForbidden
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000003.
	^value = 16r1 
! !

!PageTableEntry methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isReadOnly
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000010.
	^value = 16r2 
! !

!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
notPresent
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAt: 1 put: 0.
	handle unsignedLongAt: 1 put: value 
! !

!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageFrame: aNumber
	| value frame |
	"aNumber must be page aligned"
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000FFF.
	value := value bitOr: aNumber.
	handle unsignedLongAt: 1 put: value
! !

!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTable
	| address |
	address := self pointedAddress.
	^PageTable forPointer: address
! !

!PageTableEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
pointedAddress
	| address |
	address := handle unsignedLongAt: 1.
	^address bitAnd: 16rFFFFF000
! !

!PageTableEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
presentAndWritableWord
	^16r00000003
	
! !

!PageTableEntry methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	aStream nextPutAll: 'Translates to: ', self pointedAddress printString, ', Status bits: ', self status printString.
! !

!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
readOnly
	| value |
	"User mode needs to be set"
	value := handle unsignedLongAt: 1.
	value := value bitAt: 2 put: 0.
	handle unsignedLongAt: 1 put: value	
	



! !

!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
readWrite
	| value |
	"User mode needs to be set"
	value := handle unsignedLongAt: 1.
	value := value bitAt: 2 put: 1.
	handle unsignedLongAt: 1 put: value	
	



! !

!PageTableEntry methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
setPresentAndWritable
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitOr: self presentAndWritableWord.
	handle unsignedLongAt: 1 put: value 	
! !

!PageTableEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
status
	| value |
	value := handle unsignedLongAt: 1.
	^value := value bitAnd: 16r00000FFF
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageTableEntry class' category: 'SqueakNOS-MemoryManager-Paging'!
PageTableEntry class
	instanceVariableNames: ''!


