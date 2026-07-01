'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PCIDevice category: 'SqueakNOS-Devices-Base'!
HardwareDevice subclass: #PCIDevice
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Base'!
!PCIDevice commentStamp: '<historical>' prior: 0!

I represent the base class for PCI device drivers. I almost don't provide
any extra API, except for instantiation, so my use is just organizational.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PCIDevice class' category: 'SqueakNOS-Devices-Base'!
PCIDevice class
	instanceVariableNames: ''!

!PCIDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	| pciEntry |
	pciEntry := PCIBusEntry allValid
		detect: [:e | e vendorId = self vendorId and: [e deviceId = self deviceId]]
		ifNone: [^ nil].
	^ self onPCIEntry: pciEntry computer: aComputer.

! !

!PCIDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPCIEntry: aPCIBusEntry
	^self onPort: aPCIBusEntry allIORanges first key

! !

!PCIDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
onPCIEntry: aPCIBusEntry computer: aComputer
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
! !


