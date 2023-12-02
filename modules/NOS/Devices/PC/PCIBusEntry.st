"
I represent a device 'function' (DF) 'configuration space' (CS) in the PCI bus. (*guessing*) Simple devices have only one function.
In PCI, each DF is assigned an ID, which is used to access its associated CS, through IO ports 0xCF8 and 0xCFC. 

The CS provides 64 bytes of fixed fields that give info about the device: device ID, vendor ID, Status, etc. One very important info the CS give are the 6 Base Address Registers (BARs). The BIOS or OS assigns mmaped addresses or IO ports to the DF, and saves those addresses in the BAR fields of the CS. To obtain those addresses, the driver just reads the BAR fields. Those fields are encoded: if it is an io port, the first bit is 1, and bits 3 to 32 are the base io address (4 byte aligned). Else, if first bit is 0,  it is an mmaped address, and bits 5 to 32 tell the base address (16-byte aligned).

The ID of a DF is split in 8 bit bus number, 5 bit device number and 3 bit function number.

Some examples:

""To scan the bus""		PCIBusEntry allValid
""To get memory ranges""	PCIBusEntry allValid collect: [:e | e allMemoryRanges]
""To get IO ranges""		PCIBusEntry allValid collect: [:e | e allIORanges]

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

"
Class {
	#name : #PCIBusEntry,
	#superclass : #HardwareDevice,
	#instVars : [
		'bus',
		'device',
		'function'
	],
	#classVars : [
		'VendorsAndDevices'
	],
	#category : 'SqueakNOS-Devices-Base'
}

