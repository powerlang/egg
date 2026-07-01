'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PCIBusEntry category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #PCIBusEntry
	instanceVariableNames: 'bus device function'
	classVariableNames: 'VendorsAndDevices'
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!PCIBusEntry commentStamp: '<historical>' prior: 0!

I represent a device 'function' (DF) 'configuration space' (CS) in the PCI bus. (*guessing*) Simple devices have only one function.
In PCI, each DF is assigned an ID, which is used to access its associated CS, through IO ports 0xCF8 and 0xCFC. 

The CS provides 64 bytes of fixed fields that give info about the device: device ID, vendor ID, Status, etc. One very important info the CS give are the 6 Base Address Registers (BARs). The BIOS or OS assigns mmaped addresses or IO ports to the DF, and saves those addresses in the BAR fields of the CS. To obtain those addresses, the driver just reads the BAR fields. Those fields are encoded: if it is an io port, the first bit is 1, and bits 3 to 32 are the base io address (4 byte aligned). Else, if first bit is 0,  it is an mmaped address, and bits 5 to 32 tell the base address (16-byte aligned).

The ID of a DF is split in 8 bit bus number, 5 bit device number and 3 bit function number.

Some examples:

"To scan the bus"		PCIBusEntry allValid
"To get memory ranges"	PCIBusEntry allValid collect: [:e | e allMemoryRanges]
"To get IO ranges"		PCIBusEntry allValid collect: [:e | e allIORanges]

Information on PCIBus

GRUB Legacy source (GRUB 0.97) netboot/pci.c

Info from pages:
http://www.mega-tokyo.com/osfaq/Where%20can%20I%20find%20programming%20info%20on%20PCI%3F
http://www.cs.nmsu.edu/~pfeiffer/classes/473/notes/pci.html

Specs from:
http://perso.orange.fr/pierrelib/buses/index.htm
Specially chapter  6 from PCI Local Bus Specification (v2.2 for example)

Vendors and device list:
http://www.pcidatabase.com/

Class codes and Class sub codes:
http://www.acm.uiuc.edu/sigops/roll_your_own/7.c.1.html
http://cvs.opensolaris.org/source/raw/on/usr/src/common/pci/pci_strings.c

Still missing in this implementation (may be more things are missing):
- Memory and I/O map support (moving PCI devices around in memory and I/O space)
- Class and subClass code strings (just for readability).
- Capabilities List (chapter 6.7 and Appendix H of PCI Local Bus Spec)
- PCI Exansion ROMs (chapter 6.3 of PCI Local Bus Spec)
- Vital Product Data (Appendix I of PCI Local Bus Spec)
- Message Signaled Interrupts (chapter 6.8 of PCI Local Bus Spec)

!

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
DEVSELtiming
	" bits 9,10 - These bits encode the timing of DEVSEL#. Section 3.6.1. of
	PCI Local Bus Spec specifies three allowable timings for assertion of DEVSEL#.
	These are encoded as 00b for fast, 01b for medium, and 10b for slow (11b is
	reserved). These bits are read-only and must indicate the slowest time
	that a device asserts DEVSEL# for any bus command except
	Configuration Read and Configuration Write."

	^ self status >> 9 bitAnd: 3
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
MaxLat
	^ self configByte: 16r3F
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
MinGnt
	^ self configByte: 16r3E
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
allIORanges
	| answer addr |

	answer := OrderedCollection new: 6.
	0 to: 5 do: [:i |
		addr := self baseAddressRegister: i.
		addr even
			ifTrue: ["is memory"]
			ifFalse: [
				answer add: 
					(addr bitAnd: 3 bitInvert) -> (self baseIOAddressRegisterSize: i original: addr).
			]].

	^ answer
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
allMemoryRanges
	| answer addr |

	answer := OrderedCollection new: 6.
	0 to: 5 do: [:i |
		addr := self baseAddressRegister: i.
		(addr ~= 0 and: [addr even])
			ifTrue: ["is memory"
				answer add: 
					(addr bitAnd: 3 bitInvert) -> (self baseMemoryAddressRegisterSize: i original: addr).
			]].

	^ answer
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseAddressRegister: index
	index > 5 ifTrue: [self errorSubscriptBounds: index].
	^ self configLong: index * 4 + 16
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseAddressRegister: index put: address
	index > 5 ifTrue: [self errorSubscriptBounds: index].
	^ self configLong: index * 4 + 16 put: address
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseAddressRegisterSize: index
	| original |
	
	original := self baseAddressRegister: index.
	original even
		ifTrue: [^ self baseMemoryAddressRegisterSize: index original: original]
		ifFalse: [^ self baseIOAddressRegisterSize: index original: original]

! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseIOAddress: index
	| addr |
	addr := self baseAddressRegister: index.
	addr even ifTrue: [^self halt "is memory"].
	^addr bitAnd: 3 bitInvert

! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseIOAddressRegisterSize: index original: original
	| enabled answer |

	enabled := self hasIOEnabled.

	self baseAddressRegister: index put: 16rFFFFFFFF.
	answer := self baseAddressRegister: index.
	self baseAddressRegister: index put: original.

	enabled ifTrue: [self enableIO].

	(answer noMask: 16rFFFF0000)
		ifTrue: [answer := answer + 16rFFFF0000].

	^ ((answer bitAnd: 3 bitInvert) bitInvert + 1) bitAnd: 16rFFFFFFFF

! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseMemory32AddressRegisterSize: index original: original
	| enabled answer |

	enabled := self hasMemoryEnabled.

	self baseAddressRegister: index put: 16rFFFFFFFF.
	answer := self baseAddressRegister: index.
	self baseAddressRegister: index put: original.

	enabled ifTrue: [self enableMemory].

	^ ((answer bitAnd: 15 bitInvert) bitInvert + 1) bitAnd: 16rFFFFFFFF

! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseMemory64AddressRegisterSize: index original: originalLo
	| enabled answer originalHi |

	enabled := self hasMemoryEnabled.

	originalHi := self baseAddressRegister: index+1.

	self baseAddressRegister: index put: 16rFFFFFFFF.
	self baseAddressRegister: index+1 put: 16rFFFFFFFF.

	"from spec it's not clear if reg at index+1 has lower bits correct or not. From testing, apparently it has"
	answer := (self baseAddressRegister: index + 1) << 32 + (self baseAddressRegister: index).

	self baseAddressRegister: index put: originalLo.
	self baseAddressRegister: index+1 put: originalHi.

	enabled ifTrue: [self enableMemory].

	^ ((answer bitAnd: 15 bitInvert) bitInvert + 1) bitAnd: 16rFFFFFFFFFFFFFFFF

! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
baseMemoryAddressRegisterSize: index original: original
	| size |
	original isZero ifTrue: [^ 0].

	size := original bitAnd: 2r110.
	
	size = 2r100 ifTrue: [^ self baseMemory64AddressRegisterSize: index original: original].
	size = 2r110 ifTrue: ["reserved mode" ^ self error: 'Unknown memory model'].

	" can be 2r000 (32 bits) or 2r010 (32 bits < 1Meg) "
	^ self baseMemory32AddressRegisterSize: index original: original.
! !

!PCIBusEntry methodsFor:  'accessing - bist' stamp: 'KenD 28/Jun/2026 13:32:24'!
bistCompletionCode
	" bits 0-3 - A value of 0 means the device has passed its test. Non-zero values
	mean the device failed. Device-specific failure codes can be encoded
	in the non-zero value."
	^ self builtInSelfTest bitAnd: 15
! !

!PCIBusEntry methodsFor:  'accessing - bist' stamp: 'KenD 28/Jun/2026 13:32:24'!
bistHasFinished
	" bit 6 - Write a 1 to invoke BIST. Device resets the bit when BIST is complete.
	Software should fail the device if BIST is not complete after 2 seconds."

	^ (self builtInSelfTest anyMask: 64) not
! !

