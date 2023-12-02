Class {
	#name : #LanceNICReceiveRingDescriptor16,
	#superclass : #LanceNICRingDescriptor16,
	#category : 'SqueakNOS-Devices-Network'
}

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> bufferError [
	"Buffer error is set any time the PCnet-PCI II controller does not
	own the next buffer while data chaining a received frame. This
	can occur in either of two ways:
		1. The OWN bit of the next buffer is ZERO.
		2. FIFO overflow occurred before the PCnet-PCI II controller
		was able to read the OWNbit of the next descriptor.
	If a Buffer Error occurs, an Overflow Error may also occur
	internally in the FIFO, but will not be reported in the descriptor status
	entry unless both BUFF and OFLO errors occur at the same
	time. BUFF is set by the PCnet-PCI II controller and cleared
	by the host."
	^ self flagsBit: 2
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> bufferErrorClear [
	^ self flagsBitClear: 2
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> crcError [
	"CRC indicates that the receiver has detected a CRC (FCS) error
	on the incoming frame. CRC is valid only when ENP is set and
	OFLO is not. CRC is set by the PCnet-PCI II controller and
	cleared by the host."
	^ self flagsBit: 3
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> crcErrorClear [
	^ self flagsBitClear: 3
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> frameError [
	"Framing error indicates that the incoming frame contains a
	non-integer multiple of eight bits and there was an FCS error. If
	there was no FCS error on the in coming frame, then FRAM will
	not be set even if there was a non-integer multiple of eight bits
	in the frame. FRAM is not valid in internal loopback mode. FRAM is
	valid only when ENP is set and OFLO is not. FRAM is set by the
	PCnet-PCI II controller and cleared by the host."

	^ self flagsBit: 5
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> frameErrorClear [
	^ self flagsBitClear: 5
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> messageSize [
	"Message Byte Count is the length in bytes of the received
	message, expressed as an unsigned binary integer. MCNT is
	valid only when ERR is clear and ENP is set. MCNT is written by
	the PCnet-PCI II controller and cleared by the host."
	^ self mcnttdr - 4
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> messageSize: size [
	"Message Byte Count is the length in bytes of the received
	message, expressed as an unsigned binary integer. MCNT is
	valid only when ERR is clear and ENP is set. MCNT is written by
	the PCnet-PCI II controller and cleared by the host."
	^ self mcnttdr: size 
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> overflowError [
	"Overflow error indicates that the receiver has lost all or part of the
	incoming frame, due to an inability to move data from the receive
	FIFO into a memory buffer before the internal FIFO overflowed.
	OFLO is valid only when ENP is not set. OFLO is set by the PC-
	net-PCI II controller and cleared by the host."
	^ self flagsBit: 4
]

{ #category : #accessing }
LanceNICReceiveRingDescriptor16 >> overflowErrorClear [
	^ self flagsBitClear: 4
]