{ #category : #'instance creation' }
PCIBusEntry class >> allValid [
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
]

{ #category : #'instance creation' }
PCIBusEntry class >> bus: bus device: device function: function [
	^ (self onPort: 16rCF8)
		bus: bus;
		device: device;
		function: function.
]

{ #category : #initialization }
PCIBusEntry class >> initialize [
	"
	PCIBusEntry initialize
	"
	self initializeVendorsAndDevicesList
]

{ #category : #initialization }
PCIBusEntry class >> initializeVendorsAndDevicesList [
	" self initializeVendorsAndDevicesList "
	^VendorsAndDevices := self parseVendorsAndDevicesFromPCIIDsDatabase: (ReadStream on: self vendorsAndDevicesData).
]

{ #category : #initialization }
PCIBusEntry class >> initializeVendorsAndDevicesMethod [
	" self initializeVendorsAndDevicesMethod "
	" The old csv file was downloaded from http://www.pcidatabase.com/reports.php?type=csv "
	" We are currently using a more complete database from http://pci-ids.ucw.cz/ "
	| file data |
	file := StandardFileStream readOnlyFileNamed: 'info/Buses/pci/pci.ids'.

	data := ZLibWriteStream on: String new.
	data nextPutAll: file contents.
	data close.
	self class compile: 'vendorsAndDevicesZLibData',String cr,'   ^ ', data encodedStream contents storeString.
	
]

{ #category : #initialization }
PCIBusEntry class >> numberFromString: str [
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
]

{ #category : #initialization }
PCIBusEntry class >> parseVendorsAndDevicesFromPCIDatabase: strm [
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
]

{ #category : #initialization }
PCIBusEntry class >> parseVendorsAndDevicesFromPCIIDsDatabase: strm [
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
]

{ #category : #initialization }
PCIBusEntry class >> pciidsLocation [
	^'http://pci-ids.ucw.cz/pci.ids'
]

{ #category : #initialization }
PCIBusEntry class >> stringForVendor: vendorId device: deviceId [
	| vendor device |
	vendor := VendorsAndDevices
		at: vendorId
		ifAbsent: ['unknown ', vendorId hex].
	device := VendorsAndDevices
		at: vendorId << 32 + deviceId
		ifAbsent: ['unknown ', deviceId hex].
	^ 'Vendor: ', vendor, 'id()', vendorId hex printString, 'Device: ', device, 'id()', deviceId hex printString

]

{ #category : #initialization }
PCIBusEntry class >> vendorsAndDevicesData [
	"
	PCIBusEntry vendorsAndDevicesData
	"
	^self pciidsLocation asUrl retrieveContents contents
]

{ #category : #'accessing - status' }
PCIBusEntry >> DEVSELtiming [
	" bits 9,10 - These bits encode the timing of DEVSEL#. Section 3.6.1. of
	PCI Local Bus Spec specifies three allowable timings for assertion of DEVSEL#.
	These are encoded as 00b for fast, 01b for medium, and 10b for slow (11b is
	reserved). These bits are read-only and must indicate the slowest time
	that a device asserts DEVSEL# for any bus command except
	Configuration Read and Configuration Write."

	^ self status >> 9 bitAnd: 3
]

{ #category : #'accessing - general config' }
PCIBusEntry >> MaxLat [
	^ self configByte: 16r3F
]

{ #category : #'accessing - general config' }
PCIBusEntry >> MinGnt [
	^ self configByte: 16r3E
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> allIORanges [
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
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> allMemoryRanges [
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
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseAddressRegister: index [
	index > 5 ifTrue: [self errorSubscriptBounds: index].
	^ self configLong: index * 4 + 16
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseAddressRegister: index put: address [
	index > 5 ifTrue: [self errorSubscriptBounds: index].
	^ self configLong: index * 4 + 16 put: address
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseAddressRegisterSize: index [
	| original |
	
	original := self baseAddressRegister: index.
	original even
		ifTrue: [^ self baseMemoryAddressRegisterSize: index original: original]
		ifFalse: [^ self baseIOAddressRegisterSize: index original: original]

]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseIOAddress: index [
	| addr |
	addr := self baseAddressRegister: index.
	addr even ifTrue: [^self halt "is memory"].
	^addr bitAnd: 3 bitInvert

]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseIOAddressRegisterSize: index original: original [
	| enabled answer |

	enabled := self hasIOEnabled.

	self baseAddressRegister: index put: 16rFFFFFFFF.
	answer := self baseAddressRegister: index.
	self baseAddressRegister: index put: original.

	enabled ifTrue: [self enableIO].

	(answer noMask: 16rFFFF0000)
		ifTrue: [answer := answer + 16rFFFF0000].

	^ ((answer bitAnd: 3 bitInvert) bitInvert + 1) bitAnd: 16rFFFFFFFF

]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseMemory32AddressRegisterSize: index original: original [
	| enabled answer |

	enabled := self hasMemoryEnabled.

	self baseAddressRegister: index put: 16rFFFFFFFF.
	answer := self baseAddressRegister: index.
	self baseAddressRegister: index put: original.

	enabled ifTrue: [self enableMemory].

	^ ((answer bitAnd: 15 bitInvert) bitInvert + 1) bitAnd: 16rFFFFFFFF

]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseMemory64AddressRegisterSize: index original: originalLo [
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

]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> baseMemoryAddressRegisterSize: index original: original [
	| size |
	original isZero ifTrue: [^ 0].

	size := original bitAnd: 2r110.
	
	size = 2r100 ifTrue: [^ self baseMemory64AddressRegisterSize: index original: original].
	size = 2r110 ifTrue: ["reserved mode" ^ self error: 'Unknown memory model'].

	" can be 2r000 (32 bits) or 2r010 (32 bits < 1Meg) "
	^ self baseMemory32AddressRegisterSize: index original: original.
]

{ #category : #'accessing - bist' }
PCIBusEntry >> bistCompletionCode [
	" bits 0-3 - A value of 0 means the device has passed its test. Non-zero values
	mean the device failed. Device-specific failure codes can be encoded
	in the non-zero value."
	^ self builtInSelfTest bitAnd: 15
]

{ #category : #'accessing - bist' }
PCIBusEntry >> bistHasFinished [
	" bit 6 - Write a 1 to invoke BIST. Device resets the bit when BIST is complete.
	Software should fail the device if BIST is not complete after 2 seconds."

	^ (self builtInSelfTest anyMask: 64) not
]

{ #category : #'accessing - bist' }
PCIBusEntry >> builtInSelfTest [
	^ self configByte: 15
]

{ #category : #'accessing - bist' }
PCIBusEntry >> builtInSelfTest: byte [
	^ self configByte: 15 put: byte
]

{ #category : #private }
PCIBusEntry >> bus: aNumber [
	bus := aNumber
]

{ #category : #'accessing - general config' }
PCIBusEntry >> cacheLineSize [
	^ self configByte: 12
]

{ #category : #'accessing - general config' }
PCIBusEntry >> capabilitiesPointer [
	^ self configByte: 16r34
]

{ #category : #'accessing - general config' }
PCIBusEntry >> cardbusCISPointer [
	^ self configLong: 16r28
]

{ #category : #'accessing - general config' }
PCIBusEntry >> classCode [
	^ self configByte: 11
]

{ #category : #'accessing - general config' }
PCIBusEntry >> classSubCode [
	^ self configByte: 10
]

{ #category : #'accessing - command register' }
PCIBusEntry >> command [
	^ self configShort: 4
]

{ #category : #'accessing - command register' }
PCIBusEntry >> command: aNumber [
	^ self configShort: 4 put: aNumber
]

{ #category : #private }
PCIBusEntry >> configByte: index [
	self longAt: 0 put: (self translate: index).
	^ self byteAt: 4 + (index bitAnd: 3) 
]

{ #category : #private }
PCIBusEntry >> configByte: index put: aNumber [
	self longAt: 0 put: (self translate: index).
	^ self byteAt: 4 + (index bitAnd: 3) put: aNumber
]

{ #category : #private }
PCIBusEntry >> configLong: index [
	self longAt: 0 put: (self translate: index).
	^ self longAt: 4 
]

{ #category : #private }
PCIBusEntry >> configLong: index put: aNumber [
	self longAt: 0 put: (self translate: index).
	^ self longAt: 4 put: aNumber
]

{ #category : #private }
PCIBusEntry >> configShort: index [
	self longAt: 0 put: (self translate: index).
	^ self shortAt: 4 + (index bitAnd: 2) 
]

{ #category : #private }
PCIBusEntry >> configShort: index put: aNumber [
	self longAt: 0 put: (self translate: index).
	^ self shortAt: 4 + (index bitAnd: 2) put: aNumber
]

{ #category : #'accessing - status' }
PCIBusEntry >> detectedParityError [
	" bit 15 - This bit must be set by the device whenever it detects a parity error,
	even if parity error handling is disabled (as controlled by bit 6 in the
	Command register)."

	^ self statusBit: 15
]

{ #category : #private }
PCIBusEntry >> device: aNumber [
	device := aNumber
]

{ #category : #'accessing - general config' }
PCIBusEntry >> deviceId [
	^ self configShort: 2
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableBusMastering [
	^ self disableCommandBit: 2
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableCommandBit: bit [
	^ self command: (self command bitAnd: 16rFFFF - (1 << bit))
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableFastBackToBack [
	^ self disableCommandBit: 9
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableIO [
	^ self disableCommandBit: 0
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableMemory [
	^ self disableCommandBit: 1
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableMemoryWriteAndInvalidateEnabled [
	^ self disableCommandBit: 4
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableParityErrorGeneration [
	^ self disableCommandBit: 6
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableSpecialCycle [
	^ self disableCommandBit: 3
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableStepping [
	^ self disableCommandBit: 7
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableSystemErrorGeneration [
	^ self disableCommandBit: 8
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disableVGAPaletteSnooping [
	^ self disableCommandBit: 5
]

{ #category : #'accessing - command register' }
PCIBusEntry >> disconnect [
	^ self command: 0
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableBusMastering [
	^ self enableCommandBit: 2
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableCommandBit: bit [
	^ self command: (self command bitOr: 1 << bit)
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableFastBackToBack [
	^ self enableCommandBit: 9
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableIO [
	^ self enableCommandBit: 0
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableMemory [
	^ self enableCommandBit: 1
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableMemoryWriteAndInvalidateEnabled [
	^ self enableCommandBit: 4
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableParityErrorGeneration [
	^ self enableCommandBit: 6
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableSpecialCycle [
	^ self enableCommandBit: 3
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableStepping [
	^ self enableCommandBit: 7
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableSystemErrorGeneration [
	^ self enableCommandBit: 8
]

{ #category : #'accessing - command register' }
PCIBusEntry >> enableVGAPaletteSnooping [
	^ self enableCommandBit: 5
]

{ #category : #printing }
PCIBusEntry >> formatedConfigurationRegisters [
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
]

{ #category : #private }
PCIBusEntry >> function: aNumber [
	function := aNumber
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasBusMasteringEnabled [
	"bit 2 - Controls a device's ability to act as a master on the PCI bus. A value
	of 0 disables the device from generating PCI accesses. A value of 1
	allows the device to behave as a bus master. State after RST# is 0."

	^ self testCommandBit: 2
]

{ #category : #'accessing - status' }
PCIBusEntry >> hasCapabilitiesList [
	" bit 4 - This optional read-only bit indicates whether or not this device
	implements the pointer for a New Capabilities linked list at offset 34h.
	A value of zero indicates that no New Capabilities linked list is
	available. A value of one indicates that the value read at offset 34h is a
	pointer in Configuration Space to a linked list of new capabilities. Refer
	to Section 6.7. of PCI Local Bus Spec for details on New Capabilities."

	^ self statusBit: 4
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasFastBackToBackEnabled [
	"bit 9 - This optional read/write bit controls whether or not a master can do
	fast back-to-back transactions to different devices. Initialization
	software will set the bit if all targets are fast back-to-back capable. A
	value of 1 means the master is allowed to generate fast back-to-back
	transactions to different agents as described in Section 3.4.2. A value
	of 0 means fast back-to-back transactions are only allowed to the
	same agent. This bit\u2019s state after RST# is 0."

	^ self testCommandBit: 9
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasIOEnabled [
	"bit 0 - Controls a device\u2019s response to I/O Space accesses. A value of 0
	disables the device response. A value of 1 allows the device to
	respond to I/O Space accesses. State after RST# is 0."

	^ self testCommandBit: 0
]

{ #category : #'accessing - status' }
PCIBusEntry >> hasMasterDataParityError [
	" bit 8 - This bit is only implemented by bus masters. It is set when three
	conditions are met: 1) the bus agent asserted PERR# itself (on a read)
	or observed PERR# asserted (on a write); 2) the agent setting the bit
	acted as the bus master for the operation in which the error occurred;
	and 3) the Parity Error Response bit (Command register) is set."

	^ self statusBit: 8
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasMemoryEnabled [
	"bit 1 - Controls a device's response to Memory Space accesses. A value of
	0 disables the device response. A value of 1 allows the device to
	respond to Memory Space accesses. State after RST# is 0."

	^ self testCommandBit: 1
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasMemoryWriteAndInvalidateEnabled [
	"bit 4 - This is an enable bit for using the Memory Write and Invalidate
	command. When this bit is 1, masters may generate the command.
	When it is 0, Memory Write must be used instead. State after RST# is
	0. This bit must be implemented by master devices that can generate
	the Memory Write and Invalidate command."

	^ self testCommandBit: 4
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasParityErrorGenerationEnabled [
	"bit 6 - This bit controls the device\u2019s response to parity errors. When the bit is
	set, the device must take its normal action when a parity error is
	detected. When the bit is 0, the device sets its Detected Parity Error
	status bit (bit 15 in the Status register) when an error is detected, but
	does not assert PERR# and continues normal operation. This bit\u2019s
	state after RST# is 0. Devices that check parity must implement this
	bit. Devices are still required to generate parity even if parity checking
	is disabled."

	^ self testCommandBit: 6
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasSpecialCycleEnabled [
	"bit 3 - Controls a device's action on Special Cycle operations. A value of 0
	causes the device to ignore all Special Cycle operations. A value of 1
	allows the device to monitor Special Cycle operations. State after
	RST# is 0."

	^ self testCommandBit: 3
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasSteppingEnabled [
	"bit 7 - This bit is used to control whether or not a device does address/data
	stepping. Devices that never do stepping must hardwire this bit to 0.
	Devices that always do stepping must hardwire this bit to 1. Devices
	that can do either, must make this bit read/write and have it initialize to
	1 after RST#."

	^ self testCommandBit: 7
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasSystemErrorGenerationEnabled [
	"bit 8 - This bit is used to control whether or not a device does address/data
	stepping. Devices that never do stepping must hardwire this bit to 0.
	Devices that always do stepping must hardwire this bit to 1. Devices
	that can do either, must make this bit read/write and have it initialize to
	1 after RST#. SERR is signaled by hardware for Unrecoverable errors."

	^ self testCommandBit: 8
]

{ #category : #'accessing - command register' }
PCIBusEntry >> hasVGAPaletteSnoopingEnabled [
	"bit 5 - This bit controls how VGA compatible and graphics devices handle
	accesses to VGA palette registers. When this bit is 1, palette
	snooping is enabled (i.e., the device does not respond to palette
	register writes and snoops the data). When the bit is 0, the device
	should treat palette write accesses like all other accesses. VGA
	compatible devices should implement this bit. Refer to Section 3.10.
	of PCI Local Bus Spec for more details on VGA palette snooping."

	^ self testCommandBit: 5
]

{ #category : #'accessing - general config' }
PCIBusEntry >> headerType [
	^ self configByte: 14
]

{ #category : #'accessing - general config' }
PCIBusEntry >> interruptLine [
	^ self configByte: 16r3C
]

{ #category : #'accessing - general config' }
PCIBusEntry >> interruptPin [
	^ self configByte: 16r3D
]

{ #category : #'accessing - status' }
PCIBusEntry >> is66MHzCapable [
	" bit 5 - This optional read-only bit indicates whether or not this device is
	capable of running at 66 MHz as defined in Chapter 7 of PCI Local Bus Spec.
	A value of zero indicates 33 MHz. A value of 1 indicates that the device is 66 MHz
	capable."

	^ self statusBit: 5
]

{ #category : #'accessing - bist' }
PCIBusEntry >> isBistCapable [
	" bit 7 - Return 1 if device supports BIST. Return 0 if the device is not BIST
	capable."

	^ self builtInSelfTest anyMask: 128
]

{ #category : #'accessing - status' }
PCIBusEntry >> isFastBackToBackCapable [
	" bit 7 - This optional read-only bit indicates whether or not the target is
	capable of accepting fast back-to-back transactions when the
	transactions are not to the same agent. This bit can be set to 1 if the
	device can accept these transactions and must be set to 0 otherwise.
	Refer to Section 3.4.2. of PCI Local Bus Spec for a complete description
	of requirements for setting this bit."

	^ self statusBit: 7
]

{ #category : #'accessing - general config' }
PCIBusEntry >> isMultiFunction [
	^ self headerType anyMask: 16r80
]

{ #category : #'accessing - general config' }
PCIBusEntry >> isValid [
	| vendor |
	vendor := self vendorId.
	^ vendor ~= 0 and: [vendor ~= 16rFFFF].
]

{ #category : #'accessing - general config' }
PCIBusEntry >> latencyTimer [
	^ self configByte: 13
]

{ #category : #'accessing - general config' }
PCIBusEntry >> latencyTimer: aByte [
	^ self configByte: 13 put: aByte
]

{ #category : #printing }
PCIBusEntry >> printOn: strm [
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
]

{ #category : #'accessing - general config' }
PCIBusEntry >> programmingInterface [
	^ self configByte: 9
]

{ #category : #'accessing - status' }
PCIBusEntry >> receivedMasterAbort [
	" bit 13 - This bit must be set by a master device whenever its transaction is
	terminated with Target-Abort. All master devices must implement this
	bit."

	^ self statusBit: 13
]

{ #category : #'accessing - status' }
PCIBusEntry >> receivedTargetAbort [
	" bit 12 - This bit must be set by a master device whenever its transaction is
	terminated with Target-Abort. All master devices must implement this
	bit."

	^ self statusBit: 12
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetDetectedParityError [
	^ self resetStatusBit: 15
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetMasterDataParityError [
	^ self resetStatusBit: 8
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetReceivedMasterAbort [
	^ self resetStatusBit: 13
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetReceivedTargetAbort [
	^ self resetStatusBit: 12
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetSignaledSystemError [
	^ self resetStatusBit: 14
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetSignaledTargetAbort [
	^ self resetStatusBit: 11
]

{ #category : #'accessing - status' }
PCIBusEntry >> resetStatusBit: bit [
	^ self status: 1 << bit
]

{ #category : #'accessing - general config' }
PCIBusEntry >> revisionId [
	^ self configByte: 8
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> romAddressRegister [
	^ self configLong: 16r30
]

{ #category : #'accessing - addresses map' }
PCIBusEntry >> romAddressRegister: addr [
	^ self configLong: 16r30 put: addr
]

{ #category : #'accessing - status' }
PCIBusEntry >> signaledSystemError [
	" bit 14 - This bit must be set whenever the device asserts SERR#. Devices
	who will never assert SERR# do not need to implement this bit."

	^ self statusBit: 14
]

{ #category : #'accessing - status' }
PCIBusEntry >> signaledTargetAbort [
	" bit 11 - This bit must be set by a target device whenever it terminates a
	transaction with Target-Abort. Devices that will never signal Target-
	Abort do not need to implement this bit."

	^ self statusBit: 11
]

{ #category : #'accessing - bist' }
PCIBusEntry >> startBist [
	" bit 6 - Write a 1 to invoke BIST. Device resets the bit when BIST is complete.
	Software should fail the device if BIST is not complete after 2 seconds."

	^ self builtInSelfTest: (self builtInSelfTest bitOr: 64)
]

{ #category : #'accessing - status' }
PCIBusEntry >> status [
	^ self configShort: 6
]

{ #category : #'accessing - status' }
PCIBusEntry >> status: word [
	^ self configShort: 6 put: word
]

{ #category : #'accessing - status' }
PCIBusEntry >> statusBit: bit [
	^ self status anyMask: 1 << bit
]

{ #category : #printing }
PCIBusEntry >> stringForVendorAndDevice [
	^ self class stringForVendor: self vendorId device: self deviceId
]

{ #category : #'accessing - general config' }
PCIBusEntry >> subsystemId [
	^ self configShort: 16r2E
]

{ #category : #'accessing - general config' }
PCIBusEntry >> subsystemVendorId [
	^ self configShort: 16r2C
]

{ #category : #'accessing - command register' }
PCIBusEntry >> testCommandBit: bit [
	^ self command anyMask: 1 << bit

]

{ #category : #private }
PCIBusEntry >> translate: index [
	^ 16r80000000 + (bus << 16) + (device << 11) + (function << 8) + (index bitAnd: 16rFC)

]

{ #category : #'accessing - general config' }
PCIBusEntry >> vendorId [
	^ self configShort: 0
]
