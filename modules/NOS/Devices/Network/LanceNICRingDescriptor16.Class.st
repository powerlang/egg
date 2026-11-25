'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #LanceNICRingDescriptor16 category: 'SqueakNOS-Devices-Network'!
ExternalStructure subclass: #LanceNICRingDescriptor16
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Network'!
!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
address
	^ self pointer asInteger
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
anyError
	"ERR is the OR of FRAM, OFLO, CRC, BUFF or BPE. ERR is set
	by the PCnet-PCI II controller and cleared by the host."

	^ self flagsBit: 6
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
anyErrorClear
	^ self flagsBitClear: 6
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
badr0
	"This method was automatically generated"
	^handle unsignedShortAt: 1
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
badr0: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 1 put: anObject
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
badr1
	"This method was automatically generated"
	^handle unsignedByteAt: 3
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
badr1: anObject
	"This method was automatically generated"
	handle unsignedByteAt: 3 put: anObject
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
bcnt
	"This method was automatically generated"
	^handle unsignedShortAt: 5
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
bcnt: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 5 put: anObject
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
beOwnedByCard
	^ self flagsBitSet: 7
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
beOwnedByHost
	^ self flagsBitClear: 7
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
buffer
	^ ExternalAddress new fromInteger: (self bufferAddress)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
buffer: anExternalAddress
	^ self bufferAddress: anExternalAddress asInteger 

! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
bufferAddress
	^ self badr1 << 16 + self badr0 + (self address bitAnd: 16rFF000000)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
bufferAddress: address
	((address bitXor: self address) bitAnd: 16rFF000000) isZero
		ifFalse: [^ self error: 'In 16 bits mode all addresses must share the higher byte'].
	self badr0: (address bitAnd: 16rFFFF).
	^ self badr1: (address >> 16 bitAnd: 16rFF)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
bufferSize
	"BCNT Buffer Byte Count is the length of the buffer pointed to
	by this de scriptor, expressed as the two's complement of the
	length of the buffer. This field is written by the host and
	unchanged by the PCnet-PCI II controller."
	^ 16r10000 - self bcnt
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
bufferSize: size
	^ self bcnt: (size negated bitAnd: 16rFFFF)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
endOfPacketClear
	^ self flagsBitClear: 0
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
endOfPacketSet
	^ self flagsBitSet: 0
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
flags
	"This method was automatically generated"
	^handle unsignedByteAt: 4
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
flags: anObject
	"This method was automatically generated"
	handle unsignedByteAt: 4 put: anObject
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
flagsBit: index
	^ self flags anyMask: 1 << index
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
flagsBitClear: index
	^ self flags: (self flags bitAnd: (1 << index) bitInvert)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
flagsBitSet: index
	^ self flags: (self flags bitOr: 1 << index)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
isEndOfPacket
	"End of Packet (ENP) indicates that this is the last buffer used by the
	PCnet-PCI II controller for this frame. It is used for data chaining
	buffers. If both STP and ENP are set, the frame fits into one buffer
	and there is no data chaining. ENP is set by the PCnet-PCI II controller
	and cleared by the host."
	^ self flagsBit: 0
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
isOwnedByCard
	^ self flagsBit: 7
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
isOwnedByHost
	^ self isOwnedByCard not
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
isStartOfPacket
	"Start of Packet (STP) indicates that this is the first buffer used by the
	PCnet-PCI II controller for this frame. If STP and ENP are both
	set to ONE, the frame fits into a single buffer. Otherwise, the
	frame is spread over more than one buffer. When LAPPEN
	(CSR3, bit 5) is cleared to ZERO, STP is set by the PCnet-PCI II
	controller and cleared by the host. When LAPPEN is set to
	ONE, STP must be set by the host."
	^ self flagsBit: 1
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mcnttdr
	"This method was automatically generated"
	^handle unsignedShortAt: 7
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
mcnttdr: anObject
	"This method was automatically generated"
	handle unsignedShortAt: 7 put: anObject
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
mcnttdrBit: index
	^ self mcnttdr anyMask: 1 << index
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
mcnttdrBitClear: index
	^ self mcnttdr: (self mcnttdr bitAnd: (1 << index) bitInvert)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
mcnttdrBitSet: index
	^ self mcnttdr: (self mcnttdr bitOr: 1 << index)
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
message
	^ self buffer stringAt: 1 size: self messageSize
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
message: aString
	^ self buffer stringAt: 1 put: aString
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
reset
	self
		flags: 0;
		mcnttdr: 0.
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
startOfPacketClear
	^ self flagsBitClear: 1
! !

!LanceNICRingDescriptor16 methodsFor:  'accessing - no auto' stamp: 'KenD 28/Jun/2026 13:32:24'!
startOfPacketSet
	^ self flagsBitSet: 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LanceNICRingDescriptor16 class' category: 'SqueakNOS-Devices-Network'!
LanceNICRingDescriptor16 class
	instanceVariableNames: ''!

!LanceNICRingDescriptor16 class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fields
	"self defineFields"
	^#(
		(badr0 'ushort')
		(badr1 'byte')
		(flags 'byte')
		(bcnt 'ushort')
		(mcnttdr 'ushort')
	)
! !


