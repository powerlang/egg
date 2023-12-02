Class {
	#name : #LanceNICRingDescriptor16,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-Devices-Network'
}

{ #category : #'as yet unclassified' }
LanceNICRingDescriptor16 class >> fields [
	"self defineFields"
	^#(
		(badr0 'ushort')
		(badr1 'byte')
		(flags 'byte')
		(bcnt 'ushort')
		(mcnttdr 'ushort')
	)
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> address [
	^ self pointer asInteger
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> anyError [
	"ERR is the OR of FRAM, OFLO, CRC, BUFF or BPE. ERR is set
	by the PCnet-PCI II controller and cleared by the host."

	^ self flagsBit: 6
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> anyErrorClear [
	^ self flagsBitClear: 6
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> badr0 [
	"This method was automatically generated"
	^handle unsignedShortAt: 1
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> badr0: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 1 put: anObject
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> badr1 [
	"This method was automatically generated"
	^handle unsignedByteAt: 3
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> badr1: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 3 put: anObject
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> bcnt [
	"This method was automatically generated"
	^handle unsignedShortAt: 5
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> bcnt: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> beOwnedByCard [
	^ self flagsBitSet: 7
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> beOwnedByHost [
	^ self flagsBitClear: 7
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> buffer [
	^ ExternalAddress new fromInteger: (self bufferAddress)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> buffer: anExternalAddress [
	^ self bufferAddress: anExternalAddress asInteger 

]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> bufferAddress [
	^ self badr1 << 16 + self badr0 + (self address bitAnd: 16rFF000000)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> bufferAddress: address [
	((address bitXor: self address) bitAnd: 16rFF000000) isZero
		ifFalse: [^ self error: 'In 16 bits mode all addresses must share the higher byte'].
	self badr0: (address bitAnd: 16rFFFF).
	^ self badr1: (address >> 16 bitAnd: 16rFF)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> bufferSize [
	"BCNT Buffer Byte Count is the length of the buffer pointed to
	by this de scriptor, expressed as the two's complement of the
	length of the buffer. This field is written by the host and
	unchanged by the PCnet-PCI II controller."
	^ 16r10000 - self bcnt
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> bufferSize: size [
	^ self bcnt: (size negated bitAnd: 16rFFFF)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> endOfPacketClear [
	^ self flagsBitClear: 0
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> endOfPacketSet [
	^ self flagsBitSet: 0
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> flags [
	"This method was automatically generated"
	^handle unsignedByteAt: 4
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> flags: anObject [
	"This method was automatically generated"
	handle unsignedByteAt: 4 put: anObject
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> flagsBit: index [
	^ self flags anyMask: 1 << index
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> flagsBitClear: index [
	^ self flags: (self flags bitAnd: (1 << index) bitInvert)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> flagsBitSet: index [
	^ self flags: (self flags bitOr: 1 << index)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> isEndOfPacket [
	"End of Packet (ENP) indicates that this is the last buffer used by the
	PCnet-PCI II controller for this frame. It is used for data chaining
	buffers. If both STP and ENP are set, the frame fits into one buffer
	and there is no data chaining. ENP is set by the PCnet-PCI II controller
	and cleared by the host."
	^ self flagsBit: 0
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> isOwnedByCard [
	^ self flagsBit: 7
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> isOwnedByHost [
	^ self isOwnedByCard not
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> isStartOfPacket [
	"Start of Packet (STP) indicates that this is the first buffer used by the
	PCnet-PCI II controller for this frame. If STP and ENP are both
	set to ONE, the frame fits into a single buffer. Otherwise, the
	frame is spread over more than one buffer. When LAPPEN
	(CSR3, bit 5) is cleared to ZERO, STP is set by the PCnet-PCI II
	controller and cleared by the host. When LAPPEN is set to
	ONE, STP must be set by the host."
	^ self flagsBit: 1
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> mcnttdr [
	"This method was automatically generated"
	^handle unsignedShortAt: 7
]

{ #category : #accessing }
LanceNICRingDescriptor16 >> mcnttdr: anObject [
	"This method was automatically generated"
	handle unsignedShortAt: 7 put: anObject
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> mcnttdrBit: index [
	^ self mcnttdr anyMask: 1 << index
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> mcnttdrBitClear: index [
	^ self mcnttdr: (self mcnttdr bitAnd: (1 << index) bitInvert)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> mcnttdrBitSet: index [
	^ self mcnttdr: (self mcnttdr bitOr: 1 << index)
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> message [
	^ self buffer stringAt: 1 size: self messageSize
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> message: aString [
	^ self buffer stringAt: 1 put: aString
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> reset [
	self
		flags: 0;
		mcnttdr: 0.
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> startOfPacketClear [
	^ self flagsBitClear: 1
]

{ #category : #'accessing - no auto' }
LanceNICRingDescriptor16 >> startOfPacketSet [
	^ self flagsBitSet: 1
]