!PCIBusEntry methodsFor:  'accessing - bist' stamp: 'KenD 28/Jun/2026 13:32:24'!
builtInSelfTest
	^ self configByte: 15
! !

!PCIBusEntry methodsFor:  'accessing - bist' stamp: 'KenD 28/Jun/2026 13:32:24'!
builtInSelfTest: byte
	^ self configByte: 15 put: byte
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
bus: aNumber
	bus := aNumber
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
cacheLineSize
	^ self configByte: 12
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
capabilitiesPointer
	^ self configByte: 16r34
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
cardbusCISPointer
	^ self configLong: 16r28
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
classCode
	^ self configByte: 11
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
classSubCode
	^ self configByte: 10
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
command
	^ self configShort: 4
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
command: aNumber
	^ self configShort: 4 put: aNumber
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
configByte: index
	self longAt: 0 put: (self translate: index).
	^ self byteAt: 4 + (index bitAnd: 3) 
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
configByte: index put: aNumber
	self longAt: 0 put: (self translate: index).
	^ self byteAt: 4 + (index bitAnd: 3) put: aNumber
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
configLong: index
	self longAt: 0 put: (self translate: index).
	^ self longAt: 4 
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
configLong: index put: aNumber
	self longAt: 0 put: (self translate: index).
	^ self longAt: 4 put: aNumber
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
configShort: index
	self longAt: 0 put: (self translate: index).
	^ self shortAt: 4 + (index bitAnd: 2) 
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
configShort: index put: aNumber
	self longAt: 0 put: (self translate: index).
	^ self shortAt: 4 + (index bitAnd: 2) put: aNumber
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
detectedParityError
	" bit 15 - This bit must be set by the device whenever it detects a parity error,
	even if parity error handling is disabled (as controlled by bit 6 in the
	Command register)."

	^ self statusBit: 15
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
device: aNumber
	device := aNumber
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceId
	^ self configShort: 2
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableBusMastering
	^ self disableCommandBit: 2
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableCommandBit: bit
	^ self command: (self command bitAnd: 16rFFFF - (1 << bit))
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableFastBackToBack
	^ self disableCommandBit: 9
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableIO
	^ self disableCommandBit: 0
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableMemory
	^ self disableCommandBit: 1
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableMemoryWriteAndInvalidateEnabled
	^ self disableCommandBit: 4
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableParityErrorGeneration
	^ self disableCommandBit: 6
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableSpecialCycle
	^ self disableCommandBit: 3
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableStepping
	^ self disableCommandBit: 7
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableSystemErrorGeneration
	^ self disableCommandBit: 8
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableVGAPaletteSnooping
	^ self disableCommandBit: 5
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
disconnect
	^ self command: 0
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableBusMastering
	^ self enableCommandBit: 2
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCommandBit: bit
	^ self command: (self command bitOr: 1 << bit)
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableFastBackToBack
	^ self enableCommandBit: 9
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableIO
	^ self enableCommandBit: 0
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableMemory
	^ self enableCommandBit: 1
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableMemoryWriteAndInvalidateEnabled
	^ self enableCommandBit: 4
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableParityErrorGeneration
	^ self enableCommandBit: 6
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableSpecialCycle
	^ self enableCommandBit: 3
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableStepping
	^ self enableCommandBit: 7
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableSystemErrorGeneration
	^ self enableCommandBit: 8
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableVGAPaletteSnooping
	^ self enableCommandBit: 5
! !

