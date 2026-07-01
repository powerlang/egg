'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #USBTransferDescriptor category: 'SqueakNOS-Devices-USB'!
ExternalStructure subclass: #USBTransferDescriptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-USB'!
!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
activate
	self statusActLen: (self statusActLen bitOr: 1 << 23)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
actualLength
	^ (self statusActLen bitAnd: 16r3FF) + 1
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
actualLength: anInteger
	^ self statusActLen: (self statusActLen bitAnd: 16rFFFFFC00) + (anInteger - 1)
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beData0
	self maxLenAddr: (self maxLenAddr bitClear: 1 << 19)
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beData1
	self maxLenAddr: (self maxLenAddr bitOr: 1 << 19)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beFullSpeedDevice
	self statusActLen: (self statusActLen bitClear: 1 << 26)
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beInput
	self packetIdentification: 16r69
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beIsochronous
	self statusActLen: (self statusActLen bitOr: 1 << 25)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beLowSpeedDevice
	self statusActLen: (self statusActLen bitOr: 1 << 26)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beNonIsochronous
	self statusActLen: (self statusActLen bitClear: 1 << 25)
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beOutput
	self packetIdentification: 16rE1
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
beSetup
	self packetIdentification: 16r2D
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
beTerminator
	self linkPointerVQT: (self linkPointerVQT bitOr: 1)
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
bufferPointer
	"This method was automatically generated"
	^handle unsignedLongAt: 13
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
bufferPointer: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearLinkPointer
	self linkPointerVQT: 1
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceAddress
	^ self maxLenAddr >> 8 bitAnd: 16r7F
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceAddress: anInteger
	self maxLenAddr: anInteger << 8 + (self maxLenAddr bitAnd: 16rFFFF80FF)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableInterruptOnComplete
	self statusActLen: (self statusActLen bitAnd: (1 << 24) bitInvert)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableShortPacketDetect
	self statusActLen: (self statusActLen bitClear: 1 << 29)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableInterruptOnComplete
	self statusActLen: (self statusActLen bitOr: 1 << 24)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableShortPacketDetect
	self statusActLen: (self statusActLen bitOr: 1 << 29)
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
endpoint
	^ self maxLenAddr >> 15 bitAnd: 16rF
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
endpoint: anInteger
	self maxLenAddr: anInteger << 15 + (self maxLenAddr bitAnd: 16rFFC07FFF)
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
errorCount
	^ self statusActLen >> 27 bitAnd: 3
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
errorCount: anInteger
	^ self statusActLen: (self statusActLen bitAnd: (3 << 27) bitInvert) + (anInteger << 27)

! !

!USBTransferDescriptor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	self
		clearLinkPointer;
		statusActLen: 0;
		maxLenAddr: 0.
! !

!USBTransferDescriptor methodsFor:  'accessing - status etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
isActive
	^ self statusActLen anyMask: 1 << 23
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
isBreadthFirst
	^ self isDepthFirst not
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
isData0
	^ self isData1 not
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
isData1
	^ self maxLenAddr anyMask: 1 << 19
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
isDepthFirst
	^ self linkPointerVQT anyMask: 2r100
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
isQueueHead
	^ false
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
isTerminator
	^ self linkPointerVQT anyMask: 1
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
isTransferDescriptor
	^ true
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
linkPointerVQT
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
linkPointerVQT: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
maxLenAddr
	"This method was automatically generated"
	^handle unsignedLongAt: 9
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
maxLenAddr: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
maxLength
	^ self maxLenAddr >> 21 bitAnd: 16r7FF
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
maxLength: anInteger
	anInteger > 1280 ifTrue: [self error: 'Maximum allowed length for USB transfers is 1280'].
	self maxLenAddr: (self maxLenAddr bitAnd: 16r1FFFFF) + (anInteger - 1 << 21)
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
next
	self isTerminator ifTrue: [^ nil].
	self nextIsQueueHead
		ifTrue: [^ USBQueueHead fromHandle: self nextAddress]
		ifFalse: [^ USBTransferDescriptor fromHandle: self nextAddress]
	
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
next: usbQHorTD
	| address |
	address := usbQHorTD address asInteger.
	(address anyMask: 2r1111) ifTrue: [self error: 'Elements must be aligned to 16'].
	usbQHorTD isQueueHead ifTrue: [address := address bitOr: 2r10].	" turn on Q bit. "
	self isDepthFirst ifTrue: [address := address bitOr: 2r100].			" maintain Vf "
	self linkPointerVQT: address.	" clear Terminator "

! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextAddress
	^ ExternalAddress new fromInteger: (self linkPointerVQT bitClear: 2r1111).
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextBeQueueHead
	self linkPointerVQT: (self linkPointerVQT bitOr: 2r10)
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextBeTransferDescriptor
	self linkPointerVQT: (self linkPointerVQT bitClear: 2r10)
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextIsQueueHead
	^ self linkPointerVQT anyMask: 2r10
! !

!USBTransferDescriptor methodsFor:  'accessing - link pointer' stamp: 'KenD 28/Jun/2026 13:32:24'!
nextIsTransferDescriptor
	^ self nextIsQueueHead not
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
packetIdentification
	^ self maxLenAddr bitAnd: 16rFF
! !

!USBTransferDescriptor methodsFor:  'accessing - max len etc.' stamp: 'KenD 28/Jun/2026 13:32:24'!
packetIdentification: anInteger
	self maxLenAddr: anInteger + (self maxLenAddr bitClear: 16rFF)
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusActLen
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!USBTransferDescriptor methodsFor:  'accessing - automatic' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusActLen: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'USBTransferDescriptor class' category: 'SqueakNOS-Devices-USB'!
USBTransferDescriptor class
	instanceVariableNames: ''!

!USBTransferDescriptor class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
externalNew
	"must be aligned to 16"
	^self externalNewAligned: 16
! !

!USBTransferDescriptor class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fields
	"self defineFields"
	^#(
		(linkPointerVQT 'ulong')
		(statusActLen 'ulong')
		(maxLenAddr 'ulong')
		(bufferPointer 'ulong')
	)
! !


USBTransferDescriptor initialize!

