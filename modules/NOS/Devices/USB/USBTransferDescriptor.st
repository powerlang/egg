Class {
	#name : #USBTransferDescriptor,
	#superclass : #ExternalStructure,
	#category : #'SqueakNOS-Devices-USB'
}

{ #category : #'as yet unclassified' }
USBTransferDescriptor class >> externalNew [
	"must be aligned to 16"
	^self externalNewAligned: 16
]

{ #category : #'as yet unclassified' }
USBTransferDescriptor class >> fields [
	"self defineFields"
	^#(
		(linkPointerVQT 'ulong')
		(statusActLen 'ulong')
		(maxLenAddr 'ulong')
		(bufferPointer 'ulong')
	)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> activate [
	self statusActLen: (self statusActLen bitOr: 1 << 23)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> actualLength [
	^ (self statusActLen bitAnd: 16r3FF) + 1
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> actualLength: anInteger [
	^ self statusActLen: (self statusActLen bitAnd: 16rFFFFFC00) + (anInteger - 1)
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> beData0 [
	self maxLenAddr: (self maxLenAddr bitClear: 1 << 19)
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> beData1 [
	self maxLenAddr: (self maxLenAddr bitOr: 1 << 19)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> beFullSpeedDevice [
	self statusActLen: (self statusActLen bitClear: 1 << 26)
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> beInput [
	self packetIdentification: 16r69
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> beIsochronous [
	self statusActLen: (self statusActLen bitOr: 1 << 25)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> beLowSpeedDevice [
	self statusActLen: (self statusActLen bitOr: 1 << 26)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> beNonIsochronous [
	self statusActLen: (self statusActLen bitClear: 1 << 25)
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> beOutput [
	self packetIdentification: 16rE1
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> beSetup [
	self packetIdentification: 16r2D
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> beTerminator [
	self linkPointerVQT: (self linkPointerVQT bitOr: 1)
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> bufferPointer [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> bufferPointer: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> clearLinkPointer [
	self linkPointerVQT: 1
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> deviceAddress [
	^ self maxLenAddr >> 8 bitAnd: 16r7F
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> deviceAddress: anInteger [
	self maxLenAddr: anInteger << 8 + (self maxLenAddr bitAnd: 16rFFFF80FF)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> disableInterruptOnComplete [
	self statusActLen: (self statusActLen bitAnd: (1 << 24) bitInvert)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> disableShortPacketDetect [
	self statusActLen: (self statusActLen bitClear: 1 << 29)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> enableInterruptOnComplete [
	self statusActLen: (self statusActLen bitOr: 1 << 24)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> enableShortPacketDetect [
	self statusActLen: (self statusActLen bitOr: 1 << 29)
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> endpoint [
	^ self maxLenAddr >> 15 bitAnd: 16rF
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> endpoint: anInteger [
	self maxLenAddr: anInteger << 15 + (self maxLenAddr bitAnd: 16rFFC07FFF)
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> errorCount [
	^ self statusActLen >> 27 bitAnd: 3
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> errorCount: anInteger [
	^ self statusActLen: (self statusActLen bitAnd: (3 << 27) bitInvert) + (anInteger << 27)

]

{ #category : #initialization }
USBTransferDescriptor >> initialize [
	super initialize.
	self
		clearLinkPointer;
		statusActLen: 0;
		maxLenAddr: 0.
]

{ #category : #'accessing - status etc.' }
USBTransferDescriptor >> isActive [
	^ self statusActLen anyMask: 1 << 23
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> isBreadthFirst [
	^ self isDepthFirst not
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> isData0 [
	^ self isData1 not
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> isData1 [
	^ self maxLenAddr anyMask: 1 << 19
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> isDepthFirst [
	^ self linkPointerVQT anyMask: 2r100
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> isQueueHead [
	^ false
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> isTerminator [
	^ self linkPointerVQT anyMask: 1
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> isTransferDescriptor [
	^ true
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> linkPointerVQT [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> linkPointerVQT: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> maxLenAddr [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> maxLenAddr: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> maxLength [
	^ self maxLenAddr >> 21 bitAnd: 16r7FF
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> maxLength: anInteger [
	anInteger > 1280 ifTrue: [self error: 'Maximum allowed length for USB transfers is 1280'].
	self maxLenAddr: (self maxLenAddr bitAnd: 16r1FFFFF) + (anInteger - 1 << 21)
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> next [
	self isTerminator ifTrue: [^ nil].
	self nextIsQueueHead
		ifTrue: [^ USBQueueHead fromHandle: self nextAddress]
		ifFalse: [^ USBTransferDescriptor fromHandle: self nextAddress]
	
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> next: usbQHorTD [
	| address |
	address := usbQHorTD address asInteger.
	(address anyMask: 2r1111) ifTrue: [self error: 'Elements must be aligned to 16'].
	usbQHorTD isQueueHead ifTrue: [address := address bitOr: 2r10].	" turn on Q bit. "
	self isDepthFirst ifTrue: [address := address bitOr: 2r100].			" maintain Vf "
	self linkPointerVQT: address.	" clear Terminator "

]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> nextAddress [
	^ ExternalAddress new fromInteger: (self linkPointerVQT bitClear: 2r1111).
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> nextBeQueueHead [
	self linkPointerVQT: (self linkPointerVQT bitOr: 2r10)
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> nextBeTransferDescriptor [
	self linkPointerVQT: (self linkPointerVQT bitClear: 2r10)
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> nextIsQueueHead [
	^ self linkPointerVQT anyMask: 2r10
]

{ #category : #'accessing - link pointer' }
USBTransferDescriptor >> nextIsTransferDescriptor [
	^ self nextIsQueueHead not
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> packetIdentification [
	^ self maxLenAddr bitAnd: 16rFF
]

{ #category : #'accessing - max len etc.' }
USBTransferDescriptor >> packetIdentification: anInteger [
	self maxLenAddr: anInteger + (self maxLenAddr bitClear: 16rFF)
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> statusActLen [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #'accessing - automatic' }
USBTransferDescriptor >> statusActLen: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]
