'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #Realtek8139PCIDevice category: 'SqueakNOS-Devices-Network'!
NetworkingDevice subclass: #Realtek8139PCIDevice
	instanceVariableNames: 'nextTxIndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Network'!
!Realtek8139PCIDevice commentStamp: '<historical>' prior: 0!

Realtek offers somehow good information

http://www.realtek.com.tw/downloads/downloads1-1.aspx?lineid=1

self installOn: Computer current
!

!Realtek8139PCIDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
command
	"This register is used for issuing commands to the RTL8139C(L).
	These commands are issued by setting the corresponding bits for
	the function. A global software reset along with individual reset
	and enable/disable for transmitter and receiver are provided here."
	^ self byteAt: 16r37
! !

!Realtek8139PCIDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
command: aByte
	^ self byteAt: 16r37 put: aByte
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
earlyReceiveByteCount
	^ self shortAt: 16r34
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
earlyReceiveStatus
	^ self byteAt: 16r36
! !

!Realtek8139PCIDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleIRQ
	| statusOnEntry |
	statusOnEntry := self interruptStatus.
	"Status contents: self statusString."	"Status := TextMorph new openInWorld"
	[	self receiveInterruptPending ifTrue: [self handleReceiveInterrupt].
		self receiveBufferOverflowInterruptPending ifTrue: [self handleReceiveBufferFull].
	] ifError: [:ex | Transcript show: ex; cr; flush].

	"reset every interrupt, as they where on entry to avoid race conditions"
	self interruptStatus: statusOnEntry.
! !

!Realtek8139PCIDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
handleReceiveInterrupt
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

! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasReceiveBufferEmpty
	^ self command anyMask: 1
! !

!Realtek8139PCIDevice methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
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
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptMask
	"IMR - Interrupt Mask Register"
	^ self shortAt: 16r3C
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptMask: aShort
	^ self shortAt: 16r3C put: aShort
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptStatus
	"ISR - Interrupt Status Register"
	^ self shortAt: 16r3E
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptStatus: aShort
	^ self shortAt: 16r3E put: aShort
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptStatusBit: index
	^ self interruptStatus anyMask: 1 << index
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
logicalAddressFilter
	^ (self longAt: 16rC) << 32 + (self longAt: 8)
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
logicalAddressFilter: anInteger
	self longAt: 16rC put: anInteger // 16r100000000.
	^ self longAt: 8 put: anInteger \\ 16r100000000
! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
macAddress
	| answer |
	answer := self shortAt: 4.
	answer := answer << 32 + (self longAt: 0).
	^ EthernetAddress fromInteger: answer

! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
missedPacketCounter
	"MPC - Missed Packet Counter: Indicates the number of packets discarded
	due to rx FIFO overflow. It is a 24-bit counter. After s/w reset, MPC is
	cleared. Only the lower 3 bytes are valid. When any value is written,
	MPC will be reset."
	^ self longAt: 16r4C

! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
missedPacketCounterReset
	^ self longAt: 16r4C put: 0

! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveBuffer
	^ ExternalAddress new fromInteger: self receiveBufferAddress
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveBufferAddress
	"RBSTART"
	^ self longAt: 16r30
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveBufferAddress: anExternalAddressOrInteger
	^ self longAt: 16r30 put: anExternalAddressOrInteger asInteger
! !

!Realtek8139PCIDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveBufferOverflowInterruptPending
	^ self interruptStatusBit: 4
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveConfiguration
	"RCR - Receive Configuration Register"
	^ self longAt: 16r44
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveConfiguration: aLong
	^ self longAt: 16r44 put: aLong
! !

!Realtek8139PCIDevice methodsFor:  'irq handling' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveInterruptPending
	^ self interruptStatusBit: 0
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveReadAddress
	^ ExternalAddress new fromInteger: self receiveReadOffset + 16r10 \\ 16r10000 + self receiveBufferAddress
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveReadOffset
	"CAPR - Current Address of Packet Read.
	The initial value is 0FFF0h"
	^ self shortAt: 16r38
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveReadOffset: aShort
	^ self shortAt: 16r38 put: aShort
! !

!Realtek8139PCIDevice methodsFor:  'receiving' stamp: 'KenD 28/Jun/2026 13:32:24'!
receiveWriteOffset
	"CBA - Current Buffer Address
	The initial value is 0000h. It reflect total received byte-count in the rx buffer."
	^ self shortAt: 16r3A
! !

!Realtek8139PCIDevice methodsFor:  'commands' stamp: 'KenD 28/Jun/2026 13:32:24'!
reset
	"Reset: Setting to 1 forces the RTL8139C(L) to a software reset state
	which disables the transmitter and receiver, reinitializes the FIFOs,
	resets the system buffer pointer to the initial value (Tx buffer is at
	TSAD0, Rx buffer is empty). The values of IDR0-5 and MAR0-7 and
	PCI configuration space will have no changes. This bit is 1 during the
	reset operation, and is cleared to 0 by the RTL8139C(L) when the reset
	operation is complete."

	self command: 128.
	[self command anyMask: 128] whileTrue.
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
sendNow: anEthernetPacket
	| oldTxIndex |
	nextTxIndex := (oldTxIndex := nextTxIndex) + 1 \\ 4.	"race condition here if two threads want to do this"
	^ self sendNow: anEthernetPacket on: oldTxIndex.
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
sendNow: anEthernetPacket on: descriptorIndex
	| str |
	str := anEthernetPacket asString padRightTo: 60.
	(self transmitStartAddress: descriptorIndex) stringAt: 1 put: str.
	self transmitStatus: descriptorIndex put: str size.
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusString
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

! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
timerCount
	"TCTR - Timer Count Register: This register contains a 32-bit
	general-purpose timer. Writing any value to this 32-bit register will
	reset the original timer and begin to count from zero."
	^ self longAt: 16r48

! !

!Realtek8139PCIDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
timerCountReset
	^ self longAt: 16r48 put: 0

! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitConfiguration
	"TCR - Transmit Configuration Register"
	^ self longAt: 16r40
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitConfiguration: aLong
	^ self longAt: 16r40 put: aLong
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitStartAddress: index
	^ ExternalAddress new fromInteger: (self longAt: index*4+16r20)
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitStartAddress: index put: address
	^ self longAt: index*4+16r20 put: address asInteger
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitStatus: index
	"The read-only bits (CRS, TABT, OWC, CDH, NCC3-0, TOK, TUN) will be cleared
	by the RTL8139C(L) when the Transmit Byte Count (bit12-0) in the corresponding
	Tx descriptor is written. It is not affected when software writes to these bits.
	These registers are only permitted to write by double-word access. After a software
	reset, all bits except the OWN bit are reset to 0"
	^ self longAt: index*4+16r10
! !

!Realtek8139PCIDevice methodsFor:  'transmiting' stamp: 'KenD 28/Jun/2026 13:32:24'!
transmitStatus: index put: value
	^ self longAt: index*4+16r10 put: value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Realtek8139PCIDevice class' category: 'SqueakNOS-Devices-Network'!
Realtek8139PCIDevice class
	instanceVariableNames: ''!

!Realtek8139PCIDevice class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceId
	^ 16r8139
! !

!Realtek8139PCIDevice class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPCIEntry: aPCIBusEntry
	^self atMemoryAddress: aPCIBusEntry allMemoryRanges first key.

! !

!Realtek8139PCIDevice class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
vendorId
	^ 16r10EC
! !


Realtek8139PCIDevice initialize!

