'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #VMBridge category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #VMBridge
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
image
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: 25) type: ExternalType void asPointerType
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
image: anObject
	"This method was automatically generated"
	handle pointerAt: 25 put: anObject getHandle.
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
inPageFault
	^handle unsignedLongAt: 53
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
inPageFault: anInteger
	handle unsignedLongAt: 53 put: anInteger
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
multiboot
	"This method was automatically generated"
	^MultiBootInfo fromHandle: (handle pointerAt: 21)
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
multiboot: anObject
	"This method was automatically generated"
	handle pointerAt: 21 put: anObject getHandle.
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageFaultAddress
	^handle unsignedLongAt: 57
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageFaultAddress: anInteger
	handle unsignedLongAt: 57 put: anInteger
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageFaultHandlerEntry
	^handle unsignedLongAt: 37
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageFaultHandlerEntry: aCallBackAddress
	"This method was automatically generated"
	handle unsignedLongAt: 37 put: aCallBackAddress
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotEndAddress
	"This method was automatically generated"
	^handle unsignedLongAt: 33
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotEndAddress: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 33 put: anObject
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotInfo
	"This method was automatically generated and modified by hand"
	^SnapshotInfo fromHandle: handle + 40
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotInfo: anObject
	"This method was automatically generated"
	handle structAt: 41 put: anObject getHandle length: 12.
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotStartAddress
	"This method was automatically generated"
	^handle unsignedLongAt: 29
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshotStartAddress: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 29 put: anObject
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
totalPageFaults
	^handle unsignedLongAt: 61
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
totalPageFaults: anInteger
	handle unsignedLongAt: 61 put: anInteger
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
video
	"This method was automatically generated"
	^DisplayInformation fromHandle: (handle structAt: 1 length: 20)
! !

!VMBridge methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
video: anObject
	"This method was automatically generated"
	handle structAt: 1 put: anObject getHandle length: 20.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'VMBridge class' category: 'SqueakNOS-External-Structures'!
VMBridge class
	instanceVariableNames: ''!

!VMBridge class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	^#(
		(video 'DisplayInformation')
		(multiboot 'MultiBootInfo*')
		(image 'void*')
	   	(snapshotStartAddress 'ulong') 
	      (snapshotEndAddress 'ulong')
		(pageFaultHandlerEntry 'void*')
		(snapshotInfo 'SnapshotInfo')    
	)
! !

!VMBridge class methodsFor:  'system startup' stamp: 'KenD 28/Jun/2026 13:32:25'!
install
	Computer current ifNotNil: [:computer | computer initializeBridge]
! !