!PCIBusEntry methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
formatedConfigurationRegisters
	^ '0h - VENDOR ID: ' , self vendorId hex , ' DEV ID: ' , self deviceId hex , String cr
		, '4h - COMMAND: ' , self command hex , ' STATUS: ' , self status hex , String cr
		, '8h - REV ID: ' , self revisionId hex , ' CLS CODE: ' , self classCode hex
		, String cr , 'Ch - CACHE LINE S: ' , self cacheLineSize hex , ' LAT TIMER: '
		, self latencyTimer hex , ' HDR TYPE: ' , self headerType hex , ' BIST: '
		, self builtInSelfTest hex , String cr , '10h - BAR0: '
		, (self baseAddressRegister: 0) hex , String cr , '14h - BAR1: '
		, (self baseAddressRegister: 1) hex , String cr , '18h - BAR2: '
		, (self baseAddressRegister: 2) hex , String cr , '1Ch - BAR3: '
		, (self baseAddressRegister: 3) hex , String cr , '20h - BAR4: '
		, (self baseAddressRegister: 4) hex , String cr , '24h - BAR5: '
		, (self baseAddressRegister: 5) hex , String cr , 'INTR LINE: '
		, self interruptLine printString
! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
function: aNumber
	function := aNumber
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasBusMasteringEnabled
	"bit 2 - Controls a device's ability to act as a master on the PCI bus. A value
	of 0 disables the device from generating PCI accesses. A value of 1
	allows the device to behave as a bus master. State after RST# is 0."

	^ self testCommandBit: 2
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasCapabilitiesList
	" bit 4 - This optional read-only bit indicates whether or not this device
	implements the pointer for a New Capabilities linked list at offset 34h.
	A value of zero indicates that no New Capabilities linked list is
	available. A value of one indicates that the value read at offset 34h is a
	pointer in Configuration Space to a linked list of new capabilities. Refer
	to Section 6.7. of PCI Local Bus Spec for details on New Capabilities."

	^ self statusBit: 4
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasFastBackToBackEnabled
	"bit 9 - This optional read/write bit controls whether or not a master can do
	fast back-to-back transactions to different devices. Initialization
	software will set the bit if all targets are fast back-to-back capable. A
	value of 1 means the master is allowed to generate fast back-to-back
	transactions to different agents as described in Section 3.4.2. A value
	of 0 means fast back-to-back transactions are only allowed to the
	same agent. This bit\u2019s state after RST# is 0."

	^ self testCommandBit: 9
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasIOEnabled
	"bit 0 - Controls a device\u2019s response to I/O Space accesses. A value of 0
	disables the device response. A value of 1 allows the device to
	respond to I/O Space accesses. State after RST# is 0."

	^ self testCommandBit: 0
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasMasterDataParityError
	" bit 8 - This bit is only implemented by bus masters. It is set when three
	conditions are met: 1) the bus agent asserted PERR# itself (on a read)
	or observed PERR# asserted (on a write); 2) the agent setting the bit
	acted as the bus master for the operation in which the error occurred;
	and 3) the Parity Error Response bit (Command register) is set."

	^ self statusBit: 8
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasMemoryEnabled
	"bit 1 - Controls a device's response to Memory Space accesses. A value of
	0 disables the device response. A value of 1 allows the device to
	respond to Memory Space accesses. State after RST# is 0."

	^ self testCommandBit: 1
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasMemoryWriteAndInvalidateEnabled
	"bit 4 - This is an enable bit for using the Memory Write and Invalidate
	command. When this bit is 1, masters may generate the command.
	When it is 0, Memory Write must be used instead. State after RST# is
	0. This bit must be implemented by master devices that can generate
	the Memory Write and Invalidate command."

	^ self testCommandBit: 4
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasParityErrorGenerationEnabled
	"bit 6 - This bit controls the device\u2019s response to parity errors. When the bit is
	set, the device must take its normal action when a parity error is
	detected. When the bit is 0, the device sets its Detected Parity Error
	status bit (bit 15 in the Status register) when an error is detected, but
	does not assert PERR# and continues normal operation. This bit\u2019s
	state after RST# is 0. Devices that check parity must implement this
	bit. Devices are still required to generate parity even if parity checking
	is disabled."

	^ self testCommandBit: 6
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasSpecialCycleEnabled
	"bit 3 - Controls a device's action on Special Cycle operations. A value of 0
	causes the device to ignore all Special Cycle operations. A value of 1
	allows the device to monitor Special Cycle operations. State after
	RST# is 0."

	^ self testCommandBit: 3
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasSteppingEnabled
	"bit 7 - This bit is used to control whether or not a device does address/data
	stepping. Devices that never do stepping must hardwire this bit to 0.
	Devices that always do stepping must hardwire this bit to 1. Devices
	that can do either, must make this bit read/write and have it initialize to
	1 after RST#."

	^ self testCommandBit: 7
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasSystemErrorGenerationEnabled
	"bit 8 - This bit is used to control whether or not a device does address/data
	stepping. Devices that never do stepping must hardwire this bit to 0.
	Devices that always do stepping must hardwire this bit to 1. Devices
	that can do either, must make this bit read/write and have it initialize to
	1 after RST#. SERR is signaled by hardware for Unrecoverable errors."

	^ self testCommandBit: 8
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
hasVGAPaletteSnoopingEnabled
	"bit 5 - This bit controls how VGA compatible and graphics devices handle
	accesses to VGA palette registers. When this bit is 1, palette
	snooping is enabled (i.e., the device does not respond to palette
	register writes and snoops the data). When the bit is 0, the device
	should treat palette write accesses like all other accesses. VGA
	compatible devices should implement this bit. Refer to Section 3.10.
	of PCI Local Bus Spec for more details on VGA palette snooping."

	^ self testCommandBit: 5
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
headerType
	^ self configByte: 14
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptLine
	^ self configByte: 16r3C
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
interruptPin
	^ self configByte: 16r3D
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
is66MHzCapable
	" bit 5 - This optional read-only bit indicates whether or not this device is
	capable of running at 66 MHz as defined in Chapter 7 of PCI Local Bus Spec.
	A value of zero indicates 33 MHz. A value of 1 indicates that the device is 66 MHz
	capable."

	^ self statusBit: 5
