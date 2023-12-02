Class {
	#name : #USBQueueHead,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-Devices-USB'
}

{ #category : #'as yet unclassified' }
USBQueueHead class >> externalNew [
	"must be aligned to 16"
	^self externalNewAligned: 16
]

{ #category : #'as yet unclassified' }
USBQueueHead class >> fields [
	"self defineFields"
	^#(
		(queueHeadLinkPointerQT 'ulong')
		(queueElementLinkPointerRQT 'ulong')
	)
]

{ #category : #accessing }
USBQueueHead >> beEmpty [
	^ self queueElementLinkPointerRQT: 1
]

{ #category : #private }
USBQueueHead >> beTerminator [
	self queueHeadLinkPointerQT: 1
]

{ #category : #accessing }
USBQueueHead >> first [
	self isEmpty ifTrue: [^ nil].
	self firstIsQueueHead
		ifTrue: [^ USBQueueHead fromHandle: self firstAddress]
		ifFalse: [^ USBTransferDescriptor fromHandle: self firstAddress]
]

{ #category : #accessing }
USBQueueHead >> first: usbQHorTD [
	| address |
	address := usbQHorTD address asInteger.
	(address anyMask: 2r1111) ifTrue: [self error: 'QH element must be aligned to 16'].
	usbQHorTD isQueueHead ifTrue: [address := address bitOr: 2r10].	" turn on Q bit. "
	self queueElementLinkPointerRQT: address.	" clear Terminator "
]

{ #category : #private }
USBQueueHead >> firstAddress [
	^ ExternalAddress new fromInteger: (self queueElementLinkPointerRQT bitClear: 2r1111) 
]

{ #category : #private }
USBQueueHead >> firstIsQueueHead [
	^ self queueElementLinkPointerRQT anyMask: 2r10
]

{ #category : #private }
USBQueueHead >> firstIsTransferDescriptor [
	^ self firstIsQueueHead not
]

{ #category : #accessing }
USBQueueHead >> isEmpty [
	^ self queueElementLinkPointerRQT anyMask: 1
]

{ #category : #accessing }
USBQueueHead >> isQueueHead [
	^ true
]

{ #category : #private }
USBQueueHead >> isTerminator [
	self queueHeadLinkPointerQT anyMask: 1
]

{ #category : #accessing }
USBQueueHead >> isTransferDescriptor [
	^ false
]

{ #category : #accessing }
USBQueueHead >> next: usbQHorTD [
	| address |
	address := usbQHorTD address asInteger.
	(address anyMask: 2r1111) ifTrue: [self error: 'QH element must be aligned to 16'].
	usbQHorTD isQueueHead ifTrue: [address := address bitOr: 2r10].	" turn on Q bit. "
	self queueHeadLinkPointerQT: address.	" clear Terminator "
]

{ #category : #'accessing - automatic' }
USBQueueHead >> queueElementLinkPointerRQT [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #'accessing - automatic' }
USBQueueHead >> queueElementLinkPointerRQT: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #'accessing - automatic' }
USBQueueHead >> queueHeadLinkPointerQT [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #'accessing - automatic' }
USBQueueHead >> queueHeadLinkPointerQT: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
