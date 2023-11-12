Class {
	#name : #LanceNICTransmitRingDescriptor16,
	#superclass : #LanceNICRingDescriptor16,
	#category : #'SqueakNOS-Devices-Network'
}

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> bufferError [
	"bit 15 - BUFF
	Buffer error is set by the PCnet-PCI II controller during transmission
	when the PCnet-PCI II controller does not find the ENP flag in the
	current descriptor and does not own the next descriptor.
	This can occur in either of two ways:
        1.    The OWN bit of the next descriptor is ZERO.
        2.    FIFO underflow occurred before the PCnet-PCI II
              controller obtained the STATUS byte (TMD1[31:24]) of
              the next descriptor. BUFF is set by the PCnet-PCI II
			controller and cleared by the host.                     

	If a Buffer Error occurs, an Underflow Error will also occur.
	BUFF is not valid when LCOL or RTRY error is set during transmit
	data chaining. BUFF is set by the PCnet-PCI II controller and
	cleared by the host."
	^ self mcnttdrBit: 15
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> bufferErrorClear [
	^ self mcnttdrBitClear: 15
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> disableCRCGeneration [
	"clearing this bit will not automatically disable CRC generation.
	read comment on #enableCRCGeneration"
	^ self flagsBitClear: 5


]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> disableTransmitInterrupt [
	"bit 4 - LTINT
	When LTINTEN is set to ONE this bit functions as LTINT on
	host write operations and on PCnet-PCI II controller read operations.

	LTINT is used to suppress interrupts after successful transmission
	on selected frames. When LTINT is cleared to ZERO and
	ENP (End of Packet) is set to ONE, the PCnet-PCI II controller will not
	set TINT (CSR0, bit 9) after a successful transmission. TINT will
	only be set when the last descriptor of a frame has both LTINT and
	ENP set to ONE. When LTINT is cleared to ZERO, it will only
	cause the suppression of interrupts for successful transmission.
	TINT will always be set if the transmission has an error. The
	LTINTEN overrides the function of TOKINTD (CSR5, bit 15)."
	^ self flagsBitClear: 4
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> enableCRCGeneration [
	"bit 5 - ADD_FCS
	ADD_FCS dynamically controls the generation of FCS on a frame
	by frame basis. It is valid only if the STP (Start of Packet) bit is set.
	When ADD_FCS is set, the state of DXMTFCS is ignored and trans-
	mitter FCS generation is activated. When ADD_FCS is cleared to
	ZERO, FCS generation is controlled by DXMTFCS. When
	APAD_XMT (CSR4, bit 11) is set to ONE, the setting of ADD_FCS
	has no effect. ADD_FCS is set by the host, and is not changed by
	the PCnet-PCI II controller. This is a reserved bit in the C-LANCE
	(Am79C90). This function differs from the corresponding ILACC
	function."
	^ self flagsBitSet: 5


]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> enableTransmitInterrupt [
	"bit 4 - LTINT
	When LTINTEN is set to ONE this bit functions as LTINT on
	host write operations and on PCnet-PCI II controller read operations.

	LTINT is used to suppress interrupts after successful transmission
	on selected frames. When LTINT is cleared to ZERO and
	ENP (End of Packet) is set to ONE, the PCnet-PCI II controller will not
	set TINT (CSR0, bit 9) after a successful transmission. TINT will
	only be set when the last descriptor of a frame has both LTINT and
	ENP set to ONE. When LTINT is cleared to ZERO, it will only
	cause the suppression of interrupts for successful transmission.
	TINT will always be set if the transmission has an error. The
	LTINTEN overrides the function of TOKINTD (CSR5, bit 15)."
	^ self flagsBitSet: 4
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> excessiveDeferralError [
	"Excessive Deferral. Indicates that the transmitter has experienced
	Excessive Deferral on this transmit frame, where Excessive
	Deferral is defined in ISO 8802-3 (IEEE/ANSI 802.3). Excessive
	Deferral will also set the interrupt bit EXDINT (CSR5, bit 7)."
	^ self mcnttdrBit: 13
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> excessiveDeferralErrorClear [
	^ self mcnttdrBitClear: 13
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> lateCollisionError [
	"Late Collision indicates that a collision has occurred after the first
	slot time of the channel has elapsed. The PCnet-PCI II con-
	troller does not retry on late collisions. LCOL is set by the
	PCnet-PCI II controller and cleared by the host."
	^ self mcnttdrBit: 12
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> lateCollisionErrorClear [
	^ self mcnttdrBitClear: 12
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> lossOfCarrierError [
	"bit 11 - LCAR
	Loss of Carrier is set when the carrier is lost during a PCnet-PCI II
	controller-initiated transmission when in AUI mode and the device
	is operating in half-duplex mode. The PCnet-PCI II controller does
	not retry upon loss of carrier. It will continue to transmit the whole
	frame until done. LCAR will not be set when the device is operating
	in full-duplex mode and the AUI port is active. LCAR is not
	valid in Internal Loopback Mode.
	LCAR is set by the PCnet-PCI II controller and cleared by the host.
	In 10BASE-T mode, LCAR will be set when the T-MAU was in Link
	Fail state during the transmission."
	^ self mcnttdrBit: 11
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> lossOfCarrierErrorClear [
	^ self mcnttdrBitClear: 11
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> message: aString [
	super message: aString.
	self
		bufferSize: aString size;
		startOfPacketSet;
		endOfPacketSet;
		beOwnedByCard.
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> messageSize [
	^ self bufferSize
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> neededDefer [
	"bit 2 - DEF
	Deferred indicates that the PCnet-PCI II controller had to defer
	while trying to transmit a frame. This condition occurs if the channel
	is busy when the PCnet-PCI II controller is ready to transmit.
	DEF is set by the PCnet-PCI II controller and cleared by the host."
	^ self flagsBit: 2
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> neededDeferClear [
	^ self flagsBitClear: 2
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> neededMultipleRetries [
	"bit 4 - MORE/LTINT
	MORE indicates that more than one retry was needed to transmit
	a frame. The value of MORE is written by the PCnet-PCI II controller.
	This bit has meaning only if the ENP bit is set."
	^ self flagsBit: 4
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> neededMultipleRetriesClear [
	^ self flagsBitClear: 4
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> neededOneRetry [
	"bit 3 - ONE
	ONE indicates that exactly one retry was needed to transmit a
	frame. ONE flag is not valid when LCOL is set. The value of the
	ONE bit is written by the PCnet-PCI II controller. This bit has
	meaning only if the ENP bit is set."
	^ self flagsBit: 3
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> neededOneRetryClear [
	^ self flagsBitClear: 3
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> retryError [
	" bit 10 - RTRY
	Retry error indicates that the transmitter has failed after 16
	attempts to successfully transmit a message, due to repeated
	collisions on the medium. If DRTY is set to ONE in the MODE
	register, RTRY will set after 1 failed transmission attempt.
	RTRY is set by the PCnet-PCI II controller and cleared by the host."
	^ self mcnttdrBit: 10
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> retryErrorClear [
	^ self mcnttdrBitClear: 10
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> timeDomainReflectometer [
	"nice method name eh! not my imagination thought :-)
	TDR Time Domain Reflectometer reflects the state of an internal
	PCnet-PCI II controller counter that counts at a 10 MHz rate from the
	start of a transmission to the occurrence of a collision or loss of
	carrier. This value is useful in determining the approximate distance
	to a cable fault. The TDR value is written by the PCnet-PCI II
	controller and is valid only if RTRY is set.
	Note that 10 MHz gives very low resolution and in general has not
	been found to be particularly useful. This feature is here primarily
	to maintain full compatibility with the C-LANCE device (Am79C90)."
	^ self mcnttdr bitAnd: 16r3FF
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> underflowError [
	" bit 14 - UFLO
	Underflow error indicates that the transmitter has truncated a
	message because it could not read data from memory fast enough.
	UFLO indicates that the FIFO has emptied before the end of the
	frame was reached. When DXSUFLO (CSR3, bit 6) is cleared to
	ZERO, the transmitter is turned off when an UFLO error
	occurs (CSR0, TXON = 0). When DXSUFLO is set to ONE
	the PCnet-PCI II controller grace fully recovers from an UFLO
	error. It scans the transmit descriptor ring until it finds the
	start of a new frame and starts a new transmission.
	UFLO is set by the PCnet-PCI II controller and cleared by the
	host."
	^ self mcnttdrBit: 14
]

{ #category : #accessing }
LanceNICTransmitRingDescriptor16 >> underflowErrorClear [
	^ self mcnttdrBitClear: 14
]