! !

!PCIBusEntry methodsFor:  'accessing - bist' stamp: 'KenD 28/Jun/2026 13:32:24'!
isBistCapable
	" bit 7 - Return 1 if device supports BIST. Return 0 if the device is not BIST
	capable."

	^ self builtInSelfTest anyMask: 128
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
isFastBackToBackCapable
	" bit 7 - This optional read-only bit indicates whether or not the target is
	capable of accepting fast back-to-back transactions when the
	transactions are not to the same agent. This bit can be set to 1 if the
	device can accept these transactions and must be set to 0 otherwise.
	Refer to Section 3.4.2. of PCI Local Bus Spec for a complete description
	of requirements for setting this bit."

	^ self statusBit: 7
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
isMultiFunction
	^ self headerType anyMask: 16r80
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
isValid
	| vendor |
	vendor := self vendorId.
	^ vendor ~= 0 and: [vendor ~= 16rFFFF].
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
latencyTimer
	^ self configByte: 13
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
latencyTimer: aByte
	^ self configByte: 13 put: aByte
! !

!PCIBusEntry methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: strm
	strm
		nextPutAll: self class name;
		nextPut: $:;
		space;
		nextPutAll: bus printStringHex;
		nextPut: $:;
		nextPutAll: device printStringHex;
		nextPut: $.;
		nextPutAll: function printString;
		space;
		nextPutAll: self stringForVendorAndDevice;
		cr;
		nextPutAll: self formatedConfigurationRegisters
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
programmingInterface
	^ self configByte: 9
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
receivedMasterAbort
	" bit 13 - This bit must be set by a master device whenever its transaction is
	terminated with Target-Abort. All master devices must implement this
	bit."

	^ self statusBit: 13
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
receivedTargetAbort
	" bit 12 - This bit must be set by a master device whenever its transaction is
	terminated with Target-Abort. All master devices must implement this
	bit."

	^ self statusBit: 12
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetDetectedParityError
	^ self resetStatusBit: 15
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetMasterDataParityError
	^ self resetStatusBit: 8
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetReceivedMasterAbort
	^ self resetStatusBit: 13
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetReceivedTargetAbort
	^ self resetStatusBit: 12
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetSignaledSystemError
	^ self resetStatusBit: 14
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetSignaledTargetAbort
	^ self resetStatusBit: 11
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetStatusBit: bit
	^ self status: 1 << bit
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
revisionId
	^ self configByte: 8
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
romAddressRegister
	^ self configLong: 16r30
