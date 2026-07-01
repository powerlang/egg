'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #USBQueueHead category: 'SqueakNOS-Devices-USB'!
ExternalStructure subclass: #USBQueueHead
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-USB'!
!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
beEmpty
	^ self queueElementLinkPointerRQT: 1
! !

!USBQueueHead methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
beTerminator
	self queueHeadLinkPointerQT: 1
! !

!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
first
	self isEmpty ifTrue: [^ nil].
	self firstIsQueueHead
		ifTrue: [^ USBQueueHead fromHandle: self firstAddress]
		ifFalse: [^ USBTransferDescriptor fromHandle: self firstAddress]
! !

!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
first: usbQHorTD
	| address |
	address := usbQHorTD address asInteger.
	(address anyMask: 2r1111) ifTrue: [self error: 'QH element must be aligned to 16'].
	usbQHorTD isQueueHead ifTrue: [address := address bitOr: 2r10].	" turn on Q bit. "
	self queueElementLinkPointerRQT: address.	" clear Terminator "
! !

!USBQueueHead methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
firstAddress
	^ ExternalAddress new fromInteger: (self queueElementLinkPointerRQT bitClear: 2r1111) 
! !

!USBQueueHead methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
firstIsQueueHead
	^ self queueElementLinkPointerRQT anyMask: 2r10
! !

!USBQueueHead methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
firstIsTransferDescriptor
	^ self firstIsQueueHead not
! !

!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isEmpty
	^ self queueElementLinkPointerRQT anyMask: 1
! !

!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isQueueHead
	^ true
! !

!USBQueueHead methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
isTerminator
	self queueHeadLinkPointerQT anyMask: 1
! !

!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isTransferDescriptor
	^ false
! !

!USBQueueHead methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
next: usbQHorTD
	| address |
	address := usbQHorTD address asInteger.
	(address anyMask: 2r1111) ifTrue: [self error: 'QH element must be aligned to 16'].
	usbQHorTD isQueueHead ifTrue: [address := address bitOr: 2r10].	" turn on Q bit. "
	self queueHeadLinkPointerQT: address.	" clear Terminator "
! !

!USBQueueHead methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
queueElementLinkPointerRQT
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!USBQueueHead methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
queueElementLinkPointerRQT: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !

!USBQueueHead methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
queueHeadLinkPointerQT
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!USBQueueHead methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
queueHeadLinkPointerQT: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'USBQueueHead class' category: 'SqueakNOS-Devices-USB'!
USBQueueHead class
	instanceVariableNames: ''!

!USBQueueHead class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
externalNew
	"must be aligned to 16"
	^self externalNewAligned: 16
! !

!USBQueueHead class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fields
	"self defineFields"
	^#(
		(queueHeadLinkPointerQT 'ulong')
		(queueElementLinkPointerRQT 'ulong')
	)
! !


