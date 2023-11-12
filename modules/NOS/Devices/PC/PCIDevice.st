Class {
	#name : #PCIDevice,
	#superclass : #HardwareDevice,
	#category : #'SqueakNOS-Devices-Base'
}

{ #category : #'instance creation' }
PCIDevice class >> installOn: aComputer [
	| pciEntry |
	pciEntry := PCIBusEntry allValid
		detect: [:e | e vendorId = self vendorId and: [e deviceId = self deviceId]]
		ifNone: [^ nil].
	^ self onPCIEntry: pciEntry computer: aComputer.

]

{ #category : #'instance creation' }
PCIDevice class >> onPCIEntry: aPCIBusEntry [
	^self onPort: aPCIBusEntry allIORanges first key

]

{ #category : #'instance creation' }
PCIDevice class >> onPCIEntry: aPCIBusEntry computer: aComputer [
	| answer |
	answer := self onPCIEntry: aPCIBusEntry.

	aPCIBusEntry
		enableBusMastering;
		enableIO.

	" copyed from GRUB, not sure if needed or not:"
	aPCIBusEntry latencyTimer < 32 ifTrue: [aPCIBusEntry latencyTimer: 32].

	aComputer interruptController
		addHandler: answer
		forIRQ: aPCIBusEntry interruptLine.

	^ answer
]