! !

!PCIBusEntry methodsFor:  'accessing - addresses map' stamp: 'KenD 28/Jun/2026 13:32:24'!
romAddressRegister: addr
	^ self configLong: 16r30 put: addr
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
signaledSystemError
	" bit 14 - This bit must be set whenever the device asserts SERR#. Devices
	who will never assert SERR# do not need to implement this bit."

	^ self statusBit: 14
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
signaledTargetAbort
	" bit 11 - This bit must be set by a target device whenever it terminates a
	transaction with Target-Abort. Devices that will never signal Target-
	Abort do not need to implement this bit."

	^ self statusBit: 11
! !

!PCIBusEntry methodsFor:  'accessing - bist' stamp: 'KenD 28/Jun/2026 13:32:24'!
startBist
	" bit 6 - Write a 1 to invoke BIST. Device resets the bit when BIST is complete.
	Software should fail the device if BIST is not complete after 2 seconds."

	^ self builtInSelfTest: (self builtInSelfTest bitOr: 64)
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
status
	^ self configShort: 6
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
status: word
	^ self configShort: 6 put: word
! !

!PCIBusEntry methodsFor:  'accessing - status' stamp: 'KenD 28/Jun/2026 13:32:24'!
statusBit: bit
	^ self status anyMask: 1 << bit
! !

!PCIBusEntry methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
stringForVendorAndDevice
	^ self class stringForVendor: self vendorId device: self deviceId
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
subsystemId
	^ self configShort: 16r2E
! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
subsystemVendorId
	^ self configShort: 16r2C
! !

!PCIBusEntry methodsFor:  'accessing - command register' stamp: 'KenD 28/Jun/2026 13:32:24'!
testCommandBit: bit
	^ self command anyMask: 1 << bit

! !

!PCIBusEntry methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
translate: index
	^ 16r80000000 + (bus << 16) + (device << 11) + (function << 8) + (index bitAnd: 16rFC)

! !

!PCIBusEntry methodsFor:  'accessing - general config' stamp: 'KenD 28/Jun/2026 13:32:24'!
vendorId
	^ self configShort: 0
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PCIBusEntry class' category: 'SqueakNOS-Devices-Base'!
PCIBusEntry class
	instanceVariableNames: 'VendorsAndDevices'!

!PCIBusEntry class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
allValid
	" PCIDevice allValid "
	| answer scanner |
	answer := OrderedCollection new.
	scanner := self bus: 0 device: 0 function: 0.
	0 to: 255 do: [:bus |
		0 to: 31 do: [:device |
			scanner
				bus: bus;
				device: device;
				function: 0.
			scanner isValid ifTrue: [
				answer add: scanner copy.
				scanner isMultiFunction ifTrue: [
					1 to: 7 do: [:function | 
						scanner function: function.
						scanner isValid ifTrue: [answer add: scanner copy]
						]
					]
			]
		]
	].
	^ answer
! !

