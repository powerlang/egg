'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PCIBusMaster category: #'SqueakNOS-Devices-Storage'!
PCIDevice subclass: #PCIBusMaster
	instanceVariableNames: 'channelOffset table function next offset'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
clearInterruptAndErrorBits
	self status: (self status bitAnd: 2r11111001)
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
command
	^self byteAt: channelOffset + 0
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
command: anInteger
	self byteAt: channelOffset + 0 put: anInteger 
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesFor: size do: aBlock
	| remaining chunkSize |
	remaining := size.
	[ remaining > 0 ] whileTrue: [
		chunkSize := remaining min: 65536.
		aBlock value: chunkSize.
		remaining := remaining - chunkSize]

	
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
function: aPCIEntry
	function := aPCIEntry 

! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	channelOffset := 0.
	table := PhysicalRegionDescriptorTable new.
	offset := 0.
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
issueRead
	self
		stopTransfer;
		setDescriptorTablePointerRegister;
		setDirectionToWriteIntoBus;
		clearInterruptAndErrorBits;
		startTransfer
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
offset
^offset
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
resetDescriptorTable
	table reset
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
setDescriptorTablePointerRegister
	self longAt: channelOffset + 4 put: table address
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
setDirectionToReadFromBus
	self command: (self command bitAnd: 2r11110111)
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
setDirectionToWriteIntoBus
	self command: (self command bitOr: 2r00001000)
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
setupTransferOf: size with: buffer
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
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
startTransfer
	self
		command: (self command bitOr: 2r00000001)
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
status
	^self byteAt: channelOffset + 2
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
status: anInteger
	self byteAt: channelOffset + 2 put: anInteger
! !

!PCIBusMaster methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
stopTransfer
	self command: (self command bitAnd: 16rFE)

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PCIBusMaster class' category: #'SqueakNOS-Devices-Storage'!
PCIBusMaster class
	instanceVariableNames: ''!

!PCIBusMaster class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPort: port function: pciEntry
	^ (self onPort: port) function: pciEntry
! !


PCIBusMaster initialize!

