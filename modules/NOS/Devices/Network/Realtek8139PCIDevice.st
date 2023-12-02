"
Realtek offers somehow good information

http://www.realtek.com.tw/downloads/downloads1-1.aspx?lineid=1

self installOn: Computer current
"
Class {
	#name : #Realtek8139PCIDevice,
	#superclass : #NetworkingDevice,
	#instVars : [
		'nextTxIndex'
	],
	#category : 'SqueakNOS-Devices-Network'
}

{ #category : #'as yet unclassified' }
Realtek8139PCIDevice class >> deviceId [
	^ 16r8139
]

{ #category : #'as yet unclassified' }
Realtek8139PCIDevice class >> onPCIEntry: aPCIBusEntry [
	^self atMemoryAddress: aPCIBusEntry allMemoryRanges first key.

]

{ #category : #'as yet unclassified' }
Realtek8139PCIDevice class >> vendorId [
	^ 16r10EC
]

{ #category : #commands }
Realtek8139PCIDevice >> command [
	"This register is used for issuing commands to the RTL8139C(L).
	These commands are issued by setting the corresponding bits for
	the function. A global software reset along with individual reset
	and enable/disable for transmitter and receiver are provided here."
	^ self byteAt: 16r37
]

{ #category : #commands }
Realtek8139PCIDevice >> command: aByte [
	^ self byteAt: 16r37 put: aByte
]

{ #category : #receiving }
Realtek8139PCIDevice >> earlyReceiveByteCount [
	^ self shortAt: 16r34
]

{ #category : #receiving }
Realtek8139PCIDevice >> earlyReceiveStatus [
	^ self byteAt: 16r36
]

{ #category : #'irq handling' }
Realtek8139PCIDevice >> handleIRQ [
	| statusOnEntry |
	statusOnEntry := self interruptStatus.
	"Status contents: self statusString."	"Status := TextMorph new openInWorld"
	[	self receiveInterruptPending ifTrue: [self handleReceiveInterrupt].
		self receiveBufferOverflowInterruptPending ifTrue: [self handleReceiveBufferFull].
	] ifError: [:ex | Transcript show: ex; cr; flush].

	"reset every interrupt, as they where on entry to avoid race conditions"
	self interruptStatus: statusOnEntry.
]

{ #category : #'irq handling' }
Realtek8139PCIDevice >> handleReceiveInterrupt [
	| rbuf status len |
	[self hasReceiveBufferEmpty] whileFalse: [
		rbuf := self receiveReadAddress.
		status := rbuf unsignedShortAt: 1.
		len := rbuf unsignedShortAt: 3.
		(status anyMask: 1) ifTrue: [	"received OK"
			self input: 
				(EthernetPacket bytes: (rbuf stringAt: 5 size: len - 4))].	"The length includes Ethernet CRC"

		"+4 for PacketHeader, wrap around and align to 4"
		len := self receiveReadOffset + len + 4 + 3 bitAnd: 16rFFFC.
		self receiveReadOffset: len.]

]

{ #category : #receiving }
Realtek8139PCIDevice >> hasReceiveBufferEmpty [
	^ self command anyMask: 1
]

{ #category : #initialization }
Realtek8139PCIDevice >> initialize [
	| rbuf |
	0 to: 3 do: [:i |
		self transmitStartAddress: i put: (ExternalAddress allocate: 1536 aligned: 4).
		self transmitStatus: i put: 2r10000000000000	"belogning to host, don't send"].
	
	rbuf := ExternalAddress allocate: 64*1024+16 aligned: 4.
	nextTxIndex := 0.
	self
		reset;
		receiveBufferAddress: rbuf;
		receiveReadOffset: 16rFFF0;
		interruptMask: 2r1110000001111111;		"enable all IRQs. needed because the status must be cleared"
		command: 12;							"enable receive, enable transmit"
		receiveConfiguration: 2r1111111001011110;	"receive everything except non-matching MAC"
		transmitConfiguration: 2r00000011000000000000011011110000.
]

{ #category : #accessing }
Realtek8139PCIDevice >> interruptMask [
	"IMR - Interrupt Mask Register"
	^ self shortAt: 16r3C
]

{ #category : #accessing }
Realtek8139PCIDevice >> interruptMask: aShort [
	^ self shortAt: 16r3C put: aShort
]

{ #category : #accessing }
Realtek8139PCIDevice >> interruptStatus [
	"ISR - Interrupt Status Register"
	^ self shortAt: 16r3E
]

{ #category : #accessing }
Realtek8139PCIDevice >> interruptStatus: aShort [
	^ self shortAt: 16r3E put: aShort
]

{ #category : #accessing }
Realtek8139PCIDevice >> interruptStatusBit: index [
	^ self interruptStatus anyMask: 1 << index
]

{ #category : #accessing }
Realtek8139PCIDevice >> logicalAddressFilter [
	^ (self longAt: 16rC) << 32 + (self longAt: 8)
]

{ #category : #accessing }
Realtek8139PCIDevice >> logicalAddressFilter: anInteger [
	self longAt: 16rC put: anInteger // 16r100000000.
	^ self longAt: 8 put: anInteger \\ 16r100000000
]

{ #category : #accessing }
Realtek8139PCIDevice >> macAddress [
	| answer |
	answer := self shortAt: 4.
	answer := answer << 32 + (self longAt: 0).
	^ EthernetAddress fromInteger: answer

]

{ #category : #accessing }
Realtek8139PCIDevice >> missedPacketCounter [
	"MPC - Missed Packet Counter: Indicates the number of packets discarded
	due to rx FIFO overflow. It is a 24-bit counter. After s/w reset, MPC is
	cleared. Only the lower 3 bytes are valid. When any value is written,
	MPC will be reset."
	^ self longAt: 16r4C

]

{ #category : #accessing }
Realtek8139PCIDevice >> missedPacketCounterReset [
	^ self longAt: 16r4C put: 0

]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveBuffer [
	^ ExternalAddress new fromInteger: self receiveBufferAddress
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveBufferAddress [
	"RBSTART"
	^ self longAt: 16r30
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveBufferAddress: anExternalAddressOrInteger [
	^ self longAt: 16r30 put: anExternalAddressOrInteger asInteger
]

{ #category : #'irq handling' }
Realtek8139PCIDevice >> receiveBufferOverflowInterruptPending [
	^ self interruptStatusBit: 4
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveConfiguration [
	"RCR - Receive Configuration Register"
	^ self longAt: 16r44
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveConfiguration: aLong [
	^ self longAt: 16r44 put: aLong
]

{ #category : #'irq handling' }
Realtek8139PCIDevice >> receiveInterruptPending [
	^ self interruptStatusBit: 0
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveReadAddress [
	^ ExternalAddress new fromInteger: self receiveReadOffset + 16r10 \\ 16r10000 + self receiveBufferAddress
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveReadOffset [
	"CAPR - Current Address of Packet Read.
	The initial value is 0FFF0h"
	^ self shortAt: 16r38
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveReadOffset: aShort [
	^ self shortAt: 16r38 put: aShort
]

{ #category : #receiving }
Realtek8139PCIDevice >> receiveWriteOffset [
	"CBA - Current Buffer Address
	The initial value is 0000h. It reflect total received byte-count in the rx buffer."
	^ self shortAt: 16r3A
]

{ #category : #commands }
Realtek8139PCIDevice >> reset [
	"Reset: Setting to 1 forces the RTL8139C(L) to a software reset state
	which disables the transmitter and receiver, reinitializes the FIFOs,
	resets the system buffer pointer to the initial value (Tx buffer is at
	TSAD0, Rx buffer is empty). The values of IDR0-5 and MAR0-7 and
	PCI configuration space will have no changes. This bit is 1 during the
	reset operation, and is cleared to 0 by the RTL8139C(L) when the reset
	operation is complete."

	self command: 128.
	[self command anyMask: 128] whileTrue.
]

{ #category : #transmiting }
Realtek8139PCIDevice >> sendNow: anEthernetPacket [
	| oldTxIndex |
	nextTxIndex := (oldTxIndex := nextTxIndex) + 1 \\ 4.	"race condition here if two threads want to do this"
	^ self sendNow: anEthernetPacket on: oldTxIndex.
]

{ #category : #transmiting }
Realtek8139PCIDevice >> sendNow: anEthernetPacket on: descriptorIndex [
	| str |
	str := anEthernetPacket asString padRightTo: 60.
	(self transmitStartAddress: descriptorIndex) stringAt: 1 put: str.
	self transmitStatus: descriptorIndex put: str size.
]

{ #category : #transmiting }
Realtek8139PCIDevice >> statusString [
	^ String streamContents: [:strm |
		Time now printOn: strm.
		strm nextPutAll: ' IRQ:'.
		self interruptStatus printOn: strm base: 16.
		strm nextPutAll: ' Tx0:'.
		(self transmitStatus: 0) printOn: strm base: 16.
		strm nextPutAll: ' Tx1:'.
		(self transmitStatus: 1) printOn: strm base: 16.
		strm nextPutAll: ' Tx2:'.
		(self transmitStatus: 2) printOn: strm base: 16.
		strm nextPutAll: ' Tx3:'.
		(self transmitStatus: 3) printOn: strm base: 16]

]

{ #category : #accessing }
Realtek8139PCIDevice >> timerCount [
	"TCTR - Timer Count Register: This register contains a 32-bit
	general-purpose timer. Writing any value to this 32-bit register will
	reset the original timer and begin to count from zero."
	^ self longAt: 16r48

]

{ #category : #accessing }
Realtek8139PCIDevice >> timerCountReset [
	^ self longAt: 16r48 put: 0

]

{ #category : #transmiting }
Realtek8139PCIDevice >> transmitConfiguration [
	"TCR - Transmit Configuration Register"
	^ self longAt: 16r40
]

{ #category : #transmiting }
Realtek8139PCIDevice >> transmitConfiguration: aLong [
	^ self longAt: 16r40 put: aLong
]

{ #category : #transmiting }
Realtek8139PCIDevice >> transmitStartAddress: index [
	^ ExternalAddress new fromInteger: (self longAt: index*4+16r20)
]

{ #category : #transmiting }
Realtek8139PCIDevice >> transmitStartAddress: index put: address [
	^ self longAt: index*4+16r20 put: address asInteger
]

{ #category : #transmiting }
Realtek8139PCIDevice >> transmitStatus: index [
	"The read-only bits (CRS, TABT, OWC, CDH, NCC3-0, TOK, TUN) will be cleared
	by the RTL8139C(L) when the Transmit Byte Count (bit12-0) in the corresponding
	Tx descriptor is written. It is not affected when software writes to these bits.
	These registers are only permitted to write by double-word access. After a software
	reset, all bits except the OWN bit are reset to 0"
	^ self longAt: index*4+16r10
]

{ #category : #transmiting }
Realtek8139PCIDevice >> transmitStatus: index put: value [
	^ self longAt: index*4+16r10 put: value
]
