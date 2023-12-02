Class {
	#name : #PCIBusMaster,
	#superclass : #PCIDevice,
	#instVars : [
		'channelOffset',
		'table',
		'function',
		'next',
		'offset'
	],
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #'as yet unclassified' }
PCIBusMaster class >> onPort: port function: pciEntry [
	^ (self onPort: port) function: pciEntry
]

{ #category : #initialization }
PCIBusMaster >> clearInterruptAndErrorBits [
	self status: (self status bitAnd: 2r11111001)
]

{ #category : #initialization }
PCIBusMaster >> command [
	^self byteAt: channelOffset + 0
]

{ #category : #initialization }
PCIBusMaster >> command: anInteger [
	self byteAt: channelOffset + 0 put: anInteger 
]

{ #category : #initialization }
PCIBusMaster >> entriesFor: size do: aBlock [
	| remaining chunkSize |
	remaining := size.
	[ remaining > 0 ] whileTrue: [
		chunkSize := remaining min: 65536.
		aBlock value: chunkSize.
		remaining := remaining - chunkSize]

	
]

{ #category : #initialization }
PCIBusMaster >> function: aPCIEntry [
	function := aPCIEntry 

]

{ #category : #initialization }
PCIBusMaster >> initialize [
	channelOffset := 0.
	table := PhysicalRegionDescriptorTable new.
	offset := 0.
]

{ #category : #initialization }
PCIBusMaster >> issueRead [
	self
		stopTransfer;
		setDescriptorTablePointerRegister;
		setDirectionToWriteIntoBus;
		clearInterruptAndErrorBits;
		startTransfer
]

{ #category : #initialization }
PCIBusMaster >> offset [
^offset
]

{ #category : #initialization }
PCIBusMaster >> resetDescriptorTable [
	table reset
]

{ #category : #initialization }
PCIBusMaster >> setDescriptorTablePointerRegister [
	self longAt: channelOffset + 4 put: table address
]

{ #category : #initialization }
PCIBusMaster >> setDirectionToReadFromBus [
	self command: (self command bitAnd: 2r11110111)
]

{ #category : #initialization }
PCIBusMaster >> setDirectionToWriteIntoBus [
	self command: (self command bitOr: 2r00001000)
]

{ #category : #initialization }
PCIBusMaster >> setupTransferOf: size with: buffer [
	| position |
	"buffer replaceFrom: 1 to: size with: 0."
	position := buffer asInteger + offset.
	self
		entriesFor: size
		do: [ :chunkSize | 
			table
				atNextFreeEntryPutSize: chunkSize address: position;
				advanceEntry.
			position := position + chunkSize ].
	table markEndOfTransfer
	"offset := offset + size"
]

{ #category : #initialization }
PCIBusMaster >> startTransfer [
	self
		command: (self command bitOr: 2r00000001)
]

{ #category : #initialization }
PCIBusMaster >> status [
	^self byteAt: channelOffset + 2
]

{ #category : #initialization }
PCIBusMaster >> status: anInteger [
	self byteAt: channelOffset + 2 put: anInteger
]

{ #category : #initialization }
PCIBusMaster >> stopTransfer [
	self command: (self command bitAnd: 16rFE)

]
