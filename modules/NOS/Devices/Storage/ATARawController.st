Class {
	#name : #ATARawController,
	#superclass : #PCIDevice,
	#instVars : [
		'control',
		'busMaster',
		'semaphore',
		'buffer',
		'done',
		'interrupted'
	],
	#classVars : [
		'primary',
		'secondary'
	],
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #accessing }
ATARawController >> handleIRQ [
	interrupted := true
]

{ #category : #accessing }
ATARawController >> initialize [
	| port |
	interrupted := false.
	buffer := ExternalAddress allocate: 128 * 1024.
	buffer fromInteger: (buffer asInteger alignedTo: 64 * 1024).

	control := ExternalIOPort address: 16r3F6.
	port := ATAController findPCIBusEntry baseIOAddress: 4.
	busMaster := ExternalIOPort address: port.
	Computer current interruptController addHandler: self forIRQ: 14.
	self unsignedByteAt: 6 put: 0.	"select disk"
	control uByteAtOffset: 1 put: 2r00001000	"clearing nIEN bit"
]

{ #category : #accessing }
ATARawController >> readSector [
	| short status |
	self unsignedByteAt: 6 put: 16rE0.	"(slavebit << 4) | ((addr >> 24) & 0x0F));"
	self unsignedByteAt: 1 put: 16r00.
	self unsignedByteAt: 2 put: 16r01.
	self unsignedByteAt: 3 put: 0.	"; addr"
	self unsignedByteAt: 4 put: 0.	"; addr >> 8"
	self unsignedByteAt: 5 put: 0.	"; addr >> 16"
	"self unsignedByteAt: 7 put: 0x30"	"; write command"
	self unsignedByteAt: 7 put: 16r20.	" ; read command"
	"wait 400ns"
	control
		unsignedByteAt: 1;
		unsignedByteAt: 1;
		unsignedByteAt: 1;
		unsignedByteAt: 1.
	"wait until not busy"
	[ status := control uByteAtOffset: 0.
	(status bitAnd: 2r10000000) = 0 ] whileFalse.

	"do read"
	buffer := ByteArray new: 512.
	1 to: 256 do: [ :i | 
		short := self unsignedShortAt: 0.
		buffer unsignedShortAt: i * 2 - 1 put: short ].
	^ buffer
]

{ #category : #accessing }
ATARawController >> readSectorDMA [
	| command status o |
	self selectFirstSector.
	self unsignedByteAt: 7 put: 16rC8.	" ; read DMA command"
	buffer unsignedLongAt: 1 put: buffer asInteger + 16r1000.
	buffer unsignedLongAt: 5 put: 16r80000200.	"size + end-of-transfer"

	"clear start/stop bit"
	command := busMaster unsignedByteAt: 0 + 1.
	busMaster unsignedByteAt: 0 + 1 put: (command bitAnd: 16rFE).
	busMaster unsignedLongAt: 4 + 1 put: buffer asInteger.	"set prdt"

	"set read bit"
	command := busMaster unsignedByteAt: 0 + 1.
	busMaster unsignedByteAt: 0 + 1 put: (command bitOr: 8).

	"clear interrupt and error status"
	status := busMaster unsignedByteAt: 2 + 1.
	busMaster unsignedByteAt: 2 + 1 put: (status bitAnd: 16rF3).

	"set start/stop bit"
	command := busMaster unsignedByteAt: 0 + 1.
	busMaster unsignedByteAt: 0 + 1 put: (command bitOr: 1).
	o := OrderedCollection new.
	[ interrupted ] whileFalse: [ o add: 1; removeFirst ]
]

{ #category : #accessing }
ATARawController >> selectFirstSector [
	self unsignedByteAt: 6 put: 16rE0.	"(slavebit << 4) | ((addr >> 24) & 0x0F));"
	self unsignedByteAt: 1 put: 16r00.
	self unsignedByteAt: 2 put: 16r01.
	self unsignedByteAt: 3 put: 0.	"; addr"
	self unsignedByteAt: 4 put: 0.	"; addr >> 8"
	self unsignedByteAt: 5 put: 0.	"; addr >> 16"

]
