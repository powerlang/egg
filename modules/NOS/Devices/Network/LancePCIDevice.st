"
Only ""working"" for PCI, however, we use 16 bits mode so it's more compatible with older ISA cards, try with:

LancePCIDevice installOn: Computer current.
Computer current defaultNetworkInterface macAddress hex.

Information from:

GRUB Legacy's source in netboot/lance.c netboot/pci.c and netboot/config.c
(from this sources, we are assuming PCI, and with that ENABLE_AUTOSELECT and no MUST_UNREST)

Am79C972
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/21485_pt1.pdf
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/21485_pt2.pdf
Specially pages starting at: 91 of part 1

Am79C970
http://www.amd.com/files/connectivitysolutions/networking/archivednetworking/19436.pdf

More Tech Info from AMD:
http://www.amd.com/us-en/ConnectivitySolutions/DesignWithAMD (Networking Tech Docs, Archived Tech Docs)
"
Class {
	#name : #LancePCIDevice,
	#superclass : #NetworkingDevice,
	#category : #'SqueakNOS-Devices-Network'
}

{ #category : #'as yet unclassified' }
LancePCIDevice class >> deviceId [
	^ 16r2000
]

{ #category : #'as yet unclassified' }
LancePCIDevice class >> vendorId [
	^ 16r1022
]

{ #category : #'accessing - basic' }
LancePCIDevice >> address [
	^ self shortAt: 16r12
]

{ #category : #'accessing - basic' }
LancePCIDevice >> address: word [
	^ self shortAt: 16r12 put: word 
]

{ #category : #'accessing - status' }
LancePCIDevice >> anyError [
	"bit 15 - ERR
	Error is set by the ORing of BABL, CERR, MISS, and MERR.
	ERR remains set as long as any of the error flags are true.
	Read accessible always. ERR is read only. Write operations are
	ignored."

	^ self statusBit: 15
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> automaticMediaSelection [
	^ self miscConfiguration: (self miscConfiguration bitOr: 2r10)
]

{ #category : #'accessing - status' }
LancePCIDevice >> bablError [
	"bit 14 - BABL
	Babble is a transmitter time-out error. BABL is set by the
	PCnet-PCI II controller when the    (CSR112) also increments each
	transmitter has been on the channel longer than the time required
	to send the maximum length frame. BABL will be set if 1519 bytes or
	greater are transmitted.

	When BABL is set, INTA is asserted if IENA is ONE and the
	mask bit BABLM (CSR3, bit 14) is ZERO. BABL assertion will set
	the ERR bit, regardless of the settings of IENA and BABLM.

	Read/Write accessible always. BABL is cleared by the host by
	writing a ONE. Writing a ZERO has no effect. BABL is cleared by
	H_RESET, S_RESET or by setting the STOP bit."

	^ self statusBit: 14
]

{ #category : #'accessing - status' }
LancePCIDevice >> bablErrorReset [
	^ self statusBitSet: 14
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> busControlData [
	^ self shortAt: 16r16
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> busControlData: word [
	^ self shortAt: 16r16 put: word
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> busControlWord: index [
	self address: index.
	^ self busControlData
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> busControlWord: index put: word [
	^ self
		address: index;
		busControlData: word.
]

{ #category : #'as yet unclassified' }
LancePCIDevice >> chipVersion [
	self controlStatusAddress: 88.
	self controlStatusAddress ~= 88 ifTrue: [^ 0].	" version 0 does not reflect addresses "

	^ (self controlStatusWord: 89) << 16 + (self controlStatusWord: 88)
]

{ #category : #'accessing - status' }
LancePCIDevice >> collisionError [
	"bit 13 - CERR
	Collision Error is set by the PC=net-PCI II controller when the
	device operates in half-duplex mode and the collision inputs to
	the AUI port failed to activate within 20 network bit times after
	the chip terminated transmission (SQE Test). This feature is a
	transceiver test feature. CERR reporting is disabled when the
	AUI interface is active and the PCnet-PCI II controller operates in
	full-duplex mode.
	In 10BASE-T mode, for both half-duplex and full-duplex operation,
	CERR will be set after a transmission if the T-MAU is in Link Fail state.
	CERR assertion will not result in an interrupt being generated.
	CERR assertion will set the ERR bit.
	Read/Write accessible always. CERR is cleared by the host by
	writing a ONE. Writing a ZERO has no effect. CERR is cleared by
	H_RESET, S_RESET or by setting the STOP bit."

	^ self statusBit: 13
]

{ #category : #'accessing - status' }
LancePCIDevice >> collisionErrorReset [
	^ self statusBitSet: 13
]

{ #category : #'accessing - control status' }
LancePCIDevice >> controlStatusData [
	^ self shortAt: 16r10
]

{ #category : #'accessing - control status' }
LancePCIDevice >> controlStatusData: word [
	^ self shortAt: 16r10 put: word
]

{ #category : #'accessing - control status' }
LancePCIDevice >> controlStatusWord: index [
	self address: index.
	^ self controlStatusData
]

{ #category : #'accessing - control status' }
LancePCIDevice >> controlStatusWord: index put: word [
	^ self
		address: index;
		controlStatusData: word.
]

{ #category : #'accessing - status' }
LancePCIDevice >> demandTransmition [
	"bit 3 - TDMD
	Transmit Demand, when set, causes the buffer management
	unit to access the transmit descriptor ring without waiting for
	the poll-time counter to elapse. If TXON is not enabled, TDMD bit
	will be cleared and no transmit descriptor ring access will occur.
	If the DPOLL bit in CSR4 is set, automatic polling is disabled and
	TDMD can be used to start a transmission.
	Read/Write accessible always. TDMD is set by writing a ONE.
	Writing a ZERO has no effect. TDMD will be cleared by the buffer
	management unit when it polls a transmit descriptor. TDMD is
	cleared by H_RESET, S_RESET or by setting the STOP bit."
	^ self statusBitSet: 3
]

{ #category : #'accessing - status' }
LancePCIDevice >> disableInterrupts [
	^ self statusBitClear: 6
]

{ #category : #'accessing - status' }
LancePCIDevice >> enableInterrupts [
	"bit 6 - IENA
	Interrupt Enable allows INTA to be active if the Interrupt Flag is
	set. If IENA is cleared to ZERO, INTA will be disabled regardless
	of the state of INTR.
	Read/Write accessible always. IENA is set by writing a ONE and
	cleared by writing a ZERO. IENA is cleared by H_RESET,
	S_RESET or by setting the STOP bit."
	^ self statusBitSet: 6
]

{ #category : #'irq handling' }
LancePCIDevice >> handleIRQ [
	| statusOnEntry |
	statusOnEntry := self status.
	[
	self receiveInterruptPending
		ifTrue: [self handleReceiveInterrupt].
	self transmitInterruptPending
		ifTrue: [].
	] on: Error do: [:ex | Transcript show: ex; cr].
	self status: statusOnEntry
]

{ #category : #'irq handling' }
LancePCIDevice >> handleReceiveInterrupt [
	| ring pkt |
	ring := self initializationBlock receiveRing.
	ring isOwnedByHost ifTrue: [
		pkt := EthernetPacket bytes: ring message.
		ring beOwnedByCard.
		self input: pkt.
	].
]

{ #category : #'accessing - status' }
LancePCIDevice >> init [
	" bit 0 - INIT
	INIT assertion enables the PCnet-PCI II controller to begin the
	initialization procedure which reads the initialization block from
	memory. Setting INIT clears the STOP bit. If STRT and INIT are
	set together, the PCnet-PCI II controller initialization will be
	performed first. INIT is not cleared. If when the initialization
	sequence has completed.
	Read/Write accessible always. INIT is set by writing a ONE.
	Writing a ZERO has no effect. INIT is cleared by H_RESET, S_RESET
	or by setting the STOP bit."

	^ self status: 1
]

{ #category : #'accessing - status' }
LancePCIDevice >> initAndStart [
	"by spec. INIT+START clear STOP. INIT is done before START"
	^ self status: 3
]

{ #category : #'accessing - control status' }
LancePCIDevice >> initializationBlock [
	^ self is16
		ifTrue: [LanceNICInitializationBlock16 fromHandle: (
			ExternalAddress new fromInteger: (self initializationBlockAddress))]
		ifFalse: [self notYetImplemented]

]

{ #category : #'accessing - control status' }
LancePCIDevice >> initializationBlock: aLanceNICInitBlock [
	aLanceNICInitBlock is16
		ifTrue: [
			self
				softwareStyleRegister: 0;
				initializationBlockAddress: aLanceNICInitBlock address]
		ifFalse: [self notYetImplemented]

]

{ #category : #'accessing - control status' }
LancePCIDevice >> initializationBlockAddress [
	^ (self controlStatusWord: 2) << 16 + (self controlStatusWord: 1)
]

{ #category : #'accessing - control status' }
LancePCIDevice >> initializationBlockAddress: addr [
	^ self
		controlStatusWord: 1 put: (addr bitAnd: 16rFFFF);
		controlStatusWord: 2 put: (addr >> 16).
]

{ #category : #'accessing - status' }
LancePCIDevice >> initializationDone [
	"bit 8 - IDON
	Initialization Done is set by the PCnet-PCI II controller after the
	initialization sequence has completed. When IDON is set, the
	PCnet-PCI II controller has read the initialization block from mem-
	ory.
	When IDON is set, INTA is asserted if IENA is ONE and the
	mask bit IDONM (CSR3, bit 8) is ZERO.
	Read/Write accessible always. IDON is cleared by the host by
	writing a ONE. Writing a ZERO has no effect. IDON is cleared by
	H_RESET, S_RESET or by setting the STOP bit."
	^ self statusBit: 8
]

{ #category : #'accessing - status' }
LancePCIDevice >> initializationDoneReset [
	^ self statusBitSet: 8
]

{ #category : #initialization }
LancePCIDevice >> initialize [
	| initBlock tring rring rbuf tbuf |
	"Note that the hw specification requires that all rring, tring, and initBlock are aligned to 8 bytes. 
	We assume this is the case in a x86_64 FFI what this has to be checked"
	rbuf := ExternalAddress allocate: 1536.
	rring := (LanceNICReceiveRingDescriptor16 externalNew)
		reset;
		buffer: rbuf;
		bufferSize: 1536;
		messageSize: 0;
		beOwnedByCard.

	tbuf := ExternalAddress allocate: 1536.
	tring := (LanceNICTransmitRingDescriptor16 externalNew)
		reset;
		buffer: tbuf;
		beOwnedByHost.
		
	initBlock := (LanceNICInitializationBlock16 externalNew)   
		mode: 0;		"auto media"
		macAddress: self macAddress;
		logicalAddressFilter: 0;
		transmitRing: tring;
		transmitRingLen: 0;
		receiveRing: rring;
		receiveRingLen: 0.

	self
		stop;
		initializationBlock: initBlock;
		testAndFeaturesControl: 2r0100111101111111;
		automaticMediaSelection;
		initAndStart.

	" 2r0100.1111.0111.1111 = (page 112 of Am79C790A pdf)
		0,1	No Jabber IRQ + reset Jabber flag.
		2,3	No Transmit Start IRQ + reset Transmit status.
		4,5	No Receive Collition Counter overflow IRQ + reset RCVCCO.
		6	Clear user interrupt flag.
		7	No User Interrupt Command.
		8,9	No Clear Missed Frame Counter overflow IRQ + clear MFCO.
		10	Auto Strip Receive Padding (may we want to see it?)
		11	Auto Pad Outgoing.
		12	No Disable Auto Transmit Polling
		13	No Enable Bus Timer
		14	Disable DMA Plus transfer counter.
		15	Disable EN124 (No Runt Packet Accept)
	"

	self enableInterrupts.
]

{ #category : #'accessing - status' }
LancePCIDevice >> interruptPending [
	"bit 7 - INTR
	Interrupt Flag indicates that one or more following interrupt
	causing conditions has occurred: BABL, EXDINT, IDON, JAB,
	MERR, MISS, MFCO, MPINT, RVCC, RINT, SINT, SLPINT, TINT,
	TXSTRT or UINT and the associated mask or enable bit is
	programmed to allow the event to cause an interrupt. If IENA is set
	to ONE and INTR is set, INTA will be active. When INTR is set by
	SINT or SLPINT, INTA will be active independent of the state of
	INEA.
	Read accessible always. INTR is read only. INTR is cleared by
	clearing all of the active individual interrupt bits that have not been
	masked out."
	^ self statusBit: 7
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> is16 [
	^ (self softwareStyleRegister bitAnd: 16rF) isZero
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> is32 [
	^ self is16 not
]

{ #category : #'accessing - status' }
LancePCIDevice >> isReceiveEnabled [
	"bit 5 - RXON
	Receive On indicates that the receive function is enabled. RXON
	is set to ONE if DRX (CSR15, bit 0) is cleared to ZERO after the
	START bit is set. If INIT and START are set together, RXON
	will not be set until after the initialization block has been read in.
	Read accessible always. RXON is read only. RXON is cleared by
	H_RESET, S_RESET or by setting the STOP bit."
	^ self statusBit: 5
]

{ #category : #'accessing - status' }
LancePCIDevice >> isTransmitEnabled [
	"bit 4 - TXON
	Transmit On indicates that the transmit function is enabled. TXON
	is set to ONE if DTX (CSR15, bit 1) is cleared to ZERO after the
	START bit is set. If INIT and START are set together, TXON
	will not be set until after the initialization block has been read in.
	Read accessible always. TXON is read only. TXON is cleared by
	H_RESET, S_RESET or by setting the STOP bit."
	^ self statusBit: 4
]

{ #category : #'as yet unclassified' }
LancePCIDevice >> isValid [
	| ver |
	self reset: self reset.
	(self controlStatusWord: 0) ~= 4 ifTrue: [^ false].
	ver := self chipVersion.
	(ver isZero or: [(ver bitAnd: 16rFFF) == 3])
		ifFalse: [^ false].
	^ true
]

{ #category : #'accessing - basic' }
LancePCIDevice >> macAddress [
	| answer |
	answer := self controlStatusWord: 14.
	answer := answer << 16 + (self controlStatusWord: 13).
	answer := answer << 16 + (self controlStatusWord: 12).
	^ answer "EthernetAddress fromInteger: answer"
]

{ #category : #'accessing - status' }
LancePCIDevice >> memoryError [
	"bit 11 - MERR
	Memory Error is set by the PCnet-PCI II controller when it re-
	quests the use of the system interface bus by asserting REQ
	and GNT has not been asserted after a programmable length of
	time. The length of time in microseconds before MERR is asserted
	will depend upon the setting of the Bus Timeout register
	(CSR100). The default setting of CSR100 will set MERR after
	153.6 ¨µs of bus latency.
	When MERR is set, INTA is asserted if IENA is ONE and the
	mask bit MERRM (CSR3, bit 11) is ZERO. MERR assertion will set
	the ERR bit, regardless of the settings of IENA and MERRM.
	Read/Write accessible always. MERR is cleared by the host by
	writing a ONE. Writing a ZERO has no effect. MERR is cleared
	by H_RESET, S_RESET or by setting the STOP bit."

	^ self statusBit: 11
]

{ #category : #'accessing - status' }
LancePCIDevice >> memoryErrorReset [
	^ self statusBitSet: 11
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> miscConfiguration [
	^ self busControlWord: 2
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> miscConfiguration: config [
	^ self busControlWord: 2 put: config
]

{ #category : #'accessing - status' }
LancePCIDevice >> missedFrameError [
	"bit 12 - MISS
	Missed Frame is set by the PCnet-PCI II controller when it
	looses an incoming receive frame because a receive descriptor was
	not available. This bit is the only immediate indication that receive
	data has been lost since there is no current receive descriptor.
	The Missed Frame Counter (CSR112) also increments each
	time a receive frame is missed.
	When MISS is set, INTA is asserted if IENA is ONE and the mask
	bit MISSM (CSR3, bit 12) is ZERO. MISS assertion will set the
	ERR bit, regardless of the settings of IENA and MISSM.
	Read/Write accessible always. MISS is cleared by the host by
	writing a ONE. Writing a ZERO has no effect. MISS is cleared by
	H_RESET, S_RESET or by setting the STOP bit."

	^ self statusBit: 12
]

{ #category : #'accessing - status' }
LancePCIDevice >> missedFrameErrorReset [
	^ self statusBitSet: 12
]

{ #category : #'accessing - status' }
LancePCIDevice >> receiveInterruptPending [
	"bit 10 - RINT
	Receive Interrupt is set by the PCnet-PCI II controller after the
	last descriptor of a receive frame has been updated by writing a
	ZERO to the OWN bit. RINT may also be set when the first descriptor
	of a receive frame has been updated by writing a ZERO to the
	OWN bit if the LAPPEN bit of CSR3 has been set to ONE.
	When RINT is set, INTA is asserted if IENA is ONE and the mask
	bit RINTM (CSR3, bit 10) is ZERO.
	Read/Write accessible always. RINT is cleared by the host by
	writing a ONE. Writing a ZERO has no effect. RINT is cleared by
	H_RESET, S_RESET or by setting the STOP bit."
	^ self statusBit: 10
]

{ #category : #'accessing - status' }
LancePCIDevice >> receiveInterruptPendingReset [
	^ self statusBitSet: 10
]

{ #category : #'accessing - basic' }
LancePCIDevice >> reset [
	^ self byteAt: 16r14
]

{ #category : #'accessing - basic' }
LancePCIDevice >> reset: byte [
	^ self byteAt: 16r14 put: byte
]

{ #category : #'as yet unclassified' }
LancePCIDevice >> sendNow: anEthernetPacket [
	self initializationBlock transmitRing message: anEthernetPacket asString
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> softwareStyleRegister [
	^ self busControlWord: 20
]

{ #category : #'accessing - bus control' }
LancePCIDevice >> softwareStyleRegister: newStyle [
	^ self busControlWord: 20 put: newStyle
]

{ #category : #'accessing - status' }
LancePCIDevice >> start [
	" bit 1 - STRT
	STRT assertion enables the PCnet-PCI II controller to send and
	receive frames and perform buffer management operations. Set-
	ting STRT clears the STOP bit. If STRT and INIT are set together,
	the PCnet-PCI II controller initialization will be performed first.
	Read/Write accessible always. STRT is set by writing a ONE.
	Writing a ZERO has no effect. STRT is cleared by H_RESET,
	S_RESET or by setting the STOP bit."

	^ self statusBitSet: 2
]

{ #category : #'accessing - status' }
LancePCIDevice >> status [
	^ self controlStatusWord: 0
]

{ #category : #'accessing - status' }
LancePCIDevice >> status: status [
	^ self controlStatusWord: 0 put: status
]

{ #category : #'accessing - status' }
LancePCIDevice >> statusBit: index [
	^ self status anyMask: 1 << index
]

{ #category : #'accessing - status' }
LancePCIDevice >> statusBitClear: index [
	^ self status: (self status bitAnd: (1 << index) bitInvert)
]

{ #category : #'accessing - status' }
LancePCIDevice >> statusBitSet: index [
	^ self status: (self status bitOr: 1 << index)
]

{ #category : #'accessing - status' }
LancePCIDevice >> stop [
	" bit 2 - STOP
	STOP assertion disables the chip from all DMA and network activi	ty.
	The chip remains inactive until 	either STRT or INIT are set. If STOP,
	STRT and INIT are all set together, STOP will override STRT and INIT.
	Read/Write accessible always. STOP is set by writing a ONE, by
	H_RESET or S_RESET. Writing a ZERO has no effect. STOP is
	cleared by setting either STRT or INIT."

	^ self status: 4
]

{ #category : #'accessing - control status' }
LancePCIDevice >> testAndFeaturesControl [
	^ self controlStatusWord: 4
]

{ #category : #'accessing - control status' }
LancePCIDevice >> testAndFeaturesControl: word [
	^ self controlStatusWord: 4 put: word
]

{ #category : #'accessing - status' }
LancePCIDevice >> transmitInterruptPending [
	"bit 9 - TINT
	Transmit Interrupt is set by the PCnet-PCI II controller after the
	OWN bit in the last descriptor of a transmit frame has been cleared
	to indicate the frame has been sent or an error occurred in the
	transmission. When TINT is set, INTA is asserted if IENA is ONE
	and the mask bit TINTM (CSR3,bit 9) is ZERO."
	^ self statusBit: 9
]

{ #category : #'accessing - status' }
LancePCIDevice >> transmitInterruptPendingReset [
	^ self statusBitSet: 9
]