!PCIBusEntry class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
bus: bus device: device function: function
	^ (self onPort: 16rCF8)
		bus: bus;
		device: device;
		function: function.
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	"
	PCIBusEntry initialize
	"
	self initializeVendorsAndDevicesList
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeVendorsAndDevicesList
	" self initializeVendorsAndDevicesList "
	^VendorsAndDevices := self parseVendorsAndDevicesFromPCIIDsDatabase: (ReadStream on: self vendorsAndDevicesData).
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeVendorsAndDevicesMethod
	" self initializeVendorsAndDevicesMethod "
	" The old csv file was downloaded from http://www.pcidatabase.com/reports.php?type=csv "
	" We are currently using a more complete database from http://pci-ids.ucw.cz/ "
	| file data |
	file := StandardFileStream readOnlyFileNamed: 'info/Buses/pci/pci.ids'.

	data := ZLibWriteStream on: String new.
	data nextPutAll: file contents.
	data close.
	self class compile: 'vendorsAndDevicesZLibData',String cr,'   ^ ', data encodedStream contents storeString.
	
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
numberFromString: str
	| strm head base |
	strm := ReadStream on: str asUppercase.
	strm peekFor: $".
	head := strm next: 2.
	head size > 1
		ifTrue: [
			base := 10.
			head = '0X'
				ifTrue: [base := 16]
				ifFalse: [
					head = '&#' ifFalse: [strm skip: -2]]]
		ifFalse: [strm skip: -1].
	^ [Number readFrom: strm base: base] ifError: [0]
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
parseVendorsAndDevicesFromPCIDatabase: strm
	" The csv file was downloaded from http://www.pcidatabase.com/reports.php?type=csv "
	| line fields vendors vendor device |
	vendors := Dictionary new.
	[line := strm upTo: Character lf.
	line notNil and: [line size > 0]] whileTrue: [
		fields := (line findBetweenSubStrs: #('","')) asArray.
		fields size >= 2
			ifTrue: [
				vendor := self numberFromString: (fields at: 1).
				device := self numberFromString: (fields at: 2).
				vendors at: (vendor << 32 + device) put: fields.
				vendors at: vendor put: (fields at: 3)]
			ifFalse: [Transcript show: line; cr].
	].

	^ vendors
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
parseVendorsAndDevicesFromPCIIDsDatabase: strm
	" The csv file was downloaded from http://pci-ids.ucw.cz/  "
	"# Syntax:
	# vendor  vendor_name
	#	device  device_name				<-- single tab
	#		subvendor subdevice  subsystem_name	<-- two tabs
	"

	| vendors tok vendorId subId deviceId description |
	vendors := Dictionary new.
	[strm atEnd] whileFalse: [
		tok := strm peek.
		tok == Character tab
			ifTrue: [	" starts with tab "
				strm next.
				tok := strm peek.
				tok == Character tab
					ifTrue: [	"#		subvendor subdevice  subsystem_name"
						strm next.
						subId := strm upTo: Character space.
						strm skipSeparators.
						subId := subId, (strm upTo: Character space).
						strm upTo: Character lf.
					] ifFalse: [	"#	device  device_name"
						deviceId := (strm upTo: Character space) asUppercase.
						deviceId := Number readFrom: deviceId base: 16.
						strm skipSeparators.
						description := strm upTo: Character lf.
						vendors at: vendorId << 32 + deviceId put: description.
					]
			] ifFalse: [	" doesn't start with tab "
				tok == $C
					ifTrue: [	" device classes, not supported yet. Assume end "
						strm setToEnd.
					] ifFalse: [
						(tok == $# or: [tok == Character lf])
							ifTrue: [strm upTo: Character lf]
							ifFalse: [ "# vendorId vendor name "
								vendorId := (strm upTo: Character space) asUppercase.
								vendorId := Number readFrom: vendorId base: 16.
								strm skipSeparators.
								description := strm upTo: Character lf.
								vendors at: vendorId put: description.
							]
					]
			]
	].

	^ vendors
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
pciidsLocation
	^'http://pci-ids.ucw.cz/pci.ids'
! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
stringForVendor: vendorId device: deviceId
	| vendor device |
	vendor := VendorsAndDevices
		at: vendorId
		ifAbsent: ['unknown ', vendorId hex].
	device := VendorsAndDevices
		at: vendorId << 32 + deviceId
		ifAbsent: ['unknown ', deviceId hex].
	^ 'Vendor: ', vendor, 'id()', vendorId hex printString, 'Device: ', device, 'id()', deviceId hex printString

! !

!PCIBusEntry class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
vendorsAndDevicesData
	"
	PCIBusEntry vendorsAndDevicesData
	"
	^self pciidsLocation asUrl retrieveContents contents
! !


PCIBusEntry initialize!

